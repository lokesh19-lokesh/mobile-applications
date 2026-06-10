import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class MapNavigationScreen extends StatelessWidget {
  final String address;
  final String type;

  const MapNavigationScreen({
    super.key,
    required this.address,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mock Map Background
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF1A1A1A), // Dark map base
            child: Stack(
              children: [
                // Mock route line
                Positioned(
                  top: 200,
                  left: 100,
                  child: Container(
                    width: 200,
                    height: 4,
                    color: Colors.blueAccent,
                  ),
                ),
                // Driver icon
                const Positioned(
                  top: 190,
                  left: 90,
                  child: Icon(Icons.navigation, color: Colors.blueAccent, size: 32),
                ),
                // Destination marker
                Positioned(
                  top: 180,
                  left: 290,
                  child: Icon(
                    type == 'PICKUP' ? Icons.storefront : Icons.location_on,
                    color: type == 'PICKUP' ? Colors.blue : AppColors.accent,
                    size: 40,
                  ),
                ),
                Center(
                  child: Text(
                    'Google Maps Integration Pending Backend',
                    style: GoogleFonts.inter(
                      color: Colors.white24,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: AppColors.surface,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // Bottom Info Panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '12 mins',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                          Text(
                            '4.2 km away',
                            style: GoogleFonts.inter(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: type == 'PICKUP' ? Colors.blue.withValues(alpha: 0.2) : AppColors.accent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          type,
                          style: GoogleFonts.inter(
                            color: type == 'PICKUP' ? Colors.blue : AppColors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white12,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('John Doe', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(address, style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.call, color: AppColors.success),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Mark as arrived/picked up
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(type == 'PICKUP' ? 'Confirm Pickup' : 'Confirm Delivery'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
