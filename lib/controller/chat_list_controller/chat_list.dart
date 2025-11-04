
import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListController extends GetxController {
  var chats = [].obs;
  var isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription? _chatSub;

  // ✅ Start or open a chat with a friend by phone number
  Future<void> startChatWithPhone(String phone) async {
    try {
      final currentUser = _auth.currentUser!;
      final usersRef = _firestore.collection('users');

      // Find friend by phone
      final friendSnapshot =
      await usersRef.where('phone', isEqualTo: phone).limit(1).get();

      if (friendSnapshot.docs.isEmpty) {
        Get.snackbar("User not found", "No user found with that phone number.");
        return;
      }

      final friendData = friendSnapshot.docs.first.data();
      final friendId = friendSnapshot.docs.first.id;

      // Create deterministic chat ID
      final sortedIds = [currentUser.uid, friendId]..sort();
      final chatId = "${sortedIds[0]}_${sortedIds[1]}";
      final chatRef = _firestore.collection('chats').doc(chatId);

      // Check if chat exists
      final chatDoc = await chatRef.get();

      if (!chatDoc.exists) {
        await chatRef.set({
          'members': [currentUser.uid, friendId],
          'names': {
            currentUser.uid: currentUser.displayName ?? 'You',
            friendId: friendData['name'] ?? 'Friend'
          },
          'lastMessage': '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(), // <-- add this
        });
      }

      Get.snackbar("Chat Ready", "Chat created successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void loadChats() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    isLoading.value = true;

    _chatSub?.cancel();
    _chatSub = _firestore
        .collection('chats')
        .where('members', arrayContains: currentUserId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      chats.value = snapshot.docs.map((doc) {
        final data = doc.data();
        final members = List<String>.from(data['members'] ?? []);

        // skip malformed chats
        if (members.length < 2) return null;

        final otherUserId = members.firstWhere(
              (id) => id != currentUserId,
          orElse: () => currentUserId, // fallback
        );

        return {
          'chatId': doc.id,
          'userId': otherUserId,
          'name': (data['names'] != null && data['names'][otherUserId] != null)
              ? data['names'][otherUserId]
              : 'User',
          'lastMessage': data['lastMessage'] ?? '',
        };
      }).whereType<Map>().toList();

      isLoading.value = false;
    }, onError: (error) {
      isLoading.value = false;
      Get.snackbar("Error", "Failed to load chats: $error");
    });
  }


  @override
  void onClose() {
    _chatSub?.cancel();
    super.onClose();
  }
}
