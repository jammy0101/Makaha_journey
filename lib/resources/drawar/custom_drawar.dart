// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../routes/routes.dart';
//
// class CustomDrawer extends StatelessWidget {
//   const CustomDrawer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Drawer(
//       backgroundColor: theme.colorScheme.surface,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(25),
//           bottomRight: Radius.circular(25),
//         ),
//       ),
//       child: Column(
//         children: [
//           // 🔹 Drawer Header
//           DrawerHeader(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   theme.colorScheme.primary.withOpacity(0.9),
//                   theme.colorScheme.primary.withOpacity(0.7),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Row(
//               children: [
//                 // Profile Circle
//                 CircleAvatar(
//                   radius: 35,
//                   backgroundColor: Colors.white,
//                   child: Icon(
//                     Icons.person,
//                     size: 40,
//                     color: theme.colorScheme.primary,
//                   ),
//                 ),
//                 const SizedBox(width: 15),
//                 // User Info
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Welcome",
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.9),
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       "Traveler",
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.9),
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//
//           // 🔹 Drawer Items
//           _buildDrawerItem(
//             context,
//             icon: Icons.home_outlined,
//             text: "Home",
//             onTap: () => Get.offAllNamed(RoutesName.homeViews),
//           ),
//           _buildDrawerItem(
//             context,
//             icon: Icons.menu_book_outlined,
//             text: "Dua Library",
//             onTap: () => Get.offAllNamed(RoutesName.duaLibrary),
//           ),
//           _buildDrawerItem(
//             context,
//             icon: Icons.chat_bubble_outline,
//             text: "Chat",
//             onTap: () => Get.offAllNamed(RoutesName.chat),
//           ),
//           _buildDrawerItem(
//             context,
//             icon: Icons.more,
//             text: "More",
//             onTap: () => Get.offAllNamed(RoutesName.more),
//           ),
//           _buildDrawerItem(
//             context,
//             icon: Icons.settings_outlined,
//             text: "Settings",
//             onTap: () => Get.offAllNamed(RoutesName.setting),
//           ),
//           const Spacer(),
//           // 🔹 Bottom Section
//           Divider(
//             thickness: 1,
//             color: theme.dividerColor.withOpacity(0.3),
//           ),
//           ListTile(
//             leading: Icon(Icons.logout, color: theme.colorScheme.error),
//             title: Text(
//               "Logout",
//               style: TextStyle(
//                 color: theme.colorScheme.error,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             onTap: () async {
//               await FirebaseAuth.instance.signOut(); // ✅ this clears the session
//               Get.offAllNamed(RoutesName.loginScreen);
//             },
//
//           ),
//           const SizedBox(height: 15),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDrawerItem(BuildContext context,
//       {required IconData icon,
//         required String text,
//         required VoidCallback onTap}) {
//     final theme = Theme.of(context);
//     return ListTile(
//       leading: Icon(icon, color: theme.colorScheme.primary),
//       title: Text(
//         text,
//         style: TextStyle(
//           color: theme.colorScheme.onSurface,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       onTap: onTap,
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../colors/colors.dart';
import '../routes/routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ─────────────────────────────
            // 🧑 Drawer Header
            // ─────────────────────────────
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.emeraldGreen.withOpacity(0.9),
                    AppColor.gold.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  // 👤 Profile Avatar
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppColor.emeraldGreen,
                    ),
                  ),
                  const SizedBox(width: 15),

                  // 👋 Welcome Text
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user != null
                              ? (user.displayName ?? "Traveler")
                              : "Guest",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          user?.email ?? "Welcome to your journey 🌍",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ─────────────────────────────
            // 📋 Drawer Menu Items
            // ─────────────────────────────
            _buildDrawerItem(
              icon: Icons.home_outlined,
              text: "Home",
              onTap: () => Get.offAllNamed(RoutesName.homeViews),
            ),
            _buildDrawerItem(
              icon: Icons.menu_book_outlined,
              text: "Dua Library",
              onTap: () => Get.offAllNamed(RoutesName.duaLibrary),
            ),
            _buildDrawerItem(
              icon: Icons.chat_bubble_outline,
              text: "Chat",
              onTap: () => Get.offAllNamed(RoutesName.chat),
            ),
            _buildDrawerItem(
              icon: Icons.more_horiz,
              text: "More",
              onTap: () => Get.offAllNamed(RoutesName.more),
            ),
            _buildDrawerItem(
              icon: Icons.settings_outlined,
              text: "Settings",
              onTap: () => Get.offAllNamed(RoutesName.setting),
            ),
            const Spacer(),

            // ─────────────────────────────
            // 🚪 Logout Section
            // ─────────────────────────────
            Divider(
              thickness: 0.8,
              color: theme.dividerColor.withOpacity(0.3),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColor.error),
              title: const Text(
                "Logout",
                style: TextStyle(
                  color: AppColor.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () async {
                final confirm = await _showLogoutDialog(context);
                if (confirm) {
                  await FirebaseAuth.instance.signOut();
                  Get.offAllNamed(RoutesName.loginScreen);
                }
              },
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────
  // 🧱 Drawer Item Builder
  // ─────────────────────────────
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColor.emeraldGreen),
      title: Text(
        text,
        style: const TextStyle(
          color: AppColor.deepCharcoal,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  // ─────────────────────────────
  // 🔐 Confirm Logout Dialog
  // ─────────────────────────────
  Future<bool> _showLogoutDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout"),
        content:
        const Text("Are you sure you want to log out from your account?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    ) ??
        false;
  }
}
