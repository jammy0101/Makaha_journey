

import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListController extends GetxController {
  var chats = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isLoaded = false.obs; // For performance: track first load

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription? _chatSub;

  @override
  void onInit() {
    super.onInit();
    // Don't call loadChats() inside build, we can call it from UI once
  }

  @override
  void onClose() {
    _chatSub?.cancel();
    super.onClose();
  }

  Future<bool> startChatWithPhone(String phone) async {
    try {
      final currentUser = _auth.currentUser!;
      final usersRef = _firestore.collection('users');

      final friendSnapshot =
      await usersRef.where('phone', isEqualTo: phone).limit(1).get();
      if (friendSnapshot.docs.isEmpty) return false;

      final friendData = friendSnapshot.docs.first.data();
      final friendId = friendSnapshot.docs.first.id;

      final sortedIds = [currentUser.uid, friendId]..sort();
      final chatId = "${sortedIds[0]}_${sortedIds[1]}";
      final chatRef = _firestore.collection('chats').doc(chatId);

      if (!await chatRef.get().then((doc) => doc.exists)) {
        await chatRef.set({
          'members': [currentUser.uid, friendId],
          'names': {
            currentUser.uid: currentUser.displayName ?? 'You',
            friendId: friendData['name'] ?? 'Friend',
          },
          'lastMessage': '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  // ✅ Optimized loadChats
  void loadChats() async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;

    isLoading.value = true;

    _chatSub?.cancel();
    _chatSub = _firestore
        .collection('chats')
        .where('members', arrayContains: currentUserId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .listen((snapshot) async {
      final tempChats = <Map<String, dynamic>>[];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final members = List<String>.from(data['members'] ?? []);
        if (members.length < 2) continue;

        final otherUserId = members.firstWhere(
              (id) => id != currentUserId,
          orElse: () => currentUserId,
        );

        // Use cached lastMessage from chat document
        final lastMessage = data['lastMessage'] ?? '';

        tempChats.add({
          'chatId': doc.id,
          'userId': otherUserId,
          'name': (data['names'] != null && data['names'][otherUserId] != null)
              ? data['names'][otherUserId]
              : 'User',
          'lastMessage': lastMessage,
        });
      }

      chats.value = tempChats;
      isLoading.value = false;
      isLoaded.value = true;
    });
  }
}
