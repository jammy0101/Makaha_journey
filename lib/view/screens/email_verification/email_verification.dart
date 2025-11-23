// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
//
// class EmailVerifyScreen extends StatelessWidget {
//   const EmailVerifyScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Verify Email")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "A verification email has been sent.\nPlease check your inbox.",
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 await FirebaseAuth.instance.currentUser?.sendEmailVerification();
//                 Get.snackbar("Sent", "Verification email sent again.");
//               },
//               child: const Text("Resend Email"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../resources/routes/routes.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  bool isVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // Start checking if email is verified every 3 seconds
    timer = Timer.periodic(const Duration(seconds: 3), (_) => checkEmailStatus());
  }

  Future<void> checkEmailStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      setState(() {
        isVerified = true;
      });
      timer?.cancel(); // stop checking
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                "A verification email has been sent.\nPlease check your inbox.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 20),

              // Resend button
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.currentUser?.sendEmailVerification();
                  Get.snackbar("Sent", "Verification email sent again.");
                },
                child: const Text("Resend Email"),
              ),

              const SizedBox(height: 40),

              // ✔ SHOW BUTTON ONLY WHEN VERIFIED
              if (isVerified)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  onPressed: () {
                    Get.offAllNamed(RoutesName.homeViews); // Home screen
                  },
                  child: const Text(
                    "Continue to Home",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),

              // Loading message before verification
              if (!isVerified)
                Column(
                  children: const [
                    SizedBox(height: 10),
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text("Waiting for verification..."),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
