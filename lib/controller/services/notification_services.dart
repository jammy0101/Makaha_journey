

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../view/screens/pages/chat/chat.dart'; // adjust import path if needed

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        final payload = details.payload;
        if (payload == null || payload.isEmpty) return;

        // payload is senderId (we used senderId as payload)
        final receiverId = payload;

        try {
          final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(receiverId).get();
          final name = userDoc.data()?['name'] ?? 'Friend';

          // Navigate to chat screen - use Get.to if GetMaterialApp is active
          // Put navigation on microtask so it runs after app lifecycle events
          Future.microtask(() {
            try {
              Get.to(() => ChatScreen(receiverId: receiverId, receiverName: name));
            } catch (_) {
              // if Get navigation isn't available, ignore safely
            }
          });
        } catch (e) {
          // ignore errors fetching user
        }
      },
    );

    _initialized = true;
  }

  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
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

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _notificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }
}

