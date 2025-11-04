
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/chat_list_controller/chat_list.dart';
import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
import '../chat/chat.dart';

class ChatsHomeScreen extends StatelessWidget {
  final ChatListController controller = Get.put(ChatListController());

  @override
  Widget build(BuildContext context) {
    controller.loadChats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.brown.shade200,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown.shade300,
        onPressed: () async {
          final phoneController = TextEditingController();

          Get.dialog(
            AlertDialog(
              title: const Text("Start Chat"),
              content: TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "Enter friend's phone number",
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
                ElevatedButton(
                  onPressed: () async {
                    final phone = phoneController.text.trim();
                    if (phone.isEmpty) {
                      Get.snackbar("Error", "Enter phone number");
                      return;
                    }
                    await controller.startChatWithPhone(phone);
                    Get.back();
                  },
                  child: const Text("Start"),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.chat),
      ),
      bottomNavigationBar: const BottomNavigation(index: 2),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.chats.isEmpty) {
          return const Center(child: Text('No chats yet'));
        }

        return ListView.builder(
          itemCount: controller.chats.length,
          itemBuilder: (context, index) {
            final chat = controller.chats[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.brown.shade100,
                child: Text(chat['name'][0].toUpperCase()),
              ),
              title: Text(chat['name']),
              subtitle: Text(chat['lastMessage']),
              onTap: () {
                Get.to(() => ChatScreen(
                  receiverId: chat['userId'],
                  receiverName: chat['name'],
                ));
              },
            );
          },
        );
      }),
    );
  }
}
