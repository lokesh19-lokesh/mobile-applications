import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailUpdates = false;
  final bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'App Preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Push Notifications', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Delivery updates and reminders', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    value: _pushNotifications,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) => setState(() => _pushNotifications = val),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.divider),
                  SwitchListTile(
                    title: const Text('Email Updates', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Promotions and new collections', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    value: _emailUpdates,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) => setState(() => _emailUpdates = val),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.divider),
                  SwitchListTile(
                    title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Coming soon', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    value: _darkMode,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dark Mode coming in next update!')));
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            const Text(
              'Legal & About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Terms of Service', style: TextStyle(fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.divider),
                  ListTile(
                    title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.divider),
                  ListTile(
                    title: const Text('App Version', style: TextStyle(fontWeight: FontWeight.w600)),
                    trailing: const Text('1.0.0 (Beta)', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            
            Center(
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Account?'),
                      content: const Text('Are you sure you want to delete your account? This action cannot be undone and you will lose all your subscription history.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please contact support to delete your account.')));
                          },
                          child: const Text('Delete', style: TextStyle(color: AppColors.error)),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Delete Account', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
