// import 'package:flutter/cupertino.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import '../colors/colors.dart';
//
// class Utils {
//
//   static toastMessage(String message){
//     Fluttertoast.showToast(
//       msg: message,
//       backgroundColor:  AppColor.blueColor,
//       gravity: ToastGravity.BOTTOM,
//     );
//   }
//
//   static toastMessageCenter(String message){
//     Fluttertoast.showToast(
//       msg: message,
//       backgroundColor:  AppColor.blueColor,
//       gravity: ToastGravity.CENTER,
//     );
//   }
//
//   static snackBar(String title ,String message){
//     Get.snackbar(
//       title,
//       message,
//     );
//   }
//
// }
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Utils {
  /// 🌟 Toast message (Bottom)
  static void toastMessage(String message, BuildContext context) {
    final theme = Theme.of(context);

    Fluttertoast.showToast(
      msg: message,
      backgroundColor: theme.colorScheme.primary, // Gold (auto light/dark)
      textColor: theme.colorScheme.onPrimary, // White or Black dynamically
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 16,
    );
  }

  /// 🌟 Toast message (Center)
  static void toastMessageCenter(String message, BuildContext context) {
    final theme = Theme.of(context);

    Fluttertoast.showToast(
      msg: message,
      backgroundColor: theme.colorScheme.secondary, // Emerald Green
      textColor: theme.colorScheme.onSecondary,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 16,
    );
  }

  /// 🍞 GetX Snackbar (Themed)
  static void snackBar(String title, String message, BuildContext context) {
    final theme = Theme.of(context);

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: theme.colorScheme.surface.withOpacity(0.95),
      colorText: theme.colorScheme.onSurface,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: Icon(Icons.info_outline, color: theme.colorScheme.primary),
      duration: const Duration(seconds: 3),
    );
  }
}
