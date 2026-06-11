import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.divider,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Arjun Mehta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('arjun.mehta@gmail.com', style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              color: AppColors.surface,
              child: Column(
                children: [
                  _buildListTile(Icons.straighten, 'My Measurements', () {}),
                  _buildListTile(Icons.location_on_outlined, 'Delivery Addresses', () {}),
                  _buildListTile(Icons.payment, 'Payment Methods', () {}),
                  _buildListTile(Icons.autorenew, 'Subscription', () {}),
                  _buildListTile(Icons.card_giftcard, 'Refer & Earn', () {}),
                  _buildListTile(Icons.help_outline, 'Help & Support', () {}),
                  _buildListTile(Icons.settings_outlined, 'Settings', () {}),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              color: AppColors.surface,
              child: ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text('Log Out', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColors.textSecondary),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          onTap: onTap,
        ),
        const Divider(height: 1, indent: 56, endIndent: 24, color: AppColors.divider),
      ],
    );
  }
}
