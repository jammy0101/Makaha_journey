import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/routes.dart';

class BottomNavigation extends StatefulWidget {
  final int index;
  const BottomNavigation({super.key, required this.index});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int myIndex = widget.index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0), // Creates floating effect
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25), // Rounded corners
        child: Material(
          elevation: 8, // Shadow
          borderRadius: BorderRadius.circular(25),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: BottomNavigationBar(
              selectedItemColor: Colors.red,
              unselectedItemColor: Colors.black,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                if (index == myIndex) return;
                setState(() {
                  myIndex = index;
                });

                switch (index) {
                  case 0:
                    Get.offAllNamed(RoutesName.homeViews);
                    break;
                  case 1:
                    Get.offAllNamed(RoutesName.addUser);
                    break;
                  case 2:
                    Get.offAllNamed(RoutesName.setting);
                    break;
                }
              },
              currentIndex: myIndex,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home,size: 30,), label: '', backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(Icons.supervised_user_circle,size: 30,),
                    label: '',
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings,size: 30,), label: '', backgroundColor: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

}