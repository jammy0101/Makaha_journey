//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../controller/firebase_services/firebase_services.dart';
// import '../../../../resources/colors/colors.dart';
// import '../../../../resources/components/custom_text_field.dart';
// import '../../../../resources/components/custom_text_field_email.dart';
// import '../../../../resources/components/custom_text_field_name.dart';
// import '../../../../resources/routes/routes.dart';
// import '../../widgets/button/round_button.dart';
// import '../../widgets/button/round_button2.dart';
//
// class RegistrationScreen extends StatefulWidget {
//   const RegistrationScreen({super.key});
//
//   @override
//   State<RegistrationScreen> createState() => _RegistrationScreenState();
// }
//
// final FirebaseServices firebaseServices = Get.find<FirebaseServices>();
//
// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final formKey1 = GlobalKey<FormState>();
//
//   final TextEditingController emailControllerR = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController passwordControllerR = TextEditingController();
//   final TextEditingController confirmPasswordR = TextEditingController();
//
//   @override
//   void dispose() {
//     emailControllerR.dispose();
//     passwordControllerR.dispose();
//     confirmPasswordR.dispose();
//     nameController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) => SingleChildScrollView(
//             padding: EdgeInsets.symmetric(
//               horizontal: width * 0.05,
//               vertical: height * 0.02,
//             ),
//             child: Form(
//               key: formKey1,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Column(
//                       children: [
//                         Text(
//                           'Create an Account',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: width * 0.065,
//                           ),
//                         ),
//                         Text(
//                           'Sign up now to get started.',
//                           style: TextStyle(
//                             fontSize: width * 0.035,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: height * 0.03),
//
//                   // Full Name
//                   Text('Full Name', style: labelStyle()),
//                   CustomTextFieldName(
//                     controller: nameController,
//                     hintText: '',
//                     validator: validateName,
//                   ),
//
//                   // Email
//                   Padding(
//                     padding: EdgeInsets.only(top: height * 0.015),
//                     child: Text('Email Address', style: labelStyle()),
//                   ),
//                   CustomTextFieldEmail(
//                     controller: emailControllerR,
//                     hintText: '',
//                     validator: validateEmail,
//                   ),
//
//                   // Password
//                   Padding(
//                     padding: EdgeInsets.only(top: height * 0.015),
//                     child: Text('Password', style: labelStyle()),
//                   ),
//                   Obx(() => CustomTextField(
//                     controller: passwordControllerR,
//                     obscureText: !firebaseServices.isPasswordVisibleR.value,
//                     hintText: '',
//                     suffixIcon: IconButton(
//                       onPressed: firebaseServices.togglePasswordVisibility,
//                       icon: Icon(firebaseServices.isPasswordVisibleR.value
//                           ? Icons.visibility
//                           : Icons.visibility_off),
//                     ),
//                     validator: validatePassword,
//                   )),
//
//                   // Confirm Password
//                   Padding(
//                     padding: EdgeInsets.only(top: height * 0.015),
//                     child: Text('Confirm Password', style: labelStyle()),
//                   ),
//                   Obx(() => CustomTextField(
//                     controller: confirmPasswordR,
//                     obscureText: !firebaseServices.isPasswordVisibleRE.value,
//                     hintText: '',
//                     suffixIcon: IconButton(
//                       onPressed:
//                       firebaseServices.toggleConfirmPasswordVisibility,
//                       icon: Icon(firebaseServices.isPasswordVisibleRE.value
//                           ? Icons.visibility
//                           : Icons.visibility_off),
//                     ),
//                     validator: validateConfirmPassword,
//                   )),
//
//                   SizedBox(height: height * 0.04),
//
//                   // Register Button
//                   Obx(() => RoundButton(
//                     width: double.infinity,
//                     height: 55,
//                     loading: firebaseServices.loadingRegistration.value,
//                     title: 'Get Started',
//                     onPress: () {
//                       if (formKey1.currentState!.validate()) {
//                         firebaseServices.registration(
//                           email: emailControllerR.text.trim(),
//                           password: passwordControllerR.text,
//                           fullName: nameController.text.trim(),
//                         );
//                       }
//                     },
//                     roundButton: Colors.blueAccent,
//                     textColor: AppColor.blackColor,
//                   )),
//
//                   Padding(
//                     padding: EdgeInsets.symmetric(vertical: height * 0.03),
//                     child: Row(
//                       children: const [
//                         Expanded(child: Divider()),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text("OR"),
//                         ),
//                         Expanded(child: Divider()),
//                       ],
//                     ),
//                   ),
//
//                   // Google Button
//                   Obx(() => RoundButton2(
//                     width: double.infinity,
//                     height: 55,
//                     loading: firebaseServices.loadingGoogleL.value,
//                     title: '',
//                     onPress: () async {
//                       // await firebaseServices.loginWithGoogle();
//                     },
//                     textColor: AppColor.blackColor,
//                     buttonColor2: Colors.grey.shade300,
//                     child: Image.asset(
//                       'assets/images/googlelogo.png',
//                       height: 35,
//                     ),
//                   )),
//
//                   SizedBox(height: height * 0.025),
//
//                   // Login Redirect
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Already have an account?"),
//                       TextButton(
//                         onPressed: () => Get.toNamed(RoutesName.loginScreen),
//                         child: const Text(
//                           'Login',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   TextStyle labelStyle() => const TextStyle(
//     fontWeight: FontWeight.w600,
//     color: Colors.black87,
//   );
//
//   String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) return "Email is required".tr;
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(value)) return "Enter a valid email".tr;
//     return null;
//   }
//
//   String? validateConfirmPassword(String? value) {
//     String password = passwordControllerR.text.trim();
//     if (value == null || value.isEmpty) return 'Confirm Password is required'.tr;
//     if (value != password) {
//       Future.delayed(Duration.zero, () {
//         Get.snackbar(
//           "Error".tr,
//           "Passwords do not match".tr,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//       });
//       return "Passwords do not match".tr;
//     }
//     return null;
//   }
//
//   String? validateName(String? value) {
//     if (value == null || value.trim().isEmpty) return "Name is required".tr;
//     if (value.trim().length < 3) {
//       return "Name must be at least 3 characters".tr;
//     }
//     if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value.trim())) {
//       return "Only alphabets and spaces are allowed".tr;
//     }
//     return null;
//   }
//
//   String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) return "Password is required".tr;
//     if (value.length < 6) return "Password must be at least 6 characters".tr;
//     return null;
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hajj_umrah_journey/view/screens/pages/home_screen/home_screen.dart';
import '../../../../controller/firebase_services/firebase_services.dart';
import '../../../../resources/colors/colors.dart';
import '../../../../resources/components/custom_text_field.dart';
import '../../../../resources/components/custom_text_field_email.dart';
import '../../../../resources/components/custom_text_field_name.dart';
import '../../../../resources/routes/routes.dart';
import '../../widgets/button/round_button.dart';
import '../../widgets/button/round_button2.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

