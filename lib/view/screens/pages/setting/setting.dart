import 'package:flutter/material.dart';

import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNavigation(index: 2,),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
