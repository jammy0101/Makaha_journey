

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../model/message_model/message_model.dart';

class ChatController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  var messages = <MessageModel>[].obs;

  String? currentChatId;
  bool isInChat = false;

  StreamSubscription? _chatSubscription;

  /// TYPING INDICATOR
  var isReceiverTyping = false.obs;

  @override
  void onClose() {
    _chatSubscription?.cancel();
    super.onClose();
  }

  // ----------------------------------------------------------
  // SET TYPING STATUS
  // ----------------------------------------------------------
  Future<void> setTyping(String receiverId, bool isTyping) async {
    final uid = _auth.currentUser!.uid;

    final sortedIds = [uid, receiverId]..sort();
    final chatId = "${sortedIds[0]}_${sortedIds[1]}";

    await _firestore.collection('chats').doc(chatId).set({
      'typing': {uid: isTyping}
    }, SetOptions(merge: true));
  }

  // ----------------------------------------------------------
  // INIT CHAT
  // ----------------------------------------------------------
  Future<void> initChat(String receiverId) async {
    final uid = _auth.currentUser!.uid;

    final sortedIds = [uid, receiverId]..sort();
    currentChatId = "${sortedIds[0]}_${sortedIds[1]}";

    final chatRef = _firestore.collection('chats').doc(currentChatId);

    if (!(await chatRef.get()).exists) {
      await chatRef.set({
        'members': [uid, receiverId],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'typing': {},
      });
    }

    // Listen to typing indicator
    chatRef.snapshots().listen((doc) {
      final data = doc.data();
      final typingMap = data?['typing'] ?? {};

      /// If receiver typing = true → show indicator
      isReceiverTyping.value = typingMap[receiverId] ?? false;
    });

    // Cancel previous subscription
    await _chatSubscription?.cancel();

    _chatSubscription = chatRef
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) async {
      messages.value =
          snapshot.docs.map((d) => MessageModel.fromDoc(d)).toList();

      // Mark messages delivered & seen
      for (var doc in snapshot.docs) {
        final map = doc.data() as Map<String, dynamic>;
        final senderId = map['senderId'];
        final delivered = map['delivered'] ?? false;
        final isSeenValue = map['isSeen'] ?? false;

        // mark delivered
        if (senderId != uid && delivered == false) {
          await doc.reference.update({'delivered': true});
        }

        // mark seen
        if (senderId != uid && !isSeenValue && isInChat) {
          await doc.reference.update({'isSeen': true});
        }
      }
    });
  }

  // ----------------------------------------------------------
  // SEND MESSAGE
  // ----------------------------------------------------------
  Future<void> sendMessage(String receiverId, String text) async {
    final uid = _auth.currentUser!.uid;

    final sortedIds = [uid, receiverId]..sort();
    final chatId = "${sortedIds[0]}_${sortedIds[1]}";

    final chatRef = _firestore.collection('chats').doc(chatId);

    final map = {
      'senderId': uid,
      'receiverId': receiverId,
      'message': text,
      'delivered': false,
      'isSeen': false,
      'hiddenFor': [],
      'timestamp': FieldValue.serverTimestamp()
    };

    final docRef = await chatRef.collection('messages').add(map);
    await docRef.update({'id': docRef.id});

    await chatRef.update({
      'lastMessage': text,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // stop typing after send
    setTyping(receiverId, false);
  }

  // ----------------------------------------------------------
  // DELETE FOR ME
  // ----------------------------------------------------------
  Future<void> deleteForMe(MessageModel msg) async {
    final uid = _auth.currentUser!.uid;

    final ref = _firestore
        .collection('chats')
        .doc(currentChatId)
        .collection('messages')
        .doc(msg.id);

    await ref.update({
      'hiddenFor': FieldValue.arrayUnion([uid]),
    });

    messages.removeWhere((m) => m.id == msg.id);
  }

  // ----------------------------------------------------------
  // DELETE FOR EVERYONE
  // ----------------------------------------------------------
  Future<void> deleteForEveryone(MessageModel msg) async {
    final ref = _firestore
        .collection('chats')
        .doc(currentChatId)
        .collection('messages')
        .doc(msg.id);

    await ref.update({
      'message': "🚫 This message was deleted",
      'isSeen': true,
    });

    final index = messages.indexWhere((m) => m.id == msg.id);
    if (index != -1) {
      messages[index] =
          messages[index].copyWith(message: "🚫 This message was deleted");
    }
  }

  // ----------------------------------------------------------
  // EDIT MESSAGE
  // ----------------------------------------------------------
  Future<void> editMessage(MessageModel msg, String newText) async {
    if (newText.isEmpty) return;

    final ref = _firestore
        .collection('chats')
        .doc(currentChatId)
        .collection('messages')
        .doc(msg.id);

    await ref.update({'message': newText});

    final index = messages.indexWhere((m) => m.id == msg.id);
    if (index != -1) {
      messages[index] = messages[index].copyWith(message: newText);
    }
  }

  // ----------------------------------------------------------
  // CLEAR CHAT FOR ME ONLY
  // ----------------------------------------------------------
  Future<void> clearChatForMe(String receiverId) async {
    final uid = _auth.currentUser!.uid;

    final sortedIds = [uid, receiverId]..sort();
    final chatId = "${sortedIds[0]}_${sortedIds[1]}";

    final chatRef = _firestore.collection('chats').doc(chatId);

    final snapshot = await chatRef.collection('messages').get();

    final batch = _firestore.batch();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {
        'hiddenFor': FieldValue.arrayUnion([uid])
      });
    }

    await batch.commit();

    messages.removeWhere((m) => !m.hiddenFor.contains(uid));
  }
}
