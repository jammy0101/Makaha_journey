// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   /// Initialize local notifications
//   static Future<void> initialize() async {
//     const AndroidInitializationSettings androidInit =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings settings =
//     InitializationSettings(android: androidInit);
//
//     await _notificationsPlugin.initialize(settings);
//   }
//
//   /// Show a local notification (no internet or FCM required)
//   static Future<void> showLocalNotification({
//     required String title,
//     required String body,
//   }) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'chat_channel',
//       'Chat Notifications',
//       channelDescription: 'Notification channel for chat messages',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       icon: '@mipmap/ic_launcher',
//     );
//
//     const NotificationDetails notificationDetails =
//     NotificationDetails(android: androidDetails);
//
//     await _notificationsPlugin.show(
//       0, // ID (you can change if needed)
//       title,
//       body,
//       notificationDetails,
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../view/screens/pages/chat/chat.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();



  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(
      settings,
        onDidReceiveNotificationResponse: (details) {
          if (details.payload != null) {
            final receiverId = details.payload!; // get receiverId
            // You may want to fetch receiverName from Firestore
            FirebaseFirestore.instance
                .collection('users')
                .doc(receiverId)
                .get()
                .then((doc) {
              final name = doc.data()?['name'] ?? 'Friend';
              Get.to(() => ChatScreen(receiverId: receiverId, receiverName: name));
            });
          }
        }

    );
  }




  /// Show a simple local notification (works offline, no FCM required)
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload, // new
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
      channelDescription: 'Local notification channel for chat messages',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique ID
      title,
      body,
      details,
      payload: payload, // pass here
    );
  }
}
