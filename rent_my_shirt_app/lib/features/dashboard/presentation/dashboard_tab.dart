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
  late String _seconds;

  @override
  void initState() {
    super.initState();
    _calculateNextDelivery();
    _updateCountdown();
    // Update every second for a live countdown feel
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
      _seconds = '00';
      _calculateNextDelivery(); // recalculate if passed
      return;
    }

    _days = difference.inDays.toString().padLeft(2, '0');
    _hours = (difference.inHours % 24).toString().padLeft(2, '0');
    _minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
    _seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');
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

          return RefreshIndicator(
            onRefresh: () async {
              return ref.refresh(dashboardProvider.future);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 380.0,
                  pinned: true,
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/hero_image.png',
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: AppColors.primary);
                          },
                        ),
                        // Gradient overlay for text readability
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.2),
                                Colors.black.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 24,
                          bottom: 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PREMIUM WORKWEAR. ZERO HASSLE.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Your Wardrobe.\nOn Subscription.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text('WB', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Greeting
                        Text('Hey $firstName 👋', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text('Your next box arrives in', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                        const SizedBox(height: 24),
                        
                        // Timer Boxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildPremiumTimeBox(_days, 'DAYS'),
                            const Text(':', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                            _buildPremiumTimeBox(_hours, 'HRS'),
                            const Text(':', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                            _buildPremiumTimeBox(_minutes, 'MIN'),
                            const Text(':', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                            _buildPremiumTimeBox(_seconds, 'SEC'),
                          ],
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Plan Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Choose Your Plan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            TextButton(
                              onPressed: () {},
                              child: const Text('View all', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.primary, width: 2),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: AppColors.primary.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text('MOST POPULAR', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                              ),
                              const SizedBox(height: 16),
                              Text(planName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('₹$planPrice', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 4.0),
                                    child: Text(' /month', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(planDetails, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Manage Plan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // This Week's Box
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('New In This Week', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(_getCurrentWeekDates(), style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('View all', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        if (orders.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.checkroom, size: 48, color: Colors.grey.shade400),
                                const SizedBox(height: 16),
                                const Text(
                                  'Your box is empty.\nTap below to build your wardrobe.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.textSecondary, height: 1.5, fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        else
                          SizedBox(
                            height: 140,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: orders.length,
                              itemBuilder: (context, index) {
                                final order = orders[index];
                                final inventory = order['shirt_inventory'];
                                final colorString = inventory != null ? inventory['color'] as String? : null;
                                return _buildPremiumShirtThumbnail(_getColorFromString(colorString));
                              },
                            ),
                          ),
                        
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('View Box', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPremiumTimeBox(String value, String label) {
    return Container(
      width: 65,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, height: 1.0)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPremiumShirtThumbnail(Color color) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.checkroom, color: Colors.black54, size: 40),
      ),
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
