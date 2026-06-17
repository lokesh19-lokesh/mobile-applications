import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'build_box_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/presentation/login_screen.dart';

class WardrobeTab extends StatefulWidget {
  const WardrobeTab({super.key});

  @override
  State<WardrobeTab> createState() => _WardrobeTabState();
}

class _WardrobeTabState extends State<WardrobeTab> {
  final List<String> _filters = ['All', 'Formal', 'Casual', 'Premium'];
  String _selectedFilter = 'All';

  bool _isLoading = true;
  List<Map<String, dynamic>> _shirts = [];
  RealtimeChannel? _realtimeChannel;

  @override
  void initState() {
    super.initState();
    _fetchShirts();
    _setupRealtime();
  }

  void _setupRealtime() {
    _realtimeChannel = Supabase.instance.client
        .channel('public:shirts')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'shirts',
          callback: (payload) {
            debugPrint('Realtime update received: ${payload.eventType}');
            _fetchShirts(silent: true);
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    if (_realtimeChannel != null) {
      Supabase.instance.client.removeChannel(_realtimeChannel!);
    }
    super.dispose();
  }

  Future<void> _fetchShirts({bool silent = false}) async {
    try {
      if (!silent) {
        setState(() {
          _isLoading = true;
        });
      }
      final data = await Supabase.instance.client
          .from('shirts')
          .select('*, shirt_categories(name)')
          .order('name');
      setState(() {
        _shirts = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching shirts: $e');
      if (!silent) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: const Text('Wardrobe'),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: 'Shirts'),
              Tab(text: 'T-Shirts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildShirtsView(),
            _buildTShirtsView(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final session = Supabase.instance.client.auth.currentSession;
            if (session == null) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const BuildBoxScreen()));
            }
          },
          backgroundColor: AppColors.primary,
          label: const Text('Build My Box'),
          icon: const Icon(Icons.checkroom),
        ),
      ),
    );
  }

  Widget _buildShirtsView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredShirts = _shirts.where((shirt) {
      final categoryName = shirt['shirt_categories']?['name'] ?? '';
      if (categoryName == 'T-Shirts') return false; // Handled in T-Shirts tab
      if (_selectedFilter == 'All') return true;
      return categoryName == _selectedFilter;
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: _filters.length,
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedFilter = filter);
                  },
                  backgroundColor: AppColors.background,
                  selectedColor: AppColors.primary.withValues(alpha: 0.1),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.divider,
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: filteredShirts.isEmpty
              ? const Center(child: Text('No shirts found for this category.'))
              : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: filteredShirts.length,
            itemBuilder: (context, index) {
              return _buildProductCard(filteredShirts[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTShirtsView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final tShirts = _shirts.where((shirt) {
      final categoryName = shirt['shirt_categories']?['name'] ?? '';
      return categoryName == 'T-Shirts';
    }).toList();

    if (tShirts.isEmpty) {
      return const Center(child: Text('No T-Shirts available right now.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: tShirts.length,
      itemBuilder: (context, index) {
        return _buildProductCard(tShirts[index]);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> shirt) {
    final title = shirt['name'] ?? 'Unknown';
    final price = '₹${shirt['price_1_day'] ?? 899}';
    final imageUrl = shirt['image_url'];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: imageUrl != null && imageUrl.toString().isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.checkroom, size: 48, color: Colors.black26)),
                          ),
                        )
                      : const Center(child: Icon(Icons.checkroom, size: 48, color: Colors.black26)),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border, size: 16, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(price, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
