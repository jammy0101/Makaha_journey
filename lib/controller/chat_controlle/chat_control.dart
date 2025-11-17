
//
// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import '../../model/message_model/message_model.dart';
// import '../services/notification_services.dart';
//
//
// class ChatController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   var messages = <MessageModel>[].obs;
//
//   String? currentChatId;
//   bool isInChat = false;
//
//   StreamSubscription? _chatSubscription;
//   StreamSubscription? _chatsListSubscription;
//
//   /// chatId -> subscription (only for latest message notifications)
//   final Map<String, StreamSubscription> _messageSubscriptions = {};
//
//   @override
//   void onInit() {
//     super.onInit();
//     _listenAllChatsForNotifications();
//   }
//
//   @override
//   void onClose() {
//     _chatSubscription?.cancel();
//     _chatsListSubscription?.cancel();
//     for (var sub in _messageSubscriptions.values) {
//       sub.cancel();
//     }
//     _messageSubscriptions.clear();
//     super.onClose();
//   }
//
//
//   Future<void> clearChatForMe(String receiverId) async {
//     final currentUserId = _auth.currentUser?.uid;
//     if (currentUserId == null) return;
//
//     final sortedIds = [currentUserId, receiverId]..sort();
//     final chatId = "${sortedIds[0]}_${sortedIds[1]}";
//     final chatRef = _firestore.collection('chats').doc(chatId);
//
//     // Fetch ALL messages of this chat
//     final snapshot = await chatRef.collection('messages').get();
//
//     final batch = _firestore.batch();
//
//     for (var doc in snapshot.docs) {
//       batch.update(doc.reference, {
//         'hiddenFor': FieldValue.arrayUnion([currentUserId])
//       });
//     }
//
//     await batch.commit();
//
//     // Remove ALL messages from UI for me only
//     messages.removeWhere((m) => !m.hiddenFor.contains(currentUserId));
//   }
//
//
//   Future<void> deleteForMe(MessageModel msg) async {
//     final uid = _auth.currentUser!.uid;
//
//     await _firestore
//         .collection('chats')
//         .doc(currentChatId)
//         .collection('messages')
//         .doc(msg.id)
//         .update({
//       'hiddenFor': FieldValue.arrayUnion([uid]),
//     });
//
//     messages.removeWhere((m) => m.id == msg.id);
//   }
//
//   Future<void> deleteForEveryone(MessageModel msg) async {
//     final chatRef = _firestore
//         .collection('chats')
//         .doc(currentChatId)
//         .collection('messages')
//         .doc(msg.id);
//
//     await chatRef.update({
//       'message': "🚫 This message was deleted",
//       'isSeen': true,      // prevent blue ticks after deletion
//     });
//
//     // Update local UI
//     final index = messages.indexWhere((m) => m.id == msg.id);
//     if (index != -1) {
//       messages[index] = messages[index].copyWith(message: "🚫 This message was deleted");
//     }
//   }
//
//
//   Future<void> editMessage(MessageModel msg, String newText) async {
//     if (newText.isEmpty) return;
//
//     final chatRef = _firestore
//         .collection('chats')
//         .doc(currentChatId)
//         .collection('messages')
//         .doc(msg.id);
//
//     await chatRef.update({
//       'message': newText,
//     });
//
//     // Update UI
//     final index = messages.indexWhere((m) => m.id == msg.id);
//     if (index != -1) {
//       messages[index] = messages[index].copyWith(message: newText);
//     }
//   }
//
//
//
//   /// watch chats collection for chats that include current user, maintain subscriptions map
//   void _listenAllChatsForNotifications() {
//     final currentUserId = _auth.currentUser?.uid;
//     if (currentUserId == null) return;
//
//     _chatsListSubscription = _firestore
//         .collection('chats')
//         .where('members', arrayContains: currentUserId)
//         .snapshots()
//         .listen((snapshot) {
//       final activeChatIds = snapshot.docs.map((d) => d.id).toSet();
//
//       // remove subscriptions for chats that no longer exist
//       final toRemove = _messageSubscriptions.keys.where((id) => !activeChatIds.contains(id)).toList();
//       for (final id in toRemove) {
//         _messageSubscriptions[id]?.cancel();
//         _messageSubscriptions.remove(id);
//       }
//
//       // add new subscriptions for new chats
//       for (var chatDoc in snapshot.docs) {
//         final chatId = chatDoc.id;
//         if (_messageSubscriptions.containsKey(chatId)) continue;
//
//         final sub = _firestore
//             .collection('chats')
//             .doc(chatId)
//             .collection('messages')
//             .orderBy('timestamp', descending: true)
//             .limit(1) // only latest message needed for notifications
//             .snapshots()
//             .listen((snap) async {
//           if (snap.docs.isEmpty) return;
//
//           final doc = snap.docs.first;
//           final msg = MessageModel.fromDoc(doc);
//
//           // notify if:
//           // - message is not from me
//           // - message is not seen
//           // - and I'm not currently inside this chat (currentChatId)
//           if (msg.senderId != currentUserId && !msg.isSeen && chatId != currentChatId) {
//             // fetch sender name if needed
//             final senderDoc = await _firestore.collection('users').doc(msg.senderId).get();
//             final senderName = senderDoc.data()?['name'] ?? 'Friend';
//             await NotificationService.showLocalNotification(
//               title: '🔔 New message from $senderName',
//               body: msg.message,
//               payload: msg.senderId, // payload set to senderId so we can open chat with them
//             );
//           }
//         });
//
//         _messageSubscriptions[chatId] = sub;
//       }
//     });
//   }
//
//   /// initialize and listen messages for a one-to-one chat with [receiverId]
//   Future<void> initChat(String receiverId) async {
//     final currentUserId = _auth.currentUser?.uid;
//     if (currentUserId == null) return;
//
//     final sortedIds = [currentUserId, receiverId]..sort();
//     currentChatId = "${sortedIds[0]}_${sortedIds[1]}";
//
//     final chatRef = _firestore.collection('chats').doc(currentChatId);
//
//     final chatDoc = await chatRef.get();
//     if (!chatDoc.exists) {
//       await chatRef.set({
//         'members': [currentUserId, receiverId],
//         'lastMessage': '',
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     }
//
//     // cancel previous chat subscription
//     await _chatSubscription?.cancel();
//
//     _chatSubscription = chatRef
//         .collection('messages')
//         .orderBy('timestamp') // oldest first
//         .snapshots()
//         .listen((snapshot) async {
//       final chatMessages = snapshot.docs.map((d) => MessageModel.fromDoc(d)).toList();
//       messages.value = chatMessages;
//
//       // mark unseen messages as seen if user is in chat
//       if (isInChat) {
//         for (var doc in snapshot.docs) {
//           final map = doc.data() as Map<String, dynamic>;
//           final senderId = map['senderId'] as String?;
//           final isSeenValue = map['isSeen'] as bool? ?? false;
//           if (senderId != null && senderId != currentUserId && !isSeenValue) {
//             try {
//               await doc.reference.update({'isSeen': true});
//             } catch (_) {
//               // ignore update errors for now
//             }
//           }
//         }
//       }
//
//       // auto-scroll to bottom when new messages arrive (UI will handle via controller)
//       // UI uses WidgetsBinding.postFrameCallback to scroll after setState
//     });
//   }
//
//   /// send a text message to receiverId
//   Future<void> sendMessage(String receiverId, String text) async {
//     final senderId = _auth.currentUser?.uid;
//     if (senderId == null) return;
//     if (text.trim().isEmpty) return;
//
//     final sortedIds = [senderId, receiverId]..sort();
//     final chatId = "${sortedIds[0]}_${sortedIds[1]}";
//     final chatRef = _firestore.collection('chats').doc(chatId);
//
//     // ensure chat exists
//     final chatDoc = await chatRef.get();
//     if (!chatDoc.exists) {
//       await chatRef.set({
//         'members': [senderId, receiverId],
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     }
//
//     final messageMap = {
//       'senderId': senderId,
//       'receiverId': receiverId,
//       'message': text.trim(),
//       'isSeen': false,
//       'timestamp': FieldValue.serverTimestamp(), // server time always
//     };
//
//     final docRef = await chatRef.collection('messages').add(messageMap);
//
//     // Save the generated id inside the document (optional but helpful)
//     await docRef.update({'id': docRef.id});
//
//     // update chat metadata
//     await chatRef.update({
//       'lastMessage': text.trim(),
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }
//
//   /// remove all messages of this chat (careful: uses batch)
//   Future<void> clearChat(String receiverId) async {
//     final currentUserId = _auth.currentUser?.uid;
//     if (currentUserId == null) return;
//
//     final sortedIds = [currentUserId, receiverId]..sort();
//     final chatId = "${sortedIds[0]}_${sortedIds[1]}";
//     final chatRef = _firestore.collection('chats').doc(chatId);
//
//     final messagesSnapshot = await chatRef.collection('messages').get();
//     final batch = _firestore.batch();
//     for (var doc in messagesSnapshot.docs) {
//       batch.delete(doc.reference);
//     }
//     batch.update(chatRef, {
//       'lastMessage': '',
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//     await batch.commit();
//
//     messages.removeWhere((m) => m.senderId == receiverId || m.receiverId == receiverId);
//   }
// }

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
