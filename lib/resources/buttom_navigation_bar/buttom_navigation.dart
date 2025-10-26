
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../routes/routes.dart';

class BottomNavigation extends StatefulWidget {
  final int index;
  const BottomNavigation({super.key, required this.index});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int myIndex = widget.index;

  void onTabChange(int index) {
    if (index == myIndex) return;
    setState(() => myIndex = index);

    switch (index) {
      case 0:
        Get.offAllNamed(RoutesName.homeViews);
        break;
      case 1:
        Get.offAllNamed(RoutesName.duaLibrary);
        break;
      case 2:
        Get.offAllNamed(RoutesName.chat);
        break;
      case 3:
        Get.offAllNamed(RoutesName.setting);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: GNav(
            gap: 8,
            backgroundColor: Colors.transparent,
            color: theme.colorScheme.onSurfaceVariant,
            activeColor: theme.colorScheme.primary,
            tabBackgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            selectedIndex: myIndex,
            onTabChange: onTabChange,
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.library_books, text: 'Library'),
              GButton(icon: Icons.chat, text: 'Chat'),
              GButton(icon: Icons.settings, text: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}
