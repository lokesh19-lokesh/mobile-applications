import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardData {
  final Map<String, dynamic>? profile;
  final List<dynamic> activeOrders;

  DashboardData({this.profile, this.activeOrders = const []});
}

final dashboardProvider = FutureProvider.autoDispose<DashboardData>((ref) async {
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) {
    return DashboardData();
  }

  try {
    // 1. Fetch Profile
    final profileRes = await supabase
        .from('customer_profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    // 2. Fetch Active Box (Orders)
    final ordersRes = await supabase
        .from('orders')
        .select('*, shirt_inventory(*, shirts(*))')
        .eq('user_id', userId)
        .inFilter('status', ['PENDING', 'CONFIRMED', 'OUT_FOR_DELIVERY', 'DELIVERED']);

    return DashboardData(
      profile: profileRes,
      activeOrders: ordersRes as List<dynamic>,
    );
  } catch (e) {
    print('Error fetching dashboard data: $e');
    // Return empty state if it fails
    return DashboardData();
  }
});
