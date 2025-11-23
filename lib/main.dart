

import 'dart:developer';
import 'dart:ui'; // IMPORTANT for TextDirection enums
import 'package:flutter_localizations/flutter_localizations.dart';
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

import 'controller/binding/binding.dart';

/// ===========================
/// 🔥 GLOBAL FIX: STOP ICON FLIPPING IN RTL
/// ===========================
class NoMirrorIcon extends StatelessWidget {
  final Widget child;
  const NoMirrorIcon({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    // Icons will ALWAYS stay LTR, even if the whole UI is RTL
    return Directionality(
      textDirection: TextDirection.ltr,
      child: child,
    );


  }
}

/// ===========================
/// 🔥 FCM BACKGROUND HANDLER
/// ===========================
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
  LtrBinding.ensureInitialized();

  await Firebase.initializeApp();
  // ✅ FIX: Initialize Firebase WITH OPTIONS
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // Initialize notification service
  await NotificationService.initialize();

  // Request notification permission (iOS)
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(alert: true, badge: true, sound: true);

  // Background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Foreground message: ${message.notification?.title}');
    if (message.notification != null) {
      NotificationService.showLocalNotification(
        title: message.notification!.title ?? "No Title",
        body: message.notification!.body ?? "No Body",
      );
    }
  });

  // Inject GetX services
  Get.put(FirebaseServices());
  Get.put(ThemeController());

  // Initialize ChatController only after login
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user != null && !Get.isRegistered<ChatController>()) {
      Get.put(ChatController());
    }
  });

  // Firestore cache
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

  runApp(MyApp(initialLocale: initialLocale));

  // Analytics
  await FirebaseAnalytics.instance.logAppOpen();

  // Handle app opened from terminated state
  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null && initialMessage.data['receiverId'] != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.toNamed('/chat',
          arguments: {'chatId': initialMessage.data['receiverId']});
    });
  }

  // Handle app opened from background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.data['receiverId'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed('/chat',
            arguments: {'chatId': message.data['receiverId']});
      });
    }
  });
}

/// ===========================
/// 🔥 MAIN APP WIDGET
/// ===========================
class MyApp extends StatelessWidget {
  final Locale initialLocale;
  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Makkah & Madina Journey',

      /// THEMES
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
      themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,

      /// GETX TRANSLATIONS
      translations: Languages(),
      locale: initialLocale,
      fallbackLocale: const Locale('en', 'US'),

      /// FLUTTER LOCALIZATION DELEGATES (IMPORTANT)
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'SA'),
        Locale('ur', 'PK'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      getPages: AppRoutes.appRoutes(),

      /// ===========================
      /// 🔥 GLOBAL RTL + ICON FIX
      /// ===========================
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.ltr,   // FORCE FULL APP LTR
          child: child!,
        );
      },
    ));
  }
}
