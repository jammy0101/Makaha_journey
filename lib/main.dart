

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hajj_umrah_journey/resources/colors/them.dart';
import 'package:hajj_umrah_journey/resources/routes/routes_name.dart';

import 'controller/firebase_services/firebase_services.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(FirebaseServices()); //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Makaha & Madina Journey',
      theme: AppTheme.darkTheme, // 🌞 Light Theme
      darkTheme: AppTheme.darkTheme, // 🌚 Dark Theme
      themeMode: ThemeMode.system,
      getPages: AppRoutes.appRoutes(),
    );
  }
}