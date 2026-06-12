import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

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

  Map<String, dynamic>? profileRes;
  List<dynamic> ordersRes = [];

  try {
    // 1. Fetch Profile
    profileRes = await supabase
        .from('customer_profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
  } catch (e) {
    debugPrint('Error fetching profile: $e');
  }

  try {
    // 2. Fetch Active Box (Orders)
    // Removed invalid shirt_inventory relationship for now since order_items table doesn't exist
    final response = await supabase
        .from('orders')
        .select()
        .eq('user_id', userId)
        .inFilter('status', ['PENDING', 'CONFIRMED', 'OUT_FOR_DELIVERY', 'DELIVERED']);
    ordersRes = response as List<dynamic>;
  } catch (e) {
    debugPrint('Error fetching active orders: $e');
  }

  return DashboardData(
    profile: profileRes,
    activeOrders: ordersRes,
  );
});
