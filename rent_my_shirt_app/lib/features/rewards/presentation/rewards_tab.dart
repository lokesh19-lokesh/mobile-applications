import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/presentation/guest_login_prompt.dart';

class RewardsTab extends StatelessWidget {
  const RewardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Rewards'), centerTitle: true, backgroundColor: AppColors.surface),
        body: const GuestLoginPrompt(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rewards'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('WearCoins', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('1,250', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Redeem Now +', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Invite a friend', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 4),
                      Text('Get ₹500 WearCoins', style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Text('Invite'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Your Level', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Gold', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text('1,250 / 2,500', style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 8),
            const LinearProgressIndicator(
              value: 0.5,
              backgroundColor: AppColors.divider,
              color: Colors.amber,
              minHeight: 8,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            const SizedBox(height: 8),
            const Text('Next: Platinum', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 32),
            const Text('Benefits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildBenefitRow(Icons.checkroom, 'Free T-Shirt', 'On every 3rd box'),
            const SizedBox(height: 16),
            _buildBenefitRow(Icons.support_agent, 'Priority Support', 'Faster resolutions'),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.textPrimary),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }
}
