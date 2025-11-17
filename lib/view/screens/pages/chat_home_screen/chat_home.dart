//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../controller/chat_list_controller/chat_list.dart';
// import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
// import '../../../../resources/colors/colors.dart';
// import '../chat/chat.dart';
//
// class ChatsHomeScreen extends StatelessWidget {
//   final ChatListController controller = Get.put(ChatListController());
//
//   ChatsHomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     controller.loadChats();
//     final theme = Theme.of(context);
//
//     return Scaffold(
//       backgroundColor: AppColor.softBeige,
//       appBar: AppBar(
//         title: const Text('Chats'),
//         centerTitle: true,
//         elevation: 2,
//         backgroundColor: AppColor.emeraldGreen,
//         foregroundColor: AppColor.whiteColor,
//       ),
//
//       // New Chat Button
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: AppColor.emeraldGreen,
//         icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColor.whiteColor),
//         label: const Text(
//           "New Chat",
//           style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.whiteColor),
//         ),
//         onPressed: () => _showStartChatDialog(context),
//       ),
//
//       bottomNavigationBar: const BottomNavigation(index: 2),
//
//       // Chat List
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(color: AppColor.emeraldGreen),
//           );
//         }
//
//         if (controller.chats.isEmpty) {
//           return Center(
//             child: Text(
//               'No chats yet.\nStart a new conversation!',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: AppColor.deepCharcoal.withOpacity(0.6),
//                 fontSize: 16,
//               ),
//             ),
//           );
//         }
//
//         return ListView.separated(
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//           itemCount: controller.chats.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 6),
//           itemBuilder: (context, index) {
//             final chat = controller.chats[index];
//             final name = chat['name'] ?? 'Unknown';
//             final lastMsg = chat['lastMessage'] ?? '';
//             final userId = chat['userId'] ?? '';
//
//             return GestureDetector(
//               onTap: () {
//                 Get.to(() => ChatScreen(
//                   receiverId: userId,
//                   receiverName: name,
//                 ));
//               },
//               child: Container(
//                 margin: const EdgeInsets.symmetric(vertical: 4),
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: AppColor.whiteCream,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColor.deepCharcoal.withOpacity(0.05),
//                       blurRadius: 6,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Hero(
//                       tag: "chatAvatar_$userId",
//                       child: CircleAvatar(
//                         radius: 26,
//                         backgroundColor: AppColor.emeraldGreen.withOpacity(0.2),
//                         child: Text(
//                           name.isNotEmpty ? name[0].toUpperCase() : "?",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: AppColor.emeraldGreen,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 14),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             name,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                               color: AppColor.deepCharcoal,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             lastMsg,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: AppColor.deepCharcoal.withOpacity(0.6),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColor.deepCharcoal),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
//
//   void _showStartChatDialog(BuildContext context) {
//     final phoneController = TextEditingController();
//
//     Get.dialog(
//       AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         backgroundColor: AppColor.whiteCream,
//         title: Row(
//           children: [
//             Icon(Icons.chat_outlined, color: AppColor.emeraldGreen),
//             const SizedBox(width: 8),
//             const Text(
//               "Start Chat",
//               style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.deepCharcoal),
//             ),
//           ],
//         ),
//         content: TextField(
//           controller: phoneController,
//           keyboardType: TextInputType.phone,
//           decoration: InputDecoration(
//             hintText: "Enter friend's phone number",
//             prefixIcon: const Icon(Icons.phone),
//             filled: true,
//             fillColor: AppColor.softBeige,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: const Text(
//               "Cancel",
//               style: TextStyle(color: AppColor.emeraldGreen),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColor.emeraldGreen,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//             onPressed: () async {
//               final phone = phoneController.text.trim();
//               Get.back();
//               if (phone.isEmpty) {
//                 Get.snackbar(
//                   "Error",
//                   "Enter phone number",
//                   backgroundColor: AppColor.error.withOpacity(0.2),
//                   colorText: AppColor.deepCharcoal,
//                 );
//                 return;
//               }
//               final isFound = await controller.startChatWithPhone(phone);
//               Get.snackbar(
//                 isFound ? "Chat Ready" : "User not found",
//                 isFound
//                     ? "Chat created successfully!"
//                     : "No user found with that phone number.",
//                 backgroundColor:
//                 isFound ? AppColor.emeraldGreen.withOpacity(0.2) : AppColor.error.withOpacity(0.2),
//                 colorText: AppColor.deepCharcoal,
//               );
//             },
//             child: const Text("Start", style: TextStyle(color: AppColor.whiteColor)),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/chat_list_controller/chat_list.dart';
import '../../../../model/message_model/message_model.dart';
import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
import '../../../../resources/colors/colors.dart';
import '../chat/chat.dart';

