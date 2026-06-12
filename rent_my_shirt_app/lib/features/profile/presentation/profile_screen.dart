import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/login_screen.dart';
import '../../subscription/presentation/subscription_screen.dart';
import '../../dashboard/data/dashboard_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);
    final currentUser = Supabase.instance.client.auth.currentUser;
    final email = currentUser?.email ?? 'user@example.com';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
      ),
      body: dashboardState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) {
          final profile = data.profile ?? {};
          final firstName = profile['first_name'] ?? 'User';
          final lastName = profile['last_name'] ?? '';
          final fullName = '$firstName $lastName'.trim();

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: AppColors.surface,
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.person, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(fullName.isEmpty ? 'User' : fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(email, style: const TextStyle(color: AppColors.textSecondary)),
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
                  _buildListTile(Icons.autorenew, 'Subscription', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionScreen()));
                  }),
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
          );
        },
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
