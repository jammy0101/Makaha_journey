//
//
// import 'dart:async';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../model/message_model/message_model.dart';
// import '../services/notification_services.dart';
//
//
// class ChatController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   var messages = <MessageModel>[].obs;
//   String? chatId;
//   var receiverStatus = "Last seen recently".obs;
//
//   StreamSubscription? _messageSubscription;
//
//   /// Initialize chat between current user and receiver
//   Future<void> initChat(String receiverId) async {
//     final currentUserId = _auth.currentUser?.uid;
//     if (currentUserId == null) return;
//
//     // Generate unique chat ID (sorted by user IDs)
//     final sortedIds = [currentUserId, receiverId]..sort();
//     chatId = "${sortedIds[0]}_${sortedIds[1]}";
//
//     final chatRef = _firestore.collection('chats').doc(chatId);
//     final chatDoc = await chatRef.get();
//
//     // Create chat document if not exists
//     if (!chatDoc.exists) {
//       await chatRef.set({
//         'members': [currentUserId, receiverId],
//         'names': {
//           currentUserId: _auth.currentUser?.displayName ?? 'You',
//           receiverId: 'Friend',
//         },
//         'lastMessage': '',
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     }
//
//     listenMessages();
//     markMessagesAsSeen();
//   }
//
//   /// Listen for new messages in real-time
//   void listenMessages() {
//     if (chatId == null) return;
//
//     _messageSubscription?.cancel();
//     _messageSubscription = _firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .listen((snapshot) async {
//       final newMessages =
//       snapshot.docs.map((doc) => MessageModel.fromMap(doc.data())).toList();
//
//       if (messages.isNotEmpty &&
//           newMessages.isNotEmpty &&
//           newMessages.first.timestamp != messages.first.timestamp) {
//         final latest = newMessages.first;
//
//         // Only notify if message is from someone else
//         if (latest.senderId != _auth.currentUser?.uid) {
//           final senderDoc =
//           await _firestore.collection('users').doc(latest.senderId).get();
//           final senderName = senderDoc.data()?['name'] ?? 'Someone';
//
//           await NotificationService.showLocalNotification(
//             title: '🔔 New message from $senderName',
//             body: latest.message,
//             payload: latest.senderId,
//           );
//         }
//       }
//
//       messages.value = newMessages;
//       markMessagesAsSeen();
//     });
//   }
//
//   /// Send a message
//   Future<void> sendMessage(String receiverId, String text) async {
//     if (text.trim().isEmpty || chatId == null) return;
//
//     final senderId = _auth.currentUser?.uid;
//     if (senderId == null) return;
//
//     final newMessage = MessageModel(
//       senderId: senderId,
//       receiverId: receiverId,
//       message: text.trim(),
//       timestamp: DateTime.now(),
//       isSeen: false,
//     );
//
//     final chatRef = _firestore.collection('chats').doc(chatId);
//     await chatRef.collection('messages').add(newMessage.toMap());
//
//     await chatRef.update({
//       'lastMessage': text.trim(),
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }
//
//   /// Clear entire chat messages
//   Future<void> clearChat() async {
//     if (chatId == null) return;
//     final chatRef = _firestore.collection('chats').doc(chatId);
//     final batch = _firestore.batch();
//
//     final messagesSnapshot = await chatRef.collection('messages').get();
//     for (var doc in messagesSnapshot.docs) {
//       batch.delete(doc.reference);
//     }
//
//     batch.update(chatRef, {
//       'lastMessage': '',
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//
//     await batch.commit();
//     messages.clear();
//   }
//
//   /// Mark all unseen messages as seen
//   Future<void> markMessagesAsSeen() async {
//     if (chatId == null) return;
//     final currentUserId = _auth.currentUser?.uid;
//     if (currentUserId == null) return;
//
//     final chatRef = _firestore.collection('chats').doc(chatId);
//     final unseenMessages = await chatRef
//         .collection('messages')
//         .where('receiverId', isEqualTo: currentUserId)
//         .where('isSeen', isEqualTo: false)
//         .get();
//
//     for (var doc in unseenMessages.docs) {
//       doc.reference.update({'isSeen': true});
//     }
//   }
//
//   @override
//   void onClose() {
//     _messageSubscription?.cancel();
//     super.onClose();
//   }
// }
import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/message_model/message_model.dart';
import '../services/notification_services.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var messages = <MessageModel>[].obs;
  var receiverStatus = "Last seen recently".obs;

  StreamSubscription? _chatSubscription;
  Map<String, StreamSubscription> _messageSubscriptions = {};

  @override
  void onInit() {
    super.onInit();
    _listenAllChats(); // Listen globally for all chats
  }

  /// Listen to all chats for current user
  void _listenAllChats() {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;

    _chatSubscription?.cancel();
    _chatSubscription = _firestore
        .collection('chats')
        .where('members', arrayContains: currentUserId)
        .snapshots()
        .listen((chatSnapshots) {
      for (var chatDoc in chatSnapshots.docs) {
        final chatId = chatDoc.id;
        if (!_messageSubscriptions.containsKey(chatId)) {
          _listenMessagesInChat(chatId);
        }
      }
    });
  }

  /// Listen messages in a specific chat and show in-app notifications
  void _listenMessagesInChat(String chatId) {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;

    _messageSubscriptions[chatId] = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) async {
      final newMessages =
      snapshot.docs.map((doc) => MessageModel.fromMap(doc.data())).toList();

      if (newMessages.isEmpty) return;

      final latest = newMessages.first;

      // Notify only if message is from someone else
      if (latest.senderId != currentUserId && !latest.isSeen) {
        final senderDoc =
        await _firestore.collection('users').doc(latest.senderId).get();
        final senderName = senderDoc.data()?['name'] ?? 'Someone';

        // Show in-app notification
        await NotificationService.showLocalNotification(
          title: "🔔 New message from $senderName",
          body: latest.message,
          payload: latest.senderId, // receiverId
        );
      }
    });
  }

  /// Initialize chat messages for current open chat
  Future<void> initChat(String receiverId) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;

    final sortedIds = [currentUserId, receiverId]..sort();
    final chatId = "${sortedIds[0]}_${sortedIds[1]}";

    final chatRef = _firestore.collection('chats').doc(chatId);
    final chatDoc = await chatRef.get();

    if (!chatDoc.exists) {
      await chatRef.set({
        'members': [currentUserId, receiverId],
        'names': {currentUserId: 'You', receiverId: 'Friend'},
        'lastMessage': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    // Listen messages for this chat
    _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value =
          snapshot.docs.map((doc) => MessageModel.fromMap(doc.data())).toList();
    });
  }

  /// Send a message
  Future<void> sendMessage(String receiverId, String text) async {
    if (text.trim().isEmpty) return;
    final senderId = _auth.currentUser?.uid;
    if (senderId == null) return;

    final sortedIds = [senderId, receiverId]..sort();
    final chatId = "${sortedIds[0]}_${sortedIds[1]}";

    final chatRef = _firestore.collection('chats').doc(chatId);
    final chatDoc = await chatRef.get();

    if (!chatDoc.exists) {
      await chatRef.set({
        'members': [senderId, receiverId],
        'names': {senderId: 'You', receiverId: 'Friend'},
        'lastMessage': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    final newMessage = MessageModel(
      senderId: senderId,
      receiverId: receiverId,
      message: text.trim(),
      timestamp: DateTime.now(),
      isSeen: false,
    );

    await chatRef.collection('messages').add(newMessage.toMap());
    await chatRef.update({
      'lastMessage': text.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Clear chat messages for a specific receiver
  Future<void> clearChat(String receiverId) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;

    final sortedIds = [currentUserId, receiverId]..sort();
    final chatId = "${sortedIds[0]}_${sortedIds[1]}";

    final chatRef = _firestore.collection('chats').doc(chatId);

    final batch = _firestore.batch();
    final messagesSnapshot = await chatRef.collection('messages').get();
    for (var doc in messagesSnapshot.docs) {
      batch.delete(doc.reference);
    }

    batch.update(chatRef, {
      'lastMessage': '',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
    messages.removeWhere(
            (msg) => msg.receiverId == receiverId || msg.senderId == receiverId);
  }

  @override
  void onClose() {
    _chatSubscription?.cancel();
    _messageSubscriptions.forEach((_, sub) => sub.cancel());
    super.onClose();
  }
}
