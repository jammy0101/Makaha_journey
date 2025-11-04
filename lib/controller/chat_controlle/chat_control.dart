
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/message_model/message_model.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var messages = <MessageModel>[].obs;
  String? chatId; // make nullable to avoid premature access

  /// ✅ Initializes chat between current user and receiver.
  Future<void> initChat(String receiverId) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;

    // Sort IDs to ensure consistent chatId (A_B same as B_A)
    final sortedIds = [currentUserId, receiverId]..sort();
    chatId = "${sortedIds[0]}_${sortedIds[1]}";

    final chatRef = _firestore.collection('chats').doc(chatId);
    final chatDoc = await chatRef.get();

    // ✅ Create chat doc if it doesn't exist
    if (!chatDoc.exists) {
      await chatRef.set({
        'members': [currentUserId, receiverId],
        'names': {
          currentUserId: _auth.currentUser?.displayName ?? 'You',
          receiverId: 'Friend',
        },
        'lastMessage': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    // ✅ Start listening for messages after ensuring chat exists
    listenMessages();
  }

  /// ✅ Sends a new message to the chat
  Future<void> sendMessage(String receiverId, String text) async {
    if (text.trim().isEmpty || chatId == null) return;

    final senderId = _auth.currentUser?.uid;
    if (senderId == null) return;

    final newMessage = MessageModel(
      senderId: senderId,
      receiverId: receiverId,
      message: text.trim(),
      timestamp: DateTime.now(),
    );

    final chatRef = _firestore.collection('chats').doc(chatId);

    // Add message to messages subcollection
    await chatRef.collection('messages').add(newMessage.toMap());

    // Update chat’s last message metadata
    await chatRef.update({
      'lastMessage': text.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// ✅ Real-time message listener
  void listenMessages() {
    if (chatId == null) return;

    _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .toList();
    });
  }
}
