//
//
// import 'dart:ui';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import '../../resources/routes/routes.dart';
// import '../chat_controlle/chat_control.dart';
//
// class FirebaseServices extends GetxController {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//
//   final loadingLoginL = false.obs;
//   final loadingGoogleL = false.obs;
//   final loadingRegistration = false.obs;
//
//   final isPasswordVisibleR = false.obs;
//   final isPasswordVisibleRE = false.obs;
//   final isPasswordVisibleL = false.obs;
//
//   void togglePasswordVisibility() => isPasswordVisibleR.toggle();
//   void toggleConfirmPasswordVisibility() => isPasswordVisibleRE.toggle();
//   void togglePasswordVisibilityL() => isPasswordVisibleL.toggle();
//
//   /// 🔹 Registration
//   Future<void> registration({
//     required String email,
//     required String password,
//     required String fullName,
//     required String phone,
//   }) async {
//     loadingRegistration.value = true;
//     try {
//       UserCredential userCredential = await auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       final user = userCredential.user;
//       if (user != null) {
//         await user.updateDisplayName(fullName);
//         await user.reload();
//         final updatedUser = auth.currentUser;
//
//         await saveUserToFirestore(updatedUser!, fullName: fullName, phone: phone);
//       //  await Get.find<ChatController>().ensureUserInFirestore();
//       }
//
//       Get.snackbar("Successfully".tr, 'Registration Completed'.tr);
//       Get.offAllNamed(RoutesName.homeViews);
//     } catch (e) {
//       Get.snackbar('Error'.tr, e.toString());
//     } finally {
//       loadingRegistration.value = false;
//     }
//   }
//
//   /// 🔹 Login
//   Future<void> login({required String email, required String password}) async {
//     loadingLoginL.value = true;
//     try {
//       await auth.signInWithEmailAndPassword(email: email, password: password);
//      // await Get.find<ChatController>().ensureUserInFirestore();
//       Get.snackbar("Successfully".tr, 'Login Completed'.tr);
//       Get.offAllNamed(RoutesName.homeViews);
//     } catch (e) {
//       Get.snackbar('Error'.tr, e.toString());
//     } finally {
//       loadingLoginL.value = false;
//     }
//   }
//
//   /// 🔹 Google Sign-In
//   Future<User?> loginWithGoogle() async {
//     try {
//       final googleSignIn = GoogleSignIn(scopes: ['email']);
//       await googleSignIn.signOut();
//       final googleUser = await googleSignIn.signIn();
//       if (googleUser == null) return null;
//
//       final googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       final userCredential = await auth.signInWithCredential(credential);
//       final user = userCredential.user;
//
//       if (user != null) {
//         await saveUserToFirestore(user, fullName: user.displayName);
//         //await Get.find<ChatController>().ensureUserInFirestore();
//       }
//
//       Get.offAllNamed(RoutesName.homeViews);
//       return user;
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//       return null;
//     }
//   }
//
//   /// 🔹 Firestore Save / Update
//   Future<void> saveUserToFirestore(User user, {String? fullName, String? phone}) async {
//     final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
//     final snapshot = await userRef.get();
//
//     if (!snapshot.exists) {
//       await userRef.set({
//         'uid': user.uid,
//         'name': fullName ?? user.displayName ?? '',
//         'email': user.email ?? '',
//         'phone': phone ?? user.phoneNumber ?? '',
//         'profileImage': user.photoURL ?? '',
//         'language': 'en',
//         'preferences': {'notifications': true, 'theme': 'light'},
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//     } else {
//       await userRef.update({
//         'name': fullName ?? user.displayName ?? '',
//         'phone': phone ?? user.phoneNumber ?? '',
//         'email': user.email ?? '',
//         'profileImage': user.photoURL ?? '',
//       });
//     }
//   }
// }

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../resources/routes/routes.dart';
import '../chat_controlle/chat_control.dart';

class FirebaseServices extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final loadingLoginL = false.obs;
  final loadingGoogleL = false.obs;
  final loadingRegistration = false.obs;

  final isPasswordVisibleR = false.obs;
  final isPasswordVisibleRE = false.obs;
  final isPasswordVisibleL = false.obs;

  void togglePasswordVisibility() => isPasswordVisibleR.toggle();
  void toggleConfirmPasswordVisibility() => isPasswordVisibleRE.toggle();
  void togglePasswordVisibilityL() => isPasswordVisibleL.toggle();

  var phoneValid = false.obs;

  void setPhoneValid(bool value) => phoneValid.value = value;
  /// 🔹 Registration
  Future<void> registration({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    loadingRegistration.value = true;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(fullName);
        await user.reload();
        final updatedUser = auth.currentUser;

        await saveUserToFirestore(updatedUser!, fullName: fullName, phone: phone);
        //  await Get.find<ChatController>().ensureUserInFirestore();
      }

      Get.snackbar("Successfully".tr, 'Registration Completed'.tr);
      Get.offAllNamed(RoutesName.homeViews);
    } catch (e) {
      Get.snackbar('Error'.tr, e.toString());
    } finally {
      loadingRegistration.value = false;
    }
  }

  /// 🔹 Login
  Future<void> login({required String email, required String password}) async {
    loadingLoginL.value = true;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      // await Get.find<ChatController>().ensureUserInFirestore();
      Get.snackbar("Successfully".tr, 'Login Completed'.tr);
      Get.offAllNamed(RoutesName.homeViews);
    } catch (e) {
      Get.snackbar('Error'.tr, e.toString());
    } finally {
      loadingLoginL.value = false;
    }
  }

  /// 🔹 Google Sign-In
  Future<User?> loginWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(scopes: ['email']);
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await saveUserToFirestore(user, fullName: user.displayName);
        //await Get.find<ChatController>().ensureUserInFirestore();
      }

      Get.offAllNamed(RoutesName.homeViews);
      return user;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return null;
    }
  }

  /// 🔹 Firestore Save / Update
  Future<void> saveUserToFirestore(User user, {String? fullName, String? phone}) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await userRef.get();

    if (!snapshot.exists) {
      await userRef.set({
        'uid': user.uid,
        'name': fullName ?? user.displayName ?? '',
        'email': user.email ?? '',
        'phone': phone ?? user.phoneNumber ?? '',
        'profileImage': user.photoURL ?? '',
        'language': 'en',
        'preferences': {'notifications': true, 'theme': 'light'},
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      await userRef.update({
        'name': fullName ?? user.displayName ?? '',
        'phone': phone ?? user.phoneNumber ?? '',
        'email': user.email ?? '',
        'profileImage': user.photoURL ?? '',
      });
    }
  }
}
