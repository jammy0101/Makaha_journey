
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'darkMode': isDarkMode.value,
      });
    }
  }

  Future<void> loadUserTheme() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc =
      await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc['darkMode'] != null) {
        isDarkMode.value = doc['darkMode'];
        Get.changeThemeMode(
            isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
      }
    }
  }
}
