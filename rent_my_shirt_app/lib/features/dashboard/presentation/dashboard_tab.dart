import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../data/dashboard_provider.dart';

class DashboardTab extends ConsumerStatefulWidget {
  const DashboardTab({super.key});

  @override
  ConsumerState<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends ConsumerState<DashboardTab> {
  Timer? _timer;
  late DateTime _nextDeliveryDate;
  late String _days;
  late String _hours;
  late String _minutes;

  @override
  void initState() {
    super.initState();
    _calculateNextDelivery();
    _updateCountdown();
    // Update every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {
          _updateCountdown();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _calculateNextDelivery() {
    // Next delivery is next Monday at 9 AM
    final now = DateTime.now();
    int daysUntilMonday = DateTime.monday - now.weekday;
    if (daysUntilMonday <= 0) {
      daysUntilMonday += 7;
    }
    _nextDeliveryDate = DateTime(now.year, now.month, now.day + daysUntilMonday, 9, 0, 0);
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final difference = _nextDeliveryDate.difference(now);
    
    if (difference.isNegative) {
      _days = '00';
      _hours = '00';
      _minutes = '00';
      _calculateNextDelivery(); // recalculate if passed
      return;
    }

    _days = difference.inDays.toString().padLeft(2, '0');
    _hours = (difference.inHours % 24).toString().padLeft(2, '0');
    _minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
  }

  String _getCurrentWeekDates() {
    final now = DateTime.now();
    // Find Monday of this week
    final monday = now.subtract(Duration(days: now.weekday - 1));
    // Find Sunday of this week
    final sunday = monday.add(const Duration(days: 6));
    
    final formatter = DateFormat('dd MMM');
    return '${formatter.format(monday)} - ${formatter.format(sunday)}';
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);

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
      body: dashboardState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading dashboard: $err')),
        data: (data) {
          final profile = data.profile ?? {};
          final firstName = profile['first_name'] ?? 'User';
          final planName = profile['plan_name'] ?? 'Professional';
          final planPrice = profile['plan_price'] ?? 2499;
          final planDetails = profile['plan_details'] ?? '4 Shirts + 1 Tee';
          
          final orders = data.activeOrders;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hey $firstName 👋', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Your next box arrives in', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildTimeBox(_days, 'DAYS'),
                    const Text(' : ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    _buildTimeBox(_hours, 'HRS'),
                    const Text(' : ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    _buildTimeBox(_minutes, 'MIN'),
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
                          Text(planName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('₹$planPrice /month', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text(planDetails, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
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
                    Text(_getCurrentWeekDates(), style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Dynamic shirts row
                if (orders.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'No active shirts in your box right now. Tap "View Box" to add some!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                else
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final inventory = order['shirt_inventory'];
                        final colorString = inventory != null ? inventory['color'] as String? : null;
                        return _buildShirtThumbnail(_getColorFromString(colorString));
                      },
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
          );
        },
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

  Color _getColorFromString(String? colorStr) {
    if (colorStr == null) return Colors.grey.shade200;
    switch (colorStr.toLowerCase()) {
      case 'black': return Colors.black87;
      case 'white': return Colors.white;
      case 'blue': return Colors.lightBlue.shade100;
      case 'pink': return Colors.pink.shade100;
      case 'red': return Colors.red.shade100;
      case 'green': return Colors.green.shade100;
      case 'grey': return Colors.grey.shade300;
      case 'navy': return const Color(0xFF000080);
      default: return Colors.grey.shade200;
    }
  }
}
