import 'package:flutter/material.dart';

import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';


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
        title: Text('Home_screen'),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNavigation(index: 0,),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}
