import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AiStylistTab extends StatelessWidget {
  const AiStylistTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Stylist'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your looks for this week', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildLookCard('Monday', 'White Oxford Shirt', 'Navy Tee', Colors.blue.shade100),
            _buildLookCard('Tuesday', 'Blue Stripe Shirt', 'White Tee', Colors.lightBlue.shade100),
            _buildLookCard('Wednesday', 'Pink Stripe Shirt', 'White Tee', Colors.pink.shade100),
            _buildLookCard('Thursday', 'Grey Textured Shirt', 'Black Tee', Colors.grey.shade300),
            _buildLookCard('Friday', 'Navy Check Shirt', 'White Tee', AppColors.primary.withValues(alpha: 0.2)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Generate My Looks'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLookCard(String day, String shirt, String tee, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Icon(Icons.checkroom, color: Colors.black26)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(day, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(shirt, style: const TextStyle(color: AppColors.textSecondary)),
                Text(tee, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
