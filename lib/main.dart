//
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hajj_umrah_journey/controller/themeController/theme_controller.dart';
// import 'package:hajj_umrah_journey/resources/colors/them.dart';
// import 'package:hajj_umrah_journey/resources/languages/translation.dart';
// import 'package:hajj_umrah_journey/resources/routes/routes_name.dart';
// import 'controller/firebase_services/firebase_services.dart';
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   Get.put(FirebaseServices());
//   Get.put(ThemeController());
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // 👇 Retrieve the controller
//     final ThemeController themeController = Get.find<ThemeController>();
//
//     return Obx(() => GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Makkah & Madina Journey',
//       theme: AppTheme.lightTheme, // 🌞 Light Theme
//       darkTheme: AppTheme.darkTheme, // 🌚 Dark Theme
//       translations: TranslationService(),
//       locale: const Locale('en', 'US'), // default language
//       fallbackLocale: const Locale('en', 'US'),
//       themeMode: themeController.isDarkMode.value
//           ? ThemeMode.dark
//           : ThemeMode.light,
//       getPages: AppRoutes.appRoutes(),
//     ));
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hajj_umrah_journey/resources/getx_localization/languages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hajj_umrah_journey/controller/themeController/theme_controller.dart';
import 'package:hajj_umrah_journey/resources/colors/them.dart';
import 'package:hajj_umrah_journey/resources/routes/routes_name.dart';
import 'controller/firebase_services/firebase_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Load saved language using SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  String savedLang = prefs.getString('selectedLanguage') ?? 'English';

  Locale initialLocale;
  if (savedLang == 'Arabic') {
    initialLocale = const Locale('ar', 'SA');
  } else if (savedLang == 'Urdu') {
    initialLocale = const Locale('ur', 'PK');
  } else {
    initialLocale = const Locale('en', 'US');
  }

  // Put services/controllers after initialization
  Get.put(FirebaseServices());
  Get.put(ThemeController());

  runApp(MyApp(initialLocale: initialLocale));
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
