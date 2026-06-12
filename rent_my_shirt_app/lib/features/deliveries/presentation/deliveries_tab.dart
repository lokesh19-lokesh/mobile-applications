import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/presentation/guest_login_prompt.dart';

class DeliveriesTab extends StatelessWidget {
  const DeliveriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Deliveries'), centerTitle: true, backgroundColor: AppColors.surface),
        body: const GuestLoginPrompt(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Deliveries'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Box', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('4 Shirts + 1 Tee', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  const Text('Out for Delivery', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 4),
                  const Text('Arriving today by 8 PM', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 24),
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Icon(Icons.map, size: 48, color: Colors.black26)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimelineItem('Preparing', '18 May, 10:00 AM', isCompleted: true, isFirst: true),
                  _buildTimelineItem('Packed', '19 May, 04:30 PM', isCompleted: true),
                  _buildTimelineItem('Out for Delivery', '20 May, 09:00 AM', isActive: true),
                  _buildTimelineItem('Delivered', 'Pending', isLast: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, {bool isCompleted = false, bool isActive = false, bool isFirst = false, bool isLast = false}) {
    Color iconColor = AppColors.divider;
    IconData icon = Icons.circle_outlined;
    
    if (isCompleted) {
      iconColor = Colors.green;
      icon = Icons.check_circle;
    } else if (isActive) {
      iconColor = AppColors.primary;
      icon = Icons.local_shipping;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Icon(icon, color: iconColor, size: 24),
                if (!isLast) Expanded(child: Container(width: 2, color: isCompleted ? Colors.green : AppColors.divider, margin: const EdgeInsets.symmetric(vertical: 4))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
