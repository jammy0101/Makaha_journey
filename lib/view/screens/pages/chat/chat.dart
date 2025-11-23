

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../controller/chat_controlle/chat_control.dart';
import '../../../../model/message_model/message_model.dart';
import '../../../../resources/colors/colors.dart';
import '../home_screen/home_screen.dart';

// <-- ADJUST THIS IMPORT to where your HomeScreen actually lives in your project
// e.g. import '../../home/home_screen.dart'; or import '../../../home_screen/home_screen.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String? sharedMessage;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
    this.sharedMessage,
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

    // If chat was opened with a sharedMessage (e.g. from map), auto-send it.
    // Keep this behavior but ensure it's sent once after init.
    if (widget.sharedMessage != null && widget.sharedMessage!.trim().isNotEmpty) {
      // Slight delay to ensure chat document exists and controller ready
      Future.delayed(const Duration(milliseconds: 300), () {
        controller.sendMessage(widget.receiverId, widget.sharedMessage!.trim());
      });
    }
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
    _typingTimer = Timer(const Duration(seconds: 1), () {
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
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            if (isMe)
              ListTile(
                leading: const Icon(Icons.edit),
                title:  Text("Edit Message".tr),
                onTap: () {
                  Get.back();
                  _editMessageDialog(msg);
                },
              ),
            if (isMe)
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title:  Text("Delete for Everyone".tr),
                onTap: () {
                  Get.back();
                  controller.deleteForEveryone(msg);
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.orange),
              title:  Text("Delete for Me".tr),
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
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _editMessageDialog(MessageModel msg) {
    final editCtrl = TextEditingController(text: msg.message);

    Get.defaultDialog(
      title: "Edit Message".tr,
      content: TextField(
        controller: editCtrl,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
      textConfirm: "Save".tr,
      textCancel: "Cancel".tr,
      onConfirm: () {
        controller.editMessage(msg, editCtrl.text.trim());
        Get.back();
      },
    );
  }

  // -------------------------
  // Location message parser
  // Expected format:
  // My location:
  // Lat: 21.4225
  // Lng: 39.8262
  // -------------------------
  Map<String, double>? _parseLocationFromText(String text) {
    try {
      if (!text.startsWith("My location:".tr)) return null;
      final lines = text.split('\n').map((s) => s.trim()).toList();
      if (lines.length < 3) return null;

      final latLine = lines[1];
      final lngLine = lines[2];

      final latStr = latLine.replaceAll(RegExp(r'Lat:?', caseSensitive: false), '').trim();
      final lngStr = lngLine.replaceAll(RegExp(r'Lng:?', caseSensitive: false), '').trim();

      final lat = double.tryParse(latStr);
      final lng = double.tryParse(lngStr);

      if (lat == null || lng == null) return null;
      return {'lat': lat, 'lng': lng};
    } catch (_) {
      return null;
    }
  }

  // Build message content widget (handles location preview)
  Widget _buildMessageContent(MessageModel msg) {
    final text = msg.message;
    final loc = _parseLocationFromText(text);

    if (loc != null) {
      final lat = loc['lat']!;
      final lng = loc['lng']!;

      return GestureDetector(
        onTap: () {
          // Navigate to your in-app HomeScreen and focus the map
          Get.to(() => HomeScreen(lat: lat, lng: lng));
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(minWidth: 140, maxWidth: 320),
          decoration: BoxDecoration(
            color: msg.senderId == FirebaseAuth.instance.currentUser!.uid
                ? Colors.green.shade50
                : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: msg.senderId == FirebaseAuth.instance.currentUser!.uid
                  ? Colors.green.shade200
                  : Colors.blue.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.place, size: 28, color: AppColor.gold),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Shared Location".tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}",
                      style: const TextStyle(fontSize: 12, height: 1.2),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Tap to open in map".tr,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      );
    }

    // Normal text message
    return Text(text);
  }
  BorderRadius _bubbleRadius(bool isMe) {
    return BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: Radius.circular(isMe ? 12 : 0),
      bottomRight: Radius.circular(isMe ? 0 : 12),
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
                const Text(
                  "typing...",
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
            ],
          );
        }),
        actions: [
          PopupMenuButton(
            onSelected: (_) async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title:  Text("Confirm".tr),
                  content:  Text("Are you sure you want to clear the chat?".tr),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child:  Text("Cancel".tr),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child:  Text("Clear".tr),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                controller.clearChatForMe(widget.receiverId);
              }
            },
            itemBuilder: (c) =>  [
              PopupMenuItem(
                value: "clear",
                child: Text("Clear Chat For Me".tr),
              ),
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

              if (chatMessages.isNotEmpty) {
                _scrollToBottomIfNeeded();
              }

              return ListView.builder(
                controller: scrollController,
                itemCount: chatMessages.length,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (_, i) {
                  final msg = chatMessages[i];
                  final isMe = msg.senderId == uid;

                  return GestureDetector(
                    onLongPress: () => _showOptions(msg),
                    child: Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      // child: Container(
                      //   margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      //   padding: const EdgeInsets.all(8),
                      //   decoration: BoxDecoration(
                      //     color: isMe ? Colors.green[50] : Colors.white,
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment:
                      //     isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      //     children: [
                      //       _buildMessageContent(msg),
                      //       const SizedBox(height: 6),
                      //       Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Text(
                      //             DateFormat('hh:mm a').format(msg.timestamp),
                      //             style: const TextStyle(fontSize: 11),
                      //           ),
                      //           const SizedBox(width: 6),
                      //           if (isMe)
                      //             Icon(
                      //               msg.isSeen ? Icons.done_all : (msg.delivered ? Icons.done_all : Icons.done),
                      //               size: 16,
                      //               color: msg.isSeen
                      //                   ? Colors.blue
                      //                   : (msg.delivered ? Colors.grey : Colors.grey.shade600),
                      //             ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xffDCF8C6) : Colors.white,
                      borderRadius: _bubbleRadius(isMe),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        _buildMessageContent(msg),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('hh:mm a').format(msg.timestamp),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            if (isMe) const SizedBox(width: 5),
                            if (isMe)
                              Icon(
                                msg.isSeen
                                    ? Icons.done_all
                                    : (msg.delivered ? Icons.done_all : Icons.done),
                                size: 16,
                                color: msg.isSeen
                                    ? Colors.blue
                                    : (msg.delivered ? Colors.grey : Colors.grey.shade600),
                              ),
                          ],
                        ),
                      ],
                    ),
                  )
                  ,
                    ),
                  );
                },
              );
            }),
          ),

          // INPUT FIELD
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (t) => _handleTyping(t),
                      decoration: InputDecoration(
                        hintText: "Type a message...".tr,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _send,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
