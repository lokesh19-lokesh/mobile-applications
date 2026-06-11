import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Text('WB', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hey Arjun 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Your next box arrives in', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildTimeBox('03', 'DAYS'),
                const Text(' : ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                _buildTimeBox('12', 'HRS'),
                const Text(' : ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                _buildTimeBox('45', 'MIN'),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Current Plan', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Professional', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text('₹2499 /month', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      const Text('4 Shirts + 1 Tee', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Manage Plan >', style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('This Week\'s Box', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('19 May - 25 May', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildShirtThumbnail(Colors.lightBlue.shade100),
                  _buildShirtThumbnail(Colors.grey.shade200),
                  _buildShirtThumbnail(Colors.pink.shade100),
                  _buildShirtThumbnail(AppColors.accent),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('View Box'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildShirtThumbnail(Color color) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: const Center(child: Icon(Icons.checkroom, color: Colors.black54)),
    );
  }
}
