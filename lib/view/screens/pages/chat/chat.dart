//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../../controller/chat_controlle/chat_control.dart';
// import '../../../../model/message_model/message_model.dart';
// import '../../../../resources/colors/colors.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String receiverId;
//   final String receiverName;
//
//   const ChatScreen({required this.receiverId, required this.receiverName, Key? key}) : super(key: key);
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   late ChatController controller;
//   final TextEditingController messageController = TextEditingController();
//   final ScrollController scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     controller = Get.put(ChatController(), tag: widget.receiverId);
//     controller.initChat(widget.receiverId);
//   }
//
//   void _sendMessage() {
//     final text = messageController.text.trim();
//     if (text.isEmpty) return;
//     controller.sendMessage(widget.receiverId, text);
//     messageController.clear();
//     scrollController.animateTo(
//       0,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }
//
//   @override
//   void dispose() {
//     Get.delete<ChatController>(tag: widget.receiverId);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
//
//     return Scaffold(
//       backgroundColor: AppColor.softBeige,
//       appBar: AppBar(
//         backgroundColor: AppColor.emeraldGreen,
//         title: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(widget.receiverName,
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   Obx(() => Row(
//                     children: [
//                       // Online/offline dot
//                       Container(
//                         width: 8,
//                         height: 8,
//                         decoration: BoxDecoration(
//                           color: controller.receiverStatus.value == 'Online'
//                               ? Colors.greenAccent
//                               : Colors.grey,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         controller.receiverStatus.value,
//                         style: const TextStyle(fontSize: 12, color: AppColor.whiteColor),
//                       ),
//                     ],
//                   )),
//                 ],
//               ),
//             ),
//             PopupMenuButton<String>(
//               icon: const Icon(Icons.more_vert, color: AppColor.whiteColor),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               color: AppColor.whiteCream,
//               onSelected: (value) async {
//                 if (value == 'clear') {
//                   final confirm = await showDialog<bool>(
//                     context: context,
//                     barrierDismissible: false,
//                     builder: (_) => AlertDialog(
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                       title: const Text("Clear Chat", style: TextStyle(fontWeight: FontWeight.bold)),
//                       content: const Text(
//                         "Are you sure you want to delete all messages in this chat?\nThis action cannot be undone.",
//                         style: TextStyle(fontSize: 15),
//                       ),
//                       actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       actions: [
//                         TextButton.icon(
//                           onPressed: () => Navigator.pop(context, false),
//                           icon: const Icon(Icons.close, color: AppColor.deepCharcoal),
//                           label: const Text("Cancel"),
//                         ),
//                         ElevatedButton.icon(
//                           onPressed: () => Navigator.pop(context, true),
//                           icon: const Icon(Icons.delete_forever, color: AppColor.whiteColor),
//                           label: const Text("Clear"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColor.error,
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//
//                   if (confirm == true) {
//                     await controller.clearChat();
//                     Get.snackbar(
//                       "Chat Cleared",
//                       "All messages have been permanently deleted.",
//                       snackPosition: SnackPosition.BOTTOM,
//                       backgroundColor: AppColor.error.withOpacity(0.15),
//                       colorText: AppColor.deepCharcoal,
//                       margin: const EdgeInsets.all(12),
//                       borderRadius: 12,
//                       duration: const Duration(seconds: 2),
//                       icon: const Icon(Icons.delete_forever, color: AppColor.error),
//                     );
//                   }
//                 }
//               },
//               itemBuilder: (_) => [
//                 const PopupMenuItem(
//                   value: 'clear',
//                   child: Row(
//                     children: [
//                       Icon(Icons.delete_forever, color: AppColor.error),
//                       SizedBox(width: 8),
//                       Text("Clear Chat", style: TextStyle(fontWeight: FontWeight.w500)),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(() {
//               return ListView.builder(
//                 controller: scrollController,
//                 reverse: true,
//                 itemCount: controller.messages.length,
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 itemBuilder: (context, index) {
//                   final MessageModel msg = controller.messages[index];
//                   final isMe = msg.senderId == currentUserId;
//
//                   final bubbleColor = isMe
//                       ? LinearGradient(
//                     colors: [AppColor.emeraldGreen.withOpacity(0.85), AppColor.gold.withOpacity(0.8)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   )
//                       : null;
//
//                   final bgColor = isMe ? null : AppColor.whiteColor;
//                   final textColor = isMe ? AppColor.darkBackground : AppColor.deepCharcoal;
//
//                   Widget messageBubble = Container(
//                     constraints: BoxConstraints(
//                         maxWidth: MediaQuery.of(context).size.width * 0.75),
//                     margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                     decoration: BoxDecoration(
//                       color: bgColor,
//                       gradient: bubbleColor,
//                       borderRadius: BorderRadius.only(
//                         topLeft: const Radius.circular(12),
//                         topRight: const Radius.circular(12),
//                         bottomLeft: Radius.circular(isMe ? 12 : 0),
//                         bottomRight: Radius.circular(isMe ? 0 : 12),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColor.deepCharcoal.withOpacity(0.05),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         )
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                       children: [
//                         // Shimmer effect for unread messages
//                         if (!isMe && !msg.isSeen)
//                           Shimmer.fromColors(
//                             baseColor: AppColor.emeraldGreen.withOpacity(0.4),
//                             highlightColor: AppColor.gold.withOpacity(0.4),
//                             child: Text(msg.message,
//                                 style: TextStyle(fontSize: 16, color: textColor)),
//                           )
//                         else
//                           Text(msg.message, style: TextStyle(fontSize: 16, color: textColor)),
//                         const SizedBox(height: 4),
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               DateFormat('hh:mm a').format(msg.timestamp),
//                               style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.7)),
//                             ),
//                             if (isMe) const SizedBox(width: 4),
//                             if (isMe)
//                               Icon(
//                                 msg.isSeen ? Icons.done_all : Icons.done,
//                                 size: 16,
//                                 color: msg.isSeen ? AppColor.deepCharcoal : textColor.withOpacity(0.7),
//                               ),
//                           ],
//                         )
//                       ],
//                     ),
//                   );
//
//                   return Align(
//                     alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                     child: messageBubble,
//                   );
//                 },
//               );
//             }),
//           ),
//
//           // Input Area
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
//                     decoration: InputDecoration(
//                       hintText: 'Type a message',
//                       filled: true,
//                       fillColor: AppColor.whiteColor,
//                       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: AppColor.emeraldGreen,
//                     shape: BoxShape.circle,
//                   ),
//                   child: IconButton(
//                     icon: const Icon(Icons.send, color: AppColor.whiteColor),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../controller/chat_controlle/chat_control.dart';
import '../../../../model/message_model/message_model.dart';
import '../../../../resources/colors/colors.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatScreen({required this.receiverId, required this.receiverName, Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController controller = Get.put(ChatController()); // Use global controller
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.initChat(widget.receiverId); // Load messages for this chat
  }

  void _sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    controller.sendMessage(widget.receiverId, text);
    messageController.clear();
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: AppColor.softBeige,
      appBar: AppBar(
        backgroundColor: AppColor.emeraldGreen,
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.receiverName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Obx(() => Row(
                    children: [
                      // Online/offline dot
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: controller.receiverStatus.value == 'Online'
                              ? Colors.greenAccent
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        controller.receiverStatus.value,
                        style: const TextStyle(fontSize: 12, color: AppColor.whiteColor),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColor.whiteColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: AppColor.whiteCream,
              onSelected: (value) async {
                if (value == 'clear') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text("Clear Chat", style: TextStyle(fontWeight: FontWeight.bold)),
                      content: const Text(
                        "Are you sure you want to delete all messages in this chat?\nThis action cannot be undone.",
                        style: TextStyle(fontSize: 15),
                      ),
                      actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      actions: [
                        TextButton.icon(
                          onPressed: () => Navigator.pop(context, false),
                          icon: const Icon(Icons.close, color: AppColor.deepCharcoal),
                          label: const Text("Cancel"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context, true),
                          icon: const Icon(Icons.delete_forever, color: AppColor.whiteColor),
                          label: const Text("Clear"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.error,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await controller.clearChat(widget.receiverId);
                    Get.snackbar(
                      "Chat Cleared",
                      "All messages have been permanently deleted.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColor.error.withOpacity(0.15),
                      colorText: AppColor.deepCharcoal,
                      margin: const EdgeInsets.all(12),
                      borderRadius: 12,
                      duration: const Duration(seconds: 2),
                      icon: const Icon(Icons.delete_forever, color: AppColor.error),
                    );
                  }
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'clear',
                  child: Row(
                    children: [
                      Icon(Icons.delete_forever, color: AppColor.error),
                      SizedBox(width: 8),
                      Text("Clear Chat", style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              // Filter messages for this chat only
              final chatMessages = controller.messages
                  .where((msg) => msg.receiverId == widget.receiverId || msg.senderId == widget.receiverId)
                  .toList();

              return ListView.builder(
                controller: scrollController,
                reverse: true,
                itemCount: chatMessages.length,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  final MessageModel msg = chatMessages[index];
                  final isMe = msg.senderId == currentUserId;

                  final bubbleColor = isMe
                      ? LinearGradient(
                    colors: [AppColor.emeraldGreen.withOpacity(0.5), AppColor.gold.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null;

                  final bgColor = isMe ? null : AppColor.whiteColor;
                  final textColor = isMe ? AppColor.darkBackground : AppColor.deepCharcoal;

                  Widget messageBubble = Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: bgColor,
                      gradient: bubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(isMe ? 12 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.deepCharcoal.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (!isMe && !msg.isSeen)
                          Shimmer.fromColors(
                            baseColor: AppColor.emeraldGreen.withOpacity(0.4),
                            highlightColor: AppColor.gold.withOpacity(0.4),
                            child: Text(msg.message,
                                style: TextStyle(fontSize: 16, color: textColor)),
                          )
                        else
                          Text(msg.message, style: TextStyle(fontSize: 16, color: textColor)),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('hh:mm a').format(msg.timestamp),
                              style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.7)),
                            ),
                            if (isMe) const SizedBox(width: 4),
                            if (isMe)
                              Icon(
                                msg.isSeen ? Icons.done_all : Icons.done,
                                size: 16,
                                color: msg.isSeen ? AppColor.deepCharcoal : textColor.withOpacity(0.7),
                              ),
                          ],
                        )
                      ],
                    ),
                  );

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: messageBubble,
                  );
                },
              );
            }),
          ),
          // Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: AppColor.softBeige,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      filled: true,
                      fillColor: AppColor.whiteColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.emeraldGreen,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: AppColor.whiteColor),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
