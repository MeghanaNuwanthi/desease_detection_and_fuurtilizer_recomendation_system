import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../localization/app_localization.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final t = AppLocalization.of(context);

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        title: Text(t.translate("settings")),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          settingsTile(
            icon: Icons.language,
            title: "Language",
            subtitle: "English / Sinhala",
          ),

          settingsTile(
            icon: Icons.notifications,
            title: "Notifications",
            subtitle: "Enable crop alerts",
          ),

          settingsTile(
            icon: Icons.info,
            title: "About",
            subtitle: "PaddyGuard AI v1.0",
          ),

          settingsTile(
            icon: Icons.logout,
            title: "Logout",
            subtitle: "",
          ),

        ],
      ),
    );
  }
}

Widget settingsTile({
  required IconData icon,
  required String title,
  required String subtitle,
}) {

  return Container(
    margin: const EdgeInsets.only(bottom: 15),

    child: ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      leading: Icon(icon, color: AppColors.primaryGreen),

      title: Text(title),

      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,

      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    ),
  );
}