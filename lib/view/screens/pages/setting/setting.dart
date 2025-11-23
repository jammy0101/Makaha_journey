

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../controller/services/profile_services.dart';
import '../../../../controller/themeController/theme_controller.dart';
import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
import '../../../../resources/routes/routes.dart';
import '../../../../resources/colors/colors.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final ThemeController themeController = Get.find<ThemeController>();
  final UserService _userService = UserService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isEditing = false;
  bool isSaving = false;
  String selectedLanguage = 'English';

  final List<Map<String, dynamic>> languages = [
    {'name': 'English', 'locale': const Locale('en', 'US')},
    {'name': 'Arabic', 'locale': const Locale('ar', 'SA')},
    {'name': 'Urdu', 'locale': const Locale('ur', 'PK')},
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
    _loadUserData();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    setState(() {});
  }

  Future<void> _changeLanguage(String langName) async {
    final prefs = await SharedPreferences.getInstance();
    final locale = languages.firstWhere((lang) => lang['name'] == langName)['locale'] as Locale;

    await prefs.setString('selectedLanguage', langName);

    Get.updateLocale(locale); // UI rebuilds because we use Obx()

    setState(() => selectedLanguage = langName);
  }

  Future<void> _loadUserData() async {
    final data = await _userService.getUserData();
    final user = _userService.currentUser;

    if (data != null) {
      nameController.text = data['name'] ?? '';
      emailController.text = data['email'] ?? user?.email ?? '';
      phoneController.text = data['phone'] ?? '';
    } else {
      nameController.text = user?.displayName ?? '';
      emailController.text = user?.email ?? '';
    }

    setState(() {});
  }

  Future<void> _saveUserData() async {
    setState(() => isSaving = true);
    try {
      await _userService.updateUserData(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
      );

      Get.snackbar(
        'Profile Updated'.tr,
        'Your changes have been saved.'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );

      setState(() => isEditing = false);
    } catch (e) {
      Get.snackbar('Error'.tr, e.toString());
    } finally {
      setState(() => isSaving = false);
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Logout".tr),
        content: Text("Are you sure you want to log out?".tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel".tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.error,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () => Navigator.pop(context, true),
            child: Text("Logout".tr),
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      await _userService.signOut();
      Get.offAllNamed(RoutesName.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final user = _userService.currentUser;

      return Scaffold(
        backgroundColor: isDark ? AppColor.surfaceDark : AppColor.whiteCream,
        appBar: AppBar(
          title: Text('Settings'.tr),
          centerTitle: true,
          elevation: 0,
          backgroundColor: isDark ? AppColor.deepCharcoal : AppColor.gold,
          foregroundColor: isDark ? AppColor.gold : AppColor.whiteColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Get.offAllNamed(RoutesName.homeViews),
          ),
        ),
        bottomNavigationBar: const BottomNavigation(index: 4),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildProfileCard(user, isDark),
              const SizedBox(height: 25),

              _buildSettingTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode'.tr,
                trailing: Obx(() => Switch(
                  value: themeController.isDarkMode.value,
                  onChanged: (val) => themeController.toggleTheme(),
                )),
              ),

              _buildSettingTile(
                icon: Icons.language_outlined,
                title: 'Language'.tr,
                trailing: DropdownButton<String>(
                  value: selectedLanguage,
                  underline: const SizedBox(),
                  items: languages
                      .map((lang) => DropdownMenuItem<String>(
                    value: lang['name'],
                    child: Text(lang['name']),
                  ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) _changeLanguage(val);
                  },
                ),
              ),

              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),

              ListTile(
                leading: const Icon(Icons.logout, color: AppColor.error),
                title: Text(
                  'Logout'.tr,
                  style: const TextStyle(
                    color: AppColor.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: _logout,
              ),
            ],
          ),
        ),
      );
    });
  }

  // PROFILE CARD
  Widget _buildProfileCard(User? user, bool isDark) {
    return Card(
      color: isDark ? AppColor.surfaceDark : AppColor.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: user?.photoURL != null && user!.photoURL!.isNotEmpty
                  ? NetworkImage(user.photoURL!)
                  : const NetworkImage('https://cdn-icons-png.flaticon.com/512/149/149071.png'),

            ),
            const SizedBox(height: 15),

            Text(
              isEditing ? "Edit Profile".tr : "Profile".tr,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _buildTextField(
              controller: nameController,
              label: "Full Name".tr,
              icon: Icons.person_outline,
              enabled: isEditing,
            ),

            const SizedBox(height: 15),

            _buildTextField(
              controller: emailController,
              label: "Email".tr,
              icon: Icons.email_outlined,
              enabled: false,
            ),

            const SizedBox(height: 15),

            _buildTextField(
              controller: phoneController,
              label: "Mobile Number".tr,
              icon: Icons.phone_outlined,
              enabled: isEditing,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 20),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isEditing
                  ? ElevatedButton.icon(
                key: const ValueKey('save'),
                onPressed: isSaving ? null : _saveUserData,
                icon: isSaving
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.save),
                label: Text(isSaving ? "Saving...".tr : "Save Changes".tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.emeraldGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              )
                  : OutlinedButton.icon(
                key: const ValueKey('edit'),
                onPressed: () => setState(() => isEditing = true),
                icon: const Icon(Icons.edit, color: AppColor.emeraldGreen),
                label: Text("Edit Profile".tr,
                    style: const TextStyle(color: AppColor.emeraldGreen)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColor.emeraldGreen),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isRtl = ['ar', 'ur'].contains(Get.locale?.languageCode);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr, // override NoMirrorIcon here
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        textAlign: isRtl ? TextAlign.right : TextAlign.left,

        decoration: InputDecoration(
          labelText: label,

          // LTR → icon left
         // prefixIcon: isRtl ? null : Icon(icon, color: AppColor.emeraldGreen),

          // RTL → icon right
          //suffixIcon: isRtl ? Icon(icon, color: AppColor.emeraldGreen) : null,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: enabled
              ? Colors.grey.withOpacity(0.1)
              : Colors.grey.withOpacity(0.05),
        ),
      ),
    );
  }




  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: AppColor.emeraldGreen),
        title: Text(title),
        trailing: trailing,
      ),
    );
  }
}