class ChatsHomeScreen extends StatelessWidget {
  final ChatListController controller = Get.put(ChatListController());

  ChatsHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load chats once after first frame (better than calling inside build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.isLoaded.value) {
        controller.loadChats();
      }
    });

    return Scaffold(
      backgroundColor: AppColor.softBeige,
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: AppColor.emeraldGreen,
        foregroundColor: AppColor.whiteColor,
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.emeraldGreen,
        icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColor.whiteColor),
        label: const Text(
          "New Chat",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.whiteColor),
        ),
        onPressed: () => _showStartChatDialog(context),
      ),

      bottomNavigationBar: const BottomNavigation(index: 2),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.emeraldGreen),
          );
        }

        if (controller.chats.isEmpty) {
          return Center(
            child: Text(
              'No chats yet.\nStart a new conversation!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.deepCharcoal.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
          );
        }

        // ListView.builder is already efficient for large lists
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          itemCount: controller.chats.length,
          separatorBuilder: (_, __) => const SizedBox(height: 6),
          itemBuilder: (context, index) {
            final chat = controller.chats[index];
            return ChatItemWidget(chat: chat);
          },
        );
      }),
    );
  }

  void _showStartChatDialog(BuildContext context) {
    final phoneController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColor.whiteCream,
        title: Row(
          children: [
            Icon(Icons.chat_outlined, color: AppColor.emeraldGreen),
            const SizedBox(width: 8),
            const Text(
              "Start Chat",
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.deepCharcoal),
            ),
          ],
        ),
        content: TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "Enter friend's phone number",
            prefixIcon: const Icon(Icons.phone),
            filled: true,
            fillColor: AppColor.softBeige,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColor.emeraldGreen),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.emeraldGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final phone = phoneController.text.trim();
              Get.back();
              if (phone.isEmpty) {
                Get.snackbar(
                  "Error",
                  "Enter phone number",
                  backgroundColor: AppColor.error.withOpacity(0.2),
                  colorText: AppColor.deepCharcoal,
                );
                return;
              }
              final isFound = await controller.startChatWithPhone(phone);
              Get.snackbar(
                isFound ? "Chat Ready" : "User not found",
                isFound
                    ? "Chat created successfully!"
                    : "No user found with that phone number.",
                backgroundColor:
                isFound ? AppColor.emeraldGreen.withOpacity(0.2) : AppColor.error.withOpacity(0.2),
                colorText: AppColor.deepCharcoal,
              );
            },
            child: const Text("Start", style: TextStyle(color: AppColor.whiteColor)),
          ),
        ],
      ),
    );
  }
}

/// Separate widget for each chat item (reduces rebuild cost)
class ChatItemWidget extends StatelessWidget {
  final Map<String, dynamic> chat;
  const ChatItemWidget({required this.chat, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = chat['name'] ?? 'Unknown';
    final lastMsg = chat['lastMessage'] ?? '';
    final userId = chat['userId'] ?? '';

    return GestureDetector(
      onTap: () {
        Get.to(() => ChatScreen(
          receiverId: userId,
          receiverName: name,
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.whiteCream,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColor.deepCharcoal.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: "chatAvatar_$userId",
              child: CircleAvatar(
                radius: 26,
                backgroundColor: AppColor.emeraldGreen.withOpacity(0.2),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : "?",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.emeraldGreen,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColor.deepCharcoal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMsg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.deepCharcoal.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColor.deepCharcoal),
          ],
        ),
      ),
    );
  }
}
