import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/login_screen.dart';
import '../../home/presentation/main_wrapper_screen.dart';
import '../../subscription/presentation/subscription_screen.dart';
import '../../dashboard/data/dashboard_provider.dart';
import 'measurements_screen.dart';
import 'addresses_screen.dart';
import 'payment_methods_screen.dart';
import 'referral_screen.dart';
import 'support_screen.dart';
import 'settings_screen.dart';

import '../../auth/presentation/guest_login_prompt.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Profile'), centerTitle: true, backgroundColor: AppColors.surface),
        body: const GuestLoginPrompt(),
      );
    }

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

          return RefreshIndicator(
            onRefresh: () async {
              return ref.refresh(dashboardProvider.future);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                    _buildListTile(Icons.straighten, 'My Measurements', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MeasurementsScreen()));
                    }),
                    _buildListTile(Icons.location_on_outlined, 'Delivery Addresses', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AddressesScreen()));
                    }),
                    _buildListTile(Icons.payment, 'Payment Methods', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()));
                    }),
                    _buildListTile(Icons.autorenew, 'Subscription', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionScreen()));
                    }),
                    _buildListTile(Icons.card_giftcard, 'Refer & Earn', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ReferralScreen()));
                    }),
                    _buildListTile(Icons.help_outline, 'Help & Support', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen()));
                    }),
                    _buildListTile(Icons.settings_outlined, 'Settings', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                color: AppColors.surface,
                child: ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.error),
                  title: const Text('Log Out', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                  onTap: () async {
                    await Supabase.instance.client.auth.signOut();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MainWrapperScreen()),
                        (route) => false,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 48),
                ],
              ),
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
