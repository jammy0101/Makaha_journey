import 'package:flutter/material.dart';

import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';


class DuaLibrary extends StatefulWidget {
  const DuaLibrary({super.key});

  @override
  State<DuaLibrary> createState() => _DuaLibraryState();
}

class _DuaLibraryState extends State<DuaLibrary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dua library'),
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
