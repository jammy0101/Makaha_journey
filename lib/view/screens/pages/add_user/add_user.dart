import 'package:flutter/material.dart';

import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddUser'),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNavigation(index: 1,),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
