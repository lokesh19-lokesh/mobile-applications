import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import 'map_navigation_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  final String type;
  final String address;
  final String shirtName;
  final String orderId;

  const TaskDetailsScreen({
    super.key,
    required this.type,
    required this.address,
    required this.shirtName,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final isPickup = type == 'PICKUP';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Status/Type Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isPickup ? Colors.blue.withValues(alpha: 0.2) : AppColors.accent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isPickup ? 'PICKUP TASK' : 'DELIVERY TASK',
                style: GoogleFonts.inter(
                  color: isPickup ? Colors.blue : AppColors.accent,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Customer Info Card
            _buildSectionTitle('Customer Details'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.divider,
                    radius: 24,
                    child: Icon(Icons.person, color: AppColors.textPrimary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Doe', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('+91 9876543210', style: GoogleFonts.inter(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.call, color: AppColors.success),
                        style: IconButton.styleFrom(backgroundColor: AppColors.divider),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.message, color: Colors.blue),
                        style: IconButton.styleFrom(backgroundColor: AppColors.divider),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Location Info Card
            _buildSectionTitle('Location'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(isPickup ? Icons.storefront : Icons.home_work, color: AppColors.textPrimary, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPickup ? 'Warehouse' : 'Customer Address',
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          address,
                          style: GoogleFonts.inter(color: AppColors.textSecondary, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Item Details Card
            _buildSectionTitle('Item Details'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Item', style: GoogleFonts.inter(color: AppColors.textSecondary)),
                      Text(shirtName, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(color: AppColors.divider),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order ID', style: GoogleFonts.inter(color: AppColors.textSecondary)),
                      Text('#${orderId.substring(0, 8)}', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(color: AppColors.divider),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Instructions', style: GoogleFonts.inter(color: AppColors.textSecondary)),
                      Text('Handle with care', style: GoogleFonts.inter(fontStyle: FontStyle.italic)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MapNavigationScreen(
                    address: address,
                    type: type,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
            ),
            child: Text(
              'Accept & Start Trip',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}
