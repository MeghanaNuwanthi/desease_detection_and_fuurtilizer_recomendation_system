import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_colors.dart';
import '../../localization/app_localization.dart';
import '../../services/history_service.dart';

class SettingsScreen extends StatefulWidget {
  /// Called when the user picks a different language from this screen -
  /// same callback used by the initial language selection screen, just
  /// threaded down so it can be changed again later, not just once at
  /// first launch.
  final void Function(Locale) onLanguageSelected;

  const SettingsScreen({super.key, required this.onLanguageSelected});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const String _notificationsPrefKey = "notifications_enabled";

  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPref();
  }

  Future<void> _loadNotificationPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool(_notificationsPrefKey) ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsPrefKey, value);
    // Note: this only remembers the user's preference for now - there's no
    // actual notification scheduling wired up behind it yet. Flag this as
    // a known limitation / future work rather than pretending it's fully
    // wired, since no notification package is installed in pubspec.yaml.
  }

  void _showLanguagePicker() {
    final t = AppLocalization.of(context);

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(t.translate("select_language")),
        children: [
          SimpleDialogOption(
            onPressed: () {
              widget.onLanguageSelected(const Locale('en'));
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text("English"),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              widget.onLanguageSelected(const Locale('si'));
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text("සිංහල"),
            ),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: "PaddyGuard",
      applicationVersion: "v1.0",
      applicationIcon: const Icon(Icons.eco, color: AppColors.primaryGreen),
      children: const [
        SizedBox(height: 12),
        Text(
          "PaddyGuard helps Sri Lankan rice farmers detect crop diseases "
          "and get fertilizer recommendations using on-device AI.",
        ),
      ],
    );
  }

  Future<void> _confirmClearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear scan history?"),
        content: const Text(
          "This deletes all saved scan results from this device. This "
          "can't be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Clear",
              style: TextStyle(color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await HistoryService.instance.clearAll();

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Scan history cleared")));
  }

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
            onTap: _showLanguagePicker,
          ),

          settingsTileWithSwitch(
            icon: Icons.notifications,
            title: "Notifications",
            subtitle: "Enable crop alerts",
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
          ),

          settingsTile(
            icon: Icons.info,
            title: "About",
            subtitle: "PaddyGuard AI v1.0",
            onTap: _showAbout,
          ),

          settingsTile(
            icon: Icons.delete_outline,
            title: "Clear History",
            subtitle: "Delete all saved scan results",
            onTap: _confirmClearHistory,
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
  required VoidCallback onTap,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 15),

    child: ListTile(
      onTap: onTap,
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      leading: Icon(icon, color: AppColors.primaryGreen),

      title: Text(title),

      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,

      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    ),
  );
}

Widget settingsTileWithSwitch({
  required IconData icon,
  required String title,
  required String subtitle,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 15),

    child: ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      leading: Icon(icon, color: AppColors.primaryGreen),

      title: Text(title),

      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,

      trailing: Switch(
        value: value,
        activeColor: AppColors.primaryGreen,
        onChanged: onChanged,
      ),
    ),
  );
}
