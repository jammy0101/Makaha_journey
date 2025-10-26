import 'package:flutter/material.dart';

import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chat'),
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