final FirebaseServices firebaseServices = Get.find<FirebaseServices>();

class _RegistrationScreenState extends State<RegistrationScreen> {
  final formKey1 = GlobalKey<FormState>();
  final TextEditingController emailControllerR = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordControllerR = TextEditingController();
  final TextEditingController confirmPasswordR = TextEditingController();

  @override
  void dispose() {
    emailControllerR.dispose();
    passwordControllerR.dispose();
    confirmPasswordR.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.02),
          child: Form(
            key: formKey1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header

                Center(
                  child: Image.asset(
                    'assets/images/splash2.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                Center(
                  child: Column(
                    children: [

                      Text(
                        'Create An Account'.tr,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontSize: width * 0.065,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 5,),
                /// Name
                buildLabel('Full Name'.tr, theme),
                CustomTextFieldName(
                  controller: nameController,
                  hintText: '',
                  validator: validateName,
                ),

                /// Email
                SizedBox(height: height * 0.02),
                buildLabel('Email Address'.tr, theme),
                CustomTextFieldEmail(
                  controller: emailControllerR,
                  hintText: '',
                  validator: validateEmail,
                ),

                /// Password
                SizedBox(height: height * 0.01),
                buildLabel('Password'.tr, theme),
                Obx(() => CustomTextField(
                  controller: passwordControllerR,
                  obscureText: !firebaseServices.isPasswordVisibleR.value,
                  hintText: '',
                  suffixIcon: IconButton(
                    onPressed: firebaseServices.togglePasswordVisibility,
                    icon: Icon(
                      firebaseServices.isPasswordVisibleR.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  validator: validatePassword,
                )),

                /// Confirm Password
                SizedBox(height: height * 0.02),
                buildLabel('Confirm Password'.tr, theme),
                Obx(() => CustomTextField(
                  controller: confirmPasswordR,
                  obscureText: !firebaseServices.isPasswordVisibleRE.value,
                  hintText: '',
                  suffixIcon: IconButton(
                    onPressed: firebaseServices.toggleConfirmPasswordVisibility,
                    icon: Icon(
                      firebaseServices.isPasswordVisibleRE.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  validator: validateConfirmPassword,
                )),

                SizedBox(height: height * 0.03),

                /// Register Button
                Obx(() => RoundButton(
                  width: double.infinity,
                  height: 55,
                  loading: firebaseServices.loadingRegistration.value,
                  title: 'Get Started'.tr,
                  onPress: () {
                    if (formKey1.currentState!.validate()) {
                      firebaseServices.registration(
                        email: emailControllerR.text.trim(),
                        password: passwordControllerR.text,
                        fullName: nameController.text.trim(),
                      );
                    }
                  },
                  buttonColor: AppColor.gold,
                  textColor: AppColor.whiteCream,
                )),

                SizedBox(height: height * 0.02),

                /// Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: theme.colorScheme.surface)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "OR".tr,
                        style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                      ),
                    ),
                    Expanded(child: Divider(color: theme.colorScheme.surface)),
                  ],
                ),

                SizedBox(height: height * 0.03),

                /// Google Sign-in Button
                Obx(() => RoundButton2(
                  width: double.infinity,
                  height: 55,
                  loading: firebaseServices.loadingGoogleL.value,
                  title: '',
                  onPress: () async {
                     await firebaseServices.loginWithGoogle();
                  },
                  textColor: theme.colorScheme.onSurface,
                  borderColor: theme.colorScheme.surface,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/googlelogo.png',
                        height: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Continue with Google'.tr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                )),

                SizedBox(height: height * 0.025),

                /// Already have an account?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?".tr,
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(RoutesName.loginScreen),
                      child: Text(
                        'Login'.tr,
                        style: TextStyle(
                          color: AppColor.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper for labels
  Widget buildLabel(String label, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  /// Validators
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required".tr;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return "Enter a valid email".tr;
    return null;
  }

  String? validateConfirmPassword(String? value) {
    String password = passwordControllerR.text.trim();
    if (value == null || value.isEmpty) return 'Confirm Password is required'.tr;
    if (value != password) {
      Future.delayed(Duration.zero, () {
        Get.snackbar(
          "Error".tr,
          "Passwords do not match".tr,
          backgroundColor: AppColor.error,
          colorText: Colors.white,
        );
      });
      return "Passwords do not match".tr;
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return "Name is required".tr;
    if (value.trim().length < 3) return "Name must be at least 3 characters".tr;
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value.trim())) {
      return "Only alphabets and spaces are allowed".tr;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required".tr;
    if (value.length < 6) return "Password must be at least 6 characters".tr;
    return null;
  }
}
