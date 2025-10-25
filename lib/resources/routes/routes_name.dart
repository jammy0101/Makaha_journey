
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:hajj_umrah_journey/resources/routes/routes.dart';
import 'package:hajj_umrah_journey/view/screens/pages/add_user/add_user.dart';
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
      name: RoutesName.addUser,
      page: () => const  AddUser(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.setting,
      page: () => const  Setting(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 250),
    ),
  ];
}
