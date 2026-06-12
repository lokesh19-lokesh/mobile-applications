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
            const Center(child: Text('T-Shirts Coming Soon')),
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
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return _buildProductCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(int index) {
    final colors = [Colors.blue.shade100, Colors.grey.shade200, Colors.pink.shade100, Colors.black87, Colors.blue.shade800, Colors.white];
    final titles = ['White Oxford', 'Sky Blue', 'Grey Textured', 'Pink Stripe', 'Navy Check', 'Black Solid'];
    final price = '₹899';

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
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: const Center(child: Icon(Icons.checkroom, size: 48, color: Colors.black26)),
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
                Text(titles[index % titles.length], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
