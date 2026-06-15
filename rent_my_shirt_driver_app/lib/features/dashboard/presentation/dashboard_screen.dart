import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../profile/presentation/driver_profile_screen.dart';
import 'map_navigation_screen.dart';
import 'task_details_screen.dart';

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

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  List<dynamic> _orders = [];
  bool _isLoading = true;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final response = await Supabase.instance.client
          .from('orders')
          .select('*, shirt_inventory(shirts(name))')
          .inFilter('status', ['PENDING', 'ASSIGNED', 'PICKED_UP'])
          .order('created_at', ascending: false);
          
      if (mounted) {
        setState(() {
          _orders = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Tasks'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                  color: _isOnline ? AppColors.success : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  _isOnline ? 'Online' : 'Offline',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: _isOnline ? AppColors.success : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: _isOnline,
                  activeColor: AppColors.success,
                  onChanged: (value) {
                    setState(() {
                      _isOnline = value;
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
        : _orders.isEmpty 
          ? Center(child: Text('No active tasks', style: GoogleFonts.inter(color: AppColors.textSecondary)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                // For simplicity we infer type based on status
                final isPickup = order['status'] == 'PENDING' || order['status'] == 'ASSIGNED';
                final shirtName = order['shirt_inventory']?['shirts']?['name'] ?? 'Unknown Item';
                
                return _buildTaskCard(
                  context: context,
                  type: isPickup ? 'PICKUP' : 'DELIVERY',
                  address: isPickup ? (order['pickup_address'] ?? 'Warehouse') : (order['delivery_address'] ?? 'Customer Location'),
                  distance: 'Near you',
                  time: shirtName,
                  orderId: order['id'].toString(),
                );
              },
            ),
    );
  }

  Widget _buildTaskCard({required BuildContext context, required String type, required String address, required String distance, required String time, required String orderId}) {
    final isPickup = type == 'PICKUP';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
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
          const Divider(color: AppColors.divider),
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
                      builder: (context) => TaskDetailsScreen(
                        address: address,
                        type: type,
                        shirtName: time,
                        orderId: orderId,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('View Task'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
