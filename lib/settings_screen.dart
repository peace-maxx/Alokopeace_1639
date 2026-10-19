import 'package:flutter/material.dart';
import 'main.dart'; // for AppColors and LoginScreen

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _comingSoon(BuildContext context, String name) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$name - coming soon')));
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout',
                style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );

    if (ok == true && context.mounted) {
      // Clear all previous screens so Back can't return to the app
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'PHAKOL Poultry Farm',
      applicationVersion: '1.0.0',
      applicationIcon:
          const Icon(Icons.egg_alt, size: 40, color: AppColors.green),
      children: const [Text('Broiler Farm Management System')],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionLabel('Account'),
          _SettingsGroup(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person),
                ),
                title: const Text('John Matovu',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Farm Manager'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _comingSoon(context, 'Profile'),
              ),
              _SettingsTile(
                icon: Icons.home_work_outlined,
                title: 'Farm Information',
                onTap: () => _comingSoon(context, 'Farm Information'),
              ),
              _SettingsTile(
                icon: Icons.group_outlined,
                title: 'User Management',
                onTap: () => _comingSoon(context, 'User Management'),
              ),
              _SettingsTile(
                icon: Icons.settings_outlined,
                title: 'App Preferences',
                onTap: () => _comingSoon(context, 'App Preferences'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _SectionLabel('General'),
          _SettingsGroup(
            children: [
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'About App',
                onTap: () => _showAbout(context),
              ),
              _SettingsTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () => _comingSoon(context, 'Help & Support'),
              ),
            ],
          ),
          const SizedBox(height: 28),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              foregroundColor: AppColors.red,
              side: const BorderSide(color: AppColors.red),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => _confirmLogout(context),
            child: const Text('Logout',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGreen)),
    );
  }
}

/// A white card holding several tiles, with dividers between them.
class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i < children.length - 1) {
        rows.add(const Divider(height: 1, indent: 16, endIndent: 16));
      }
    }
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(children: rows),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.green),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}