import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
import '../../../../resources/drawar/custom_drawar.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeScreen'.tr),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      bottomNavigationBar: const BottomNavigation(index: 0,),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}
