import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text('BO', style: TextStyle(color: Colors.white)),
            ),
            accountName: const Text(
              'Business Owner',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: const Text(
              'owner@business.com',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            Icons.business,
            'Business Profile',
            () => Navigator.pushNamed(context, '/business_profile'),
          ),
          _buildSettingsTile(
            Icons.payment,
            'Payment Settings',
            () => Navigator.pushNamed(context, '/payment'),
          ),
          _buildSettingsTile(
            Icons.inventory_2,
            'Inventory Settings',
            () => Navigator.pushNamed(context, '/inventory'),
          ),
          _buildSettingsTile(
            Icons.people_outline,
            'User Management',
            () => Navigator.pushNamed(context, '/customers'),
          ),
          _buildSettingsTile(
            Icons.wifi_off,
            'Offline Status',
            () => Navigator.pushNamed(context, '/offline'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
