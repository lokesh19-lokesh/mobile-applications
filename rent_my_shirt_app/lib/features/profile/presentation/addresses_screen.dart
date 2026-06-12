import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<dynamic> _addresses = [];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final data = await _supabase
          .from('addresses')
          .select()
          .eq('user_id', user.id)
          .order('is_default', ascending: false);

      setState(() => _addresses = data);
    } catch (e) {
      debugPrint('Error loading addresses: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showAddAddressModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddAddressModal(),
    ).then((value) {
      if (value == true) _loadAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Delivery Addresses'),
        backgroundColor: AppColors.surface,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _addresses.isEmpty
              ? _buildEmptyState()
              : _buildAddressList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAddressModal,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add New', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text('No addresses found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Add a delivery address to receive your boxes.', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildAddressList() {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: _addresses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final address = _addresses[index];
        final isDefault = address['is_default'] == true;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDefault ? AppColors.primary : AppColors.divider),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isDefault ? Icons.check_circle : Icons.location_on_outlined,
                color: isDefault ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDefault)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text('Default Address', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    Text(address['street_address'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('${address['city']}, ${address['state']} ${address['postal_code']}', style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                onPressed: () {},
              )
            ],
          ),
        );
      },
    );
  }
}

class _AddAddressModal extends StatefulWidget {
  const _AddAddressModal();

  @override
  State<_AddAddressModal> createState() => _AddAddressModalState();
}

class _AddAddressModalState extends State<_AddAddressModal> {
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  bool _isDefault = false;
  bool _isSaving = false;

  Future<void> _save() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    
    if (_streetController.text.isEmpty || _cityController.text.isEmpty || _stateController.text.isEmpty || _zipController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      if (_isDefault) {
        // Reset others
        await Supabase.instance.client
            .from('addresses')
            .update({'is_default': false})
            .eq('user_id', user.id);
      }

      await Supabase.instance.client.from('addresses').insert({
        'user_id': user.id,
        'street_address': _streetController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'postal_code': _zipController.text,
        'is_default': _isDefault,
      });

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add New Address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          TextField(controller: _streetController, decoration: const InputDecoration(labelText: 'Street Address', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: TextField(controller: _cityController, decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()))),
              const SizedBox(width: 16),
              Expanded(child: TextField(controller: _stateController, decoration: const InputDecoration(labelText: 'State', border: OutlineInputBorder()))),
            ],
          ),
          const SizedBox(height: 16),
          TextField(controller: _zipController, decoration: const InputDecoration(labelText: 'Postal Code', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Set as Default Address'),
            value: _isDefault,
            onChanged: (val) => setState(() => _isDefault = val),
            activeThumbColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isSaving 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Save Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
