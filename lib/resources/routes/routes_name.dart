
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:hajj_umrah_journey/resources/routes/routes.dart';
import 'package:hajj_umrah_journey/view/screens/pages/add_user/chat.dart';
import 'package:hajj_umrah_journey/view/screens/pages/dua_library/dua_library.dart';
import 'package:hajj_umrah_journey/view/screens/pages/more/more.dart';
import 'package:hajj_umrah_journey/view/screens/pages/registration/registration.dart';
import 'package:hajj_umrah_journey/view/screens/pages/setting/setting.dart';
import '../../view/screens/pages/home_screen/home_screen.dart';
import '../../view/screens/pages/login_screen/sign_In.dart';
import '../splash_screen.dart';


class AppRoutes {
  static appRoutes() => [

    GetPage(
      name: RoutesName.splashScreen,
      page: () => const Splashscreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.homeViews,
      page: () => const  HomeScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.loginScreen,
      page: () => const  LoginScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.registerScreen,
      page: () => const  RegistrationScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.chat,
      page: () => const  Chat(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.setting,
      page: () => const  Setting(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.duaLibrary,
      page: () => const  DuaLibrary(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.more,
      page: () => const  More(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
  ];
}
