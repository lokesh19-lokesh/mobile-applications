import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class DeliveryHistoryScreen extends StatelessWidget {
  const DeliveryHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery History'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 5,
        itemBuilder: (context, index) {
          final isDelivery = index % 2 == 0;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: isDelivery ? AppColors.accent.withValues(alpha: 0.2) : Colors.blue.withValues(alpha: 0.2),
                  child: Icon(
                    isDelivery ? Icons.home_work : Icons.storefront,
                    color: isDelivery ? AppColors.accent : Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isDelivery ? 'Delivered to Customer' : 'Picked up from Warehouse',
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '123 Main St, Block B',
                        style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Today, 2:${30 + index} PM',
                            style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12),
                          ),
                          Text(
                            '₹150',
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.success),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
