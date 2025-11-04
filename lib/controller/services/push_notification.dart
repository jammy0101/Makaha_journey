// lib/services/push_notifications.dart
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationsService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Request permission (iOS)
    await _messaging.requestPermission();

    // Android foreground notifications via flutter_local_notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _local.initialize(initSettings, onDidReceiveNotificationResponse: (payload) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // show local notification
      final notification = message.notification;
      if (notification != null && notification.android != null) {
        final androidStyle = AndroidNotificationDetails(
            'chat_channel', 'Chat Messages', importance: Importance.max, priority: Priority.high);
        final platform = NotificationDetails(android: androidStyle);
        await _local.show(
            notification.hashCode, notification.title, notification.body, platform,
            payload: message.data['chatId'] ?? '');
      }
    });

    // Optional: handle background messages in top-level function
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final chatId = message.data['chatId'];
      if (chatId != null) {
        // navigate to chat
        // Get.toNamed(RoutesName.chat, arguments: {'chatId': chatId});
      }
    });

    // get token for server
    final token = await _messaging.getToken();
    print('FCM token: $token');
    // Save the token to Firestore under users/{uid}/fcmToken
  }
}
