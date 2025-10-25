// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import '../../../../resources/colors/colors.dart';
// import '../../../../resources/components/custom_text_field_email.dart';
// import '../../../../resources/routes/routes.dart';
// import '../button/round_button.dart';
//
//
// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});
//
//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }
//
// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool isLoading = false;
//
//   void _resetPassword() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => isLoading = true);
//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(
//         email: emailController.text.trim(),
//       );
//       setState(() => isLoading = false);
//       Get.toNamed(RoutesName.emailSentScreen, arguments: emailController.text);
//     } catch (e) {
//       setState(() => isLoading = false);
//       Get.snackbar("Error", e.toString(),
//           backgroundColor: Colors.red, colorText: Colors.white);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.whiteColor,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Get.back(),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Image.asset('assets/images/DayFlow.png', height: 140),
//               const SizedBox(height: 16),
//               Text(
//                 "Forgot Password",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Enter the email address associated with your account to receive a password reset link.",
//                 style: TextStyle(color: Colors.grey[700]),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 30),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text("Email Address", style: TextStyle(fontWeight: FontWeight.w600)),
//               ),
//               const SizedBox(height: 8),
//               CustomTextFieldEmail(
//                 controller: emailController,
//                 hintText: "Enter your email",
//                 validator: validateEmail,
//               ),
//               const SizedBox(height: 24),
//               RoundButton(
//                 loading: isLoading,
//                 title: 'Submit',
//                 onPress: _resetPassword,
//                 width: double.infinity,
//                 height: 55,
//                 roundButton: Colors.blueAccent,
//                 textColor: Colors.white,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return "Email is required";
//     }
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(value)) {
//       return "Enter a valid email";
//     }
//     return null;
//   }
// }