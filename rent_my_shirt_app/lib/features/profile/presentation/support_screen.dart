import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            _buildFaqItem(
              'How does renting work?',
              'Choose a subscription plan, receive a fresh box of premium shirts every month, wear them, and return them unwashed in the provided return bag when your next box arrives.',
            ),
            _buildFaqItem(
              'What if I stain or damage a shirt?',
              'Normal wear and tear is covered! We have professional dry cleaning to handle almost any stain. If a shirt is completely destroyed, a small replacement fee may apply based on your plan.',
            ),
            _buildFaqItem(
              'Can I pause my subscription?',
              'Yes, you can pause your subscription at any time from the Subscription settings. Pausing takes effect at the end of your current billing cycle.',
            ),
            _buildFaqItem(
              'Do I need to wash the shirts?',
              'No! Please do not wash the shirts. Simply place the worn shirts into the return bag. We handle all the premium dry cleaning and pressing.',
            ),
            
            const SizedBox(height: 48),
            const Text(
              'Still need help?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  const Icon(Icons.support_agent, size: 48, color: AppColors.primary),
                  const SizedBox(height: 16),
                  const Text('Contact Customer Care', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('Our team is available Mon-Fri, 9am to 6pm.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.chat),
                          label: const Text('Chat'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.email),
                          label: const Text('Email'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(answer, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
        ],
      ),
    );
  }
}
