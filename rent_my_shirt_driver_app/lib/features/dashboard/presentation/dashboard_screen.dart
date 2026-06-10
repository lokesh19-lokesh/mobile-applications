import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../profile/presentation/driver_profile_screen.dart';
import 'map_navigation_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const OrdersListScreen(),
    const DriverProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: AppColors.surface,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Tasks'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 12, color: AppColors.success),
                const SizedBox(width: 8),
                Text('Online', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTaskCard(
            context: context,
            type: 'PICKUP',
            address: '123 Tech Park, Block B',
            distance: '2.5 km',
            time: '10 mins away',
          ),
          _buildTaskCard(
            context: context,
            type: 'DELIVERY',
            address: '456 Rose Gardens, Apt 4A',
            distance: '5.2 km',
            time: '20 mins away',
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard({required BuildContext context, required String type, required String address, required String distance, required String time}) {
    final isPickup = type == 'PICKUP';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isPickup ? Colors.blue.withValues(alpha: 0.2) : AppColors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  type,
                  style: GoogleFonts.inter(
                    color: isPickup ? Colors.blue : AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(distance, style: GoogleFonts.inter(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(isPickup ? Icons.storefront : Icons.home_work, color: AppColors.textPrimary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  address,
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(time, style: GoogleFonts.inter(color: AppColors.textSecondary)),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Accept'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
