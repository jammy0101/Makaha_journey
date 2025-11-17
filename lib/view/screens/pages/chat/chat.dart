//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../../../controller/chat_controlle/chat_control.dart';
// import '../../../../model/message_model/message_model.dart';
// import '../../../../resources/colors/colors.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String receiverId;
//   final String receiverName;
//
//   const ChatScreen({required this.receiverId, required this.receiverName, Key? key})
//       : super(key: key);
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final ChatController controller = Get.put(ChatController());
//   final TextEditingController messageController = TextEditingController();
//   final ScrollController scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     controller.isInChat = true; // user enters chat
//     controller.initChat(widget.receiverId);
//     // delay and scroll down after messages load
//     Future.delayed(const Duration(milliseconds: 700), _scrollToBottomIfNeeded);
//   }
//
//   @override
//   void dispose() {
//     controller.isInChat = false; // user leaves chat
//     messageController.dispose();
//     scrollController.dispose();
//     super.dispose();
//   }
//
//   void _sendMessage() {
//     final text = messageController.text.trim();
//     if (text.isEmpty) return;
//     controller.sendMessage(widget.receiverId, text);
//     messageController.clear();
//
//     // small delay to allow Firestore update and UI rebuild
//     Future.delayed(const Duration(milliseconds: 150), () {
//       if (scrollController.hasClients) {
//         scrollController.animateTo(
//           scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   void _scrollToBottomIfNeeded() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       if (scrollController.hasClients) {
//         scrollController.animateTo(
//           scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 200),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   void _editMessage(MessageModel msg) {
//     final controllerText = TextEditingController(text: msg.message);
//
//     Get.defaultDialog(
//       title: "Edit Message",
//       content: TextField(
//         controller: controllerText,
//         decoration: InputDecoration(
//           border: OutlineInputBorder(),
//         ),
//       ),
//       textConfirm: "Save",
//       textCancel: "Cancel",
//       onConfirm: () {
//         controller.editMessage(msg, controllerText.text.trim());
//         Get.back();
//       },
//     );
//   }
//
//
//   void _showMessageOptions(MessageModel msg) {
//     final isMe = msg.senderId == FirebaseAuth.instance.currentUser!.uid;
//
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Wrap(
//           children: [
//             if (isMe) ...[
//               ListTile(
//                 leading: Icon(Icons.edit),
//                 title: Text("Edit Message"),
//                 onTap: () {
//                   Get.back();
//                   _editMessage(msg);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.delete_forever, color: Colors.red),
//                 title: Text("Delete For Everyone"),
//                 onTap: () {
//                   Get.back();
//                   controller.deleteForEveryone(msg);
//                 },
//               ),
//             ],
//
//             ListTile(
//               leading: Icon(Icons.delete, color: Colors.orange),
//               title: Text("Delete For Me"),
//               onTap: () {
//                 Get.back();
//                 controller.deleteForMe(msg);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
//
//     return Scaffold(
//       backgroundColor: AppColor.softBeige,
//         appBar: AppBar(
//           backgroundColor: AppColor.emeraldGreen,
//           title: Text(widget.receiverName),
//           actions: [
//             PopupMenuButton<String>(
//               onSelected: (value) {
//                 if (value == 'clear all chat') {
//                   Get.defaultDialog(
//                     title: "Confirm",
//                     middleText: "Clear entire chat only for you?",
//                     textCancel: "No",
//                     textConfirm: "Yes",
//                     onConfirm: () {
//                       controller.clearChatForMe(widget.receiverId);
//                       Get.back();
//                     },
//                   );
//                 }
//               },
//               itemBuilder: (context) => [
//                 const PopupMenuItem(
//                   value: 'clear_chat_for_me',
//                   child: Text("Clear Chat For Me"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         body: Column(
//         children: [
//           Expanded(
//             child: Obx(() {
//
//               final chatMessages = controller.messages
//                   .where((msg) =>
//               !msg.hiddenFor.contains(currentUserId) &&    // ← hide for me
//                   (
//                       (msg.receiverId == widget.receiverId && msg.senderId == currentUserId) ||
//                           (msg.senderId == widget.receiverId && msg.receiverId == currentUserId)
//                   )
//               ).toList();
//
//               // After building the list, request scroll to bottom.
//               // Do it here so it happens after the list has been rebuilt.
//               if (chatMessages.isNotEmpty) {
//                 _scrollToBottomIfNeeded();
//               }
//
//               return ListView.builder(
//                 controller: scrollController,
//                 itemCount: chatMessages.length,
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 itemBuilder: (context, index) {
//                   final msg = chatMessages[index];
//                   final isMe = msg.senderId == currentUserId;
//
//
//                   return GestureDetector(
//                     onLongPress: () => _showMessageOptions(msg), // ← Add this
//                     child: Align(
//                       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
//                         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.green[200] : Colors.white,
//                           borderRadius: BorderRadius.only(
//                             topLeft: const Radius.circular(12),
//                             topRight: const Radius.circular(12),
//                             bottomLeft: Radius.circular(isMe ? 12 : 0),
//                             bottomRight: Radius.circular(isMe ? 0 : 12),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment:
//                           isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                           children: [
//                             Text(msg.message),
//                             const SizedBox(height: 4),
//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   DateFormat('hh:mm a').format(msg.timestamp),
//                                   style: const TextStyle(fontSize: 10),
//                                 ),
//                                 if (isMe) const SizedBox(width: 4),
//                                 if (isMe)
//                                   Icon(
//                                     msg.isSeen ? Icons.done_all : Icons.done,
//                                     size: 16,
//                                     color: msg.isSeen ? Colors.blue : Colors.grey,
//                                   ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//
//                 },
//               );
//             }),
//           ),
//           // Input Field
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             color: AppColor.softBeige,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     minLines: 1,
//                     maxLines: 5,
//                     textInputAction: TextInputAction.send,
//                     onSubmitted: (_) => _sendMessage(),
//                     decoration: InputDecoration(
//                       hintText: 'Type a message',
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.green,
//                     shape: BoxShape.circle,
//                   ),
//                   child: IconButton(
//                     icon: const Icon(Icons.send, color: Colors.white),
//                     onPressed: _sendMessage,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../controller/chat_controlle/chat_control.dart';
import '../../../../model/message_model/message_model.dart';
import '../../../../resources/colors/colors.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController controller = Get.put(ChatController());
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    controller.isInChat = true;
    controller.initChat(widget.receiverId);
  }

  @override
  void dispose() {
    controller.isInChat = false;
    controller.setTyping(widget.receiverId, false); // STOP typing
    _typingTimer?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // INPUT FIELD TYPING HANDLER
  // ----------------------------------------------------------
  void _handleTyping(String text) {
    controller.setTyping(widget.receiverId, true);

    _typingTimer?.cancel();
    _typingTimer = Timer(Duration(seconds: 1), () {
      controller.setTyping(widget.receiverId, false);
    });
  }

  // ----------------------------------------------------------
  // SEND MESSAGE
  // ----------------------------------------------------------
  void _send() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    controller.sendMessage(widget.receiverId, text);
    messageController.clear();
  }

  // ----------------------------------------------------------
  // POPUP OPTIONS
  // ----------------------------------------------------------
  void _showOptions(MessageModel msg) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final isMe = msg.senderId == uid;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            if (isMe)
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Edit Message"),
                onTap: () {
                  Get.back();
                  _editMessageDialog(msg);
                },
              ),
            if (isMe)
              ListTile(
                leading: Icon(Icons.delete_forever, color: Colors.red),
                title: Text("Delete for Everyone"),
                onTap: () {
                  Get.back();
                  controller.deleteForEveryone(msg);
                },
              ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.orange),
              title: Text("Delete for Me"),
              onTap: () {
                Get.back();
                controller.deleteForMe(msg);
              },
            ),
          ],
        ),
      ),
    );
  }
  void _scrollToBottomIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }


  void _editMessageDialog(MessageModel msg) {
    final editCtrl = TextEditingController(text: msg.message);

    Get.defaultDialog(
      title: "Edit Message",
      content: TextField(
        controller: editCtrl,
        decoration: InputDecoration(border: OutlineInputBorder()),
      ),
      textConfirm: "Save",
      textCancel: "Cancel",
      onConfirm: () {
        controller.editMessage(msg, editCtrl.text.trim());
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColor.softBeige,
      appBar: AppBar(
        backgroundColor: AppColor.emeraldGreen,
        title: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.receiverName),
              if (controller.isReceiverTyping.value)
                Text(
                  "typing...",
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
            ],
          );
        }),
        actions: [
          PopupMenuButton(
            onSelected: (_) {
              controller.clearChatForMe(widget.receiverId);
            },
            itemBuilder: (c) => [
              PopupMenuItem(
                value: "clear",
                child: Text("Clear Chat For Me"),
              )
            ],
          )
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final chatMessages = controller.messages
                  .where((msg) =>
              !msg.hiddenFor.contains(uid) &&
                  ((msg.senderId == uid && msg.receiverId == widget.receiverId) ||
                      (msg.senderId == widget.receiverId && msg.receiverId == uid)))
                  .toList();
              // After building the list, request scroll to bottom.
              // Do it here so it happens after the list has been rebuilt.
              if (chatMessages.isNotEmpty) {
                _scrollToBottomIfNeeded();
              }
              return ListView.builder(
                controller: scrollController,
                itemCount: chatMessages.length,
                padding: EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (_, i) {
                  final msg = chatMessages[i];
                  final isMe = msg.senderId == uid;

                  return GestureDetector(
                    onLongPress: () => _showOptions(msg),
                    child: Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.green[200] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(msg.message),
                            SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat('hh:mm a').format(msg.timestamp),
                                  style: TextStyle(fontSize: 11),
                                ),
                                if (isMe) SizedBox(width: 4),
                                if (isMe)
                                  Icon(
                                    msg.isSeen
                                        ? Icons.done_all
                                        : msg.delivered
                                        ? Icons.done_all
                                        : Icons.done,
                                    size: 16,
                                    color: msg.isSeen
                                        ? Colors.blue
                                        : msg.delivered
                                        ? Colors.grey
                                        : Colors.grey.shade600,
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // INPUT FIELD
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    onChanged: (t) => _handleTyping(t),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _send,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

