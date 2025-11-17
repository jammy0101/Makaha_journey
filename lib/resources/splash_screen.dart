
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hajj_umrah_journey/resources/splash_services/splash_services.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

SplashService  splashService = SplashService();

class _SplashscreenState extends State<Splashscreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashService.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        // children: [
        //   Center(
        //     child: Text(
        //       'My Project',
        //       style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //         fontSize: 30,
        //         color: Theme.of(context).colorScheme.onSurface, // ✅ Auto adapts to light/dark
        //         letterSpacing: 0.5, // subtle readability
        //       ),
        //     ),
        //   ),
        // ],
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/splash2.png',
                  height: MediaQuery.of(context).size.height * 0.35, // 🔸 35% of screen height
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
