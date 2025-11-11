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
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController passwordControllerR = TextEditingController();
//   final TextEditingController confirmPasswordR = TextEditingController();
//
//   @override
//   void dispose() {
//     emailControllerR.dispose();
//     passwordControllerR.dispose();
//     confirmPasswordR.dispose();
//     nameController.dispose();
//     phoneController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.02),
//           child: Form(
//             key: formKey1,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// Logo
//                 Center(
//                   child: Image.asset(
//                     'assets/images/splash2.png',
//                     height: 100,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//
//                 /// Header
//                 Center(
//                   child: Text(
//                     'Create An Account'.tr,
//                     style: theme.textTheme.headlineMedium?.copyWith(
//                       color: theme.colorScheme.onSurface,
//                       fontSize: width * 0.065,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 /// Full Name
//                 buildLabel('Full Name'.tr, theme),
//                 CustomTextFieldName(
//                   controller: nameController,
//                   hintText: '',
//                   validator: validateName,
//                 ),
//
//                 /// Email
//                 SizedBox(height: height * 0.02),
//                 buildLabel('Email Address'.tr, theme),
//                 CustomTextFieldEmail(
//                   controller: emailControllerR,
//                   hintText: '',
//                   validator: validateEmail,
//                 ),
//
//                 /// Phone Number
//                 SizedBox(height: height * 0.02),
//                 buildLabel('Phone Number'.tr, theme),
//                 CustomTextField(
//                   controller: phoneController,
//                   hintText: '',
//                   keyboardType: TextInputType.phone,
//                   validator: validatePhone,
//                 ),
//
//                 /// Password
//                 SizedBox(height: height * 0.02),
//                 buildLabel('Password'.tr, theme),
//                 Obx(() => CustomTextField(
//                   controller: passwordControllerR,
//                   obscureText: !firebaseServices.isPasswordVisibleR.value,
//                   hintText: '',
//                   suffixIcon: IconButton(
//                     onPressed: firebaseServices.togglePasswordVisibility,
//                     icon: Icon(
//                       firebaseServices.isPasswordVisibleR.value
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                       color: theme.colorScheme.primary,
//                     ),
//                   ),
//                   validator: validatePassword,
//                 )),
//
//                 /// Confirm Password
//                 SizedBox(height: height * 0.02),
//                 buildLabel('Confirm Password'.tr, theme),
//                 Obx(() => CustomTextField(
//                   controller: confirmPasswordR,
//                   obscureText: !firebaseServices.isPasswordVisibleRE.value,
//                   hintText: '',
//                   suffixIcon: IconButton(
//                     onPressed: firebaseServices.toggleConfirmPasswordVisibility,
//                     icon: Icon(
//                       firebaseServices.isPasswordVisibleRE.value
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                       color: theme.colorScheme.primary,
//                     ),
//                   ),
//                   validator: validateConfirmPassword,
//                 )),
//
//                 SizedBox(height: height * 0.03),
//
//                 /// Register Button
//                 Obx(() => RoundButton(
//                   width: double.infinity,
//                   height: 55,
//                   loading: firebaseServices.loadingRegistration.value,
//                   title: 'Get Started'.tr,
//                   onPress: () {
//                     if (formKey1.currentState!.validate()) {
//                       firebaseServices.registration(
//                         email: emailControllerR.text.trim(),
//                         password: passwordControllerR.text,
//                         fullName: nameController.text.trim(),
//                         phone: phoneController.text.trim(),
//                       );
//                     }
//                   },
//                   buttonColor: AppColor.gold,
//                   textColor: AppColor.whiteCream,
//                 )),
//
//                 SizedBox(height: height * 0.02),
//
//                 /// Divider
//                 Row(
//                   children: [
//                     Expanded(child: Divider(color: theme.colorScheme.surface)),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text(
//                         "OR".tr,
//                         style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
//                       ),
//                     ),
//                     Expanded(child: Divider(color: theme.colorScheme.surface)),
//                   ],
//                 ),
//
//                 SizedBox(height: height * 0.03),
//
//                 /// Google Sign-in Button
//                 Obx(() => RoundButton2(
//                   width: double.infinity,
//                   height: 55,
//                   loading: firebaseServices.loadingGoogleL.value,
//                   title: '',
//                   onPress: () async {
//                     await firebaseServices.loginWithGoogle();
//                   },
//                   textColor: theme.colorScheme.onSurface,
//                   borderColor: theme.colorScheme.surface,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset('assets/images/googlelogo.png', height: 30),
//                       const SizedBox(width: 10),
//                       Text(
//                         'Continue with Google'.tr,
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: theme.colorScheme.onSurface,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )),
//
//                 SizedBox(height: height * 0.025),
//
//                 /// Already have an account?
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Already have an account?".tr,
//                       style: theme.textTheme.bodyMedium,
//                     ),
//                     TextButton(
//                       onPressed: () => Get.toNamed(RoutesName.loginScreen),
//                       child: Text(
//                         'Login'.tr,
//                         style: TextStyle(
//                           color: AppColor.gold,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildLabel(String label, ThemeData theme) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6.0),
//       child: Text(
//         label,
//         style: theme.textTheme.bodyMedium?.copyWith(
//           fontWeight: FontWeight.w600,
//           color: theme.colorScheme.onSurface,
//         ),
//       ),
//     );
//   }
//
//   /// Validators
//   String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) return "Email is required".tr;
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(value)) return "Enter a valid email".tr;
//     return null;
//   }
//
//   String? validatePhone(String? value) {
//     if (value == null || value.isEmpty) return "Phone number is required".tr;
//     if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
//       return "Enter a valid phone number".tr;
//     }
//     return null;
//   }
//
//   String? validateConfirmPassword(String? value) {
//     String password = passwordControllerR.text.trim();
//     if (value == null || value.isEmpty) return 'Confirm Password is required'.tr;
//     if (value != password) {
//       Get.snackbar("Error".tr, "Passwords do not match".tr,
//           backgroundColor: AppColor.error, colorText: Colors.white);
//       return "Passwords do not match".tr;
//     }
//     return null;
//   }
//
//   String? validateName(String? value) {
//     if (value == null || value.trim().isEmpty) return "Name is required".tr;
//     if (value.trim().length < 3) return "Name must be at least 3 characters".tr;
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
// views/auth/registration_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
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
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'PK'); // default country
  bool phoneValid = false;

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String _normalizedPhone() {
    // prefer the PhoneNumber instance (gives E.164); fallback to raw input
    return phoneNumber.phoneNumber ?? phoneController.text.trim();
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
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/splash2.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),

                // Header
                Center(
                  child: Text(
                    'Create An Account'.tr,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: width * 0.065,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Name
                buildLabel('Full Name'.tr, theme),
                CustomTextFieldName(
                  controller: nameController,
                  hintText: 'Enter full name'.tr,
                  validator: validateName,
                ),

                SizedBox(height: height * 0.02),

                // Email
                buildLabel('Email Address'.tr, theme),
                CustomTextFieldEmail(
                  controller: emailController,
                  hintText: 'Enter email'.tr,
                  validator: validateEmail,
                ),

                SizedBox(height: height * 0.02),

                // Phone (intl)
                buildLabel('Phone Number'.tr, theme),
                InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    phoneNumber = number;
                  },
                  onInputValidated: (bool value) {
                    setState(() {
                      phoneValid = value;
                    });
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.DROPDOWN,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  selectorTextStyle: TextStyle(color: theme.colorScheme.onSurface),
                  textFieldController: phoneController,
                  initialValue: phoneNumber,
                  formatInput: true,
                  inputDecoration: InputDecoration(
                    hintText: '+92 3xx xxxxxxx',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 19),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  keyboardType: TextInputType.phone,
                ),

                SizedBox(height: height * 0.02),

                // Password
                buildLabel('Password'.tr, theme),
                Obx(() => CustomTextField(
                  controller: passwordController,
                  obscureText: !firebaseServices.isPasswordVisibleR.value,
                  hintText: 'Enter password'.tr,
                  suffixIcon: IconButton(
                    onPressed: firebaseServices.togglePasswordVisibility,
                    icon: Icon(
                      firebaseServices.isPasswordVisibleR.value ? Icons.visibility : Icons.visibility_off,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  validator: validatePassword,
                )),

                SizedBox(height: height * 0.02),

                // Confirm password
                buildLabel('Confirm Password'.tr, theme),
                Obx(() => CustomTextField(
                  controller: confirmPasswordController,
                  obscureText: !firebaseServices.isPasswordVisibleRE.value,
                  hintText: 'Confirm password'.tr,
                  suffixIcon: IconButton(
                    onPressed: firebaseServices.toggleConfirmPasswordVisibility,
                    icon: Icon(
                      firebaseServices.isPasswordVisibleRE.value ? Icons.visibility : Icons.visibility_off,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  validator: (val) => validateConfirmPassword(val, passwordController.text),
                )),

                SizedBox(height: height * 0.03),

                // Register button
                Obx(() => RoundButton(
                  width: double.infinity,
                  height: 55,
                  loading: firebaseServices.loadingRegistration.value,
                  title: 'Get Started'.tr,
                  onPress: () {
                    // Basic form validate + phone validity
                    if (!formKey.currentState!.validate()) return;

                    final normalized = _normalizedPhone();
                    if (normalized.isEmpty) {
                      Get.snackbar("Error".tr, "Phone number is required".tr);
                      return;
                    }

                    // optional: ensure phone has '+' at start (best to rely on intl lib output)
                    final phoneToSave = normalized.startsWith('+') ? normalized : '+$normalized';

                    firebaseServices.registration(
                      email: emailController.text.trim(),
                      password: passwordController.text,
                      fullName: nameController.text.trim(),
                      phone: phoneToSave,
                    );
                  },
                  buttonColor: AppColor.gold,
                  textColor: AppColor.whiteCream,
                )),

                SizedBox(height: height * 0.02),

                // Divider OR
                Row(
                  children: [
                    Expanded(child: Divider(color: theme.colorScheme.surface)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("OR".tr, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7))),
                    ),
                    Expanded(child: Divider(color: theme.colorScheme.surface)),
                  ],
                ),

                SizedBox(height: height * 0.03),

                // Google sign-in button (keeps your previous RoundButton2)
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
                      Image.asset('assets/images/googlelogo.png', height: 30),
                      const SizedBox(width: 10),
                      Text(
                        'Continue with Google'.tr,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),

                SizedBox(height: height * 0.025),

                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?".tr),
                    TextButton(
                      onPressed: () => Get.toNamed(RoutesName.loginScreen),
                      child: Text('Login'.tr, style: TextStyle(color: AppColor.gold, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------
  // Validators
  // -------------------------
  Widget buildLabel(String label, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required".tr;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return "Enter a valid email".tr;
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return "Name is required".tr;
    if (value.trim().length < 3) return "Name must be at least 3 characters".tr;
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value.trim())) return "Only alphabets and spaces are allowed".tr;
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return "Phone number is required".tr;
    // we rely on intl_phone_number_input, so minimal check here
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required".tr;
    if (value.length < 6) return "Password must be at least 6 characters".tr;
    return null;
  }

  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Confirm Password is required'.tr;
    if (value != password) {
      Get.snackbar("Error".tr, "Passwords do not match".tr, backgroundColor: AppColor.error, colorText: Colors.white);
      return "Passwords do not match".tr;
    }
    return null;
  }
}

