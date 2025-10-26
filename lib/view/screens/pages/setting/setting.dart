//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../controller/themeController/theme_controller.dart';
// import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
// import '../../../../resources/routes/routes.dart';
//
// class Setting extends StatefulWidget {
//   const Setting({super.key});
//
//   @override
//   State<Setting> createState() => _SettingState();
// }
//
// class _SettingState extends State<Setting> {
//   final ThemeController themeController = Get.find<ThemeController>();
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     String selectedLanguage = 'English';
//
//     List<Map<String, dynamic>> languages = [
//       {'name': 'English', 'locale': const Locale('en', 'US')},
//       {'name': 'Arabic', 'locale': const Locale('ar', 'SA')},
//       {'name': 'Urdu', 'locale': const Locale('ur', 'PK')},
//     ];
//
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Settings'),
//         centerTitle: true,
//       ),
//       bottomNavigationBar: const BottomNavigation(index: 3),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // 👤 Profile Section
//           Card(
//             shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             elevation: 3,
//             child: ListTile(
//               leading: const CircleAvatar(
//                 radius: 28,
//                 backgroundImage: NetworkImage(
//                     'https://i.pravatar.cc/150?img=8'), // temporary image
//               ),
//               title: const Text('Ahmed Khan',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//               subtitle: const Text('ahmed@example.com'),
//               trailing: IconButton(
//                 icon: const Icon(Icons.edit, color: Colors.blueAccent),
//                 onPressed: () {
//                   // Navigate to Edit Profile Screen
//                 },
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           // 🌙 Dark Mode Toggle
//           ListTile(
//             leading: const Icon(Icons.dark_mode),
//             title: const Text('Dark Mode'),
//             trailing: Obx(() => Switch(
//               value: themeController.isDarkMode.value,
//               onChanged: (value) => themeController.toggleTheme(),
//             )),
//           ),
//
//           // 🌐 Language Option
//           ListTile(
//             leading: const Icon(Icons.language),
//             title: Text('language'.tr),
//             trailing: DropdownButton<String>(
//               value: selectedLanguage,
//               items: languages
//                   .map((lang) => DropdownMenuItem<String>(
//                 value: lang['name'],
//                 child: Text(lang['name']),
//               ))
//                   .toList(),
//               onChanged: (val) {
//                 setState(() {
//                   selectedLanguage = val!;
//                 });
//                 final locale = languages.firstWhere((lang) => lang['name'] == val)['locale'];
//                 Get.updateLocale(locale); //
//               },
//             ),
//           ),
//
//
//           // 📍 Manage Location Sharing
//           ListTile(
//             leading: const Icon(Icons.location_on_outlined),
//             title: const Text('Location Sharing'),
//             trailing: const Icon(Icons.chevron_right),
//             onTap: () {
//               // TODO: Open location permission settings
//             },
//           ),
//
//           const Divider(),
//
//           // 🚪 Logout
//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.red),
//             title: const Text('Logout',
//                 style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
//             onTap: () async {
//               await FirebaseAuth.instance.signOut(); // ✅ this clears the session
//               Get.offAllNamed(RoutesName.loginScreen);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../controller/themeController/theme_controller.dart';
import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
import '../../../../resources/routes/routes.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final ThemeController themeController = Get.find<ThemeController>();

  late String selectedLanguage = 'English';
  final List<Map<String, dynamic>> languages = [
    {'name': 'English', 'locale': const Locale('en', 'US')},
    {'name': 'Arabic', 'locale': const Locale('ar', 'SA')},
    {'name': 'Urdu', 'locale': const Locale('ur', 'PK')},
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('selectedLanguage') ?? 'English';
    setState(() {
      selectedLanguage = saved;
    });
  }

  Future<void> _changeLanguage(String langName) async {
    final prefs = await SharedPreferences.getInstance();
    final locale = languages.firstWhere((lang) => lang['name'] == langName)['locale'] as Locale;
    Get.updateLocale(locale); // instantly changes app language
    await prefs.setString('selectedLanguage', langName); // persist selection
    setState(() {
      selectedLanguage = langName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'.tr),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNavigation(index: 3),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 3,
            child: ListTile(
              leading: const CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=8'),
              ),
              title: const Text('Ahmed Khan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: const Text('ahmed@example.com'),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: () {},
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Dark mode toggle
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: Text('Dark Mode'.tr),
            trailing: Obx(() => Switch(
              value: themeController.isDarkMode.value,
              onChanged: (value) => themeController.toggleTheme(),
            )),
          ),

          // Language dropdown
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('Language'.tr),
            trailing: DropdownButton<String>(
              value: selectedLanguage,
              items: languages.map((lang) =>
                  DropdownMenuItem<String>(
                    value: lang['name'] as String,
                    child: Text(lang['name'] as String),
                  )
              ).toList(),
              onChanged: (val) {
                if (val != null) _changeLanguage(val);
              },
            ),
          ),

          // Location sharing
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text('Location Sharing'.tr),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text('Logout'.tr, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed(RoutesName.loginScreen);
            },
          ),
        ],
      ),
    );
  }
}

