import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Refer & Earn'),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Icon(Icons.card_giftcard, size: 100, color: AppColors.primary),
            const SizedBox(height: 24),
            const Text(
              'Give ₹500, Get ₹500',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Share your code with friends. When they subscribe to their first box, they get ₹500 off, and you get ₹500 off your next renewal!',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider, width: 2),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Referral Code', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      SizedBox(height: 4),
                      Text('LOKESH500', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2, color: AppColors.primary)),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Code copied to clipboard!')));
                    },
                    icon: const Icon(Icons.copy, color: AppColors.textSecondary),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening Share Dialog...')));
                },
                icon: const Icon(Icons.share, color: Colors.white),
                label: const Text('Share with Friends', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
