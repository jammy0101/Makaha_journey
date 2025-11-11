//
//
//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hajj_umrah_journey/resources/getx_localization/languages.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hajj_umrah_journey/controller/themeController/theme_controller.dart';
// import 'package:hajj_umrah_journey/resources/colors/them.dart';
// import 'package:hajj_umrah_journey/resources/routes/routes_name.dart';
// import 'controller/chat_controlle/chat_control.dart';
// import 'controller/firebase_services/firebase_services.dart';
// import 'controller/services/notification_services.dart';
//
// // Must be a top-level function for background messages
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
//   if (message.notification != null) {
//     await NotificationService.showLocalNotification(
//       title: message.notification!.title ?? "No Title",
//       body: message.notification!.body ?? "No Body",
//     );
//   }
// }
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//   // Initialize notification service
//   await NotificationService.initialize();
//
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//
//
//   // Request notification permissions (iOS)
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//
//   // Handle background/terminated messages
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   // Optional: handle foreground messages
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print('Foreground message received: ${message.notification?.title}');
//     if (message.notification != null) {
//       NotificationService.showLocalNotification(
//         title: message.notification!.title ?? "No Title",
//         body: message.notification!.body ?? "No Body",
//       );
//     }
//   });
//
//   await FirebaseAnalytics.instance.logAppOpen();
//
//
//   // Load saved language using SharedPreferences
//   final prefs = await SharedPreferences.getInstance();
//   String savedLang = prefs.getString('selectedLanguage') ?? 'English';
//   FirebaseFirestore.instance.settings = const Settings(
//     persistenceEnabled: true, // enables offline caching
//   );
//   Locale initialLocale;
//   if (savedLang == 'Arabic') {
//     initialLocale = const Locale('ar', 'SA');
//   } else if (savedLang == 'Urdu') {
//     initialLocale = const Locale('ur', 'PK');
//   } else {
//     initialLocale = const Locale('en', 'US');
//   }
//
//   // Put services/controllers after initialization
//   Get.put(FirebaseServices());
//   Get.put(ThemeController());
//   // ✅ Initialize ChatController *after login*, not before
//   FirebaseAuth.instance.authStateChanges().listen((user) {
//     if (user != null) {
//       if (!Get.isRegistered<ChatController>()) {
//         Get.put(ChatController());
//       }
//     }
//   });
//
//   runApp(MyApp(initialLocale: initialLocale));
//
//
// }
//
//
// class MyApp extends StatelessWidget {
//   final Locale initialLocale;
//   const MyApp({super.key, required this.initialLocale});
//
//   @override
//   Widget build(BuildContext context) {
//     final ThemeController themeController = Get.find<ThemeController>();
//
//     return Obx(() => GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Makkah & Madina Journey',
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       translations: Languages(),
//       locale: initialLocale,
//       fallbackLocale: const Locale('en', 'US'),
//       themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
//       getPages: AppRoutes.appRoutes(),
//     ));
//   }
// }

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hajj_umrah_journey/controller/themeController/theme_controller.dart';
import 'package:hajj_umrah_journey/controller/chat_controlle/chat_control.dart';
import 'package:hajj_umrah_journey/controller/firebase_services/firebase_services.dart';
import 'package:hajj_umrah_journey/controller/services/notification_services.dart';
import 'package:hajj_umrah_journey/resources/colors/them.dart';
import 'package:hajj_umrah_journey/resources/getx_localization/languages.dart';
import 'package:hajj_umrah_journey/resources/routes/routes_name.dart';

/// Background message handler must be top-level
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Handling a background message: ${message.messageId}");
  if (message.notification != null) {
    await NotificationService.showLocalNotification(
      title: message.notification!.title ?? "No Title",
      body: message.notification!.body ?? "No Body",
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize notification service
  await NotificationService.initialize();

  // Request FCM permission (iOS)
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(alert: true, badge: true, sound: true);

  // Background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Foreground message received: ${message.notification?.title}');
    if (message.notification != null) {
      NotificationService.showLocalNotification(
        title: message.notification!.title ?? "No Title",
        body: message.notification!.body ?? "No Body",
      );
    }
  });

  // Initialize GetX services
  Get.put(FirebaseServices());
  Get.put(ThemeController());

  // Initialize ChatController only after login
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user != null && !Get.isRegistered<ChatController>()) {
      Get.put(ChatController());
    }
  });

  // Firestore offline persistence
  FirebaseFirestore.instance.settings =
  const Settings(persistenceEnabled: true);

  // Load saved language
  final prefs = await SharedPreferences.getInstance();
  String savedLang = prefs.getString('selectedLanguage') ?? 'English';
  Locale initialLocale = savedLang == 'Arabic'
      ? const Locale('ar', 'SA')
      : savedLang == 'Urdu'
      ? const Locale('ur', 'PK')
      : const Locale('en', 'US');

  // Run the app first
  runApp(MyApp(initialLocale: initialLocale));

  // Analytics & navigation after runApp
  await FirebaseAnalytics.instance.logAppOpen();

  // Handle app opened from terminated state
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null && initialMessage.data['receiverId'] != null) {
    // Use post-frame callback to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.toNamed('/chat', arguments: {'chatId': initialMessage.data['receiverId']});
    });
  }

  // Handle app opened from background (user taps notification)
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.data['receiverId'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed('/chat', arguments: {'chatId': message.data['receiverId']});
      });
    }
  });
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Makkah & Madina Journey',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      translations: Languages(),
      locale: initialLocale,
      fallbackLocale: const Locale('en', 'US'),
      themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      getPages: AppRoutes.appRoutes(),
    ));
  }
}
