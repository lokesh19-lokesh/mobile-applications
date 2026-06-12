import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';

class MeasurementsScreen extends StatefulWidget {
  const MeasurementsScreen({super.key});

  @override
  State<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  bool _isSaving = false;
  
  // Measurement Values
  double _chest = 40;
  double _shoulders = 18;
  double _length = 29;
  double _sleeves = 25;
  String _fitPreference = 'Slim Fit';

  @override
  void initState() {
    super.initState();
    _loadMeasurements();
  }

  Future<void> _loadMeasurements() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final data = await _supabase
          .from('customer_profiles')
          .select('measurements')
          .eq('user_id', user.id)
          .maybeSingle();

      if (data != null && data['measurements'] != null) {
        final m = data['measurements'] as Map<String, dynamic>;
        setState(() {
          _chest = (m['chest'] ?? 40).toDouble();
          _shoulders = (m['shoulders'] ?? 18).toDouble();
          _length = (m['length'] ?? 29).toDouble();
          _sleeves = (m['sleeves'] ?? 25).toDouble();
          _fitPreference = m['fit'] ?? 'Slim Fit';
        });
      }
    } catch (e) {
      debugPrint('Error loading measurements: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveMeasurements() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);
    try {
      await _supabase.from('customer_profiles').update({
        'measurements': {
          'chest': _chest,
          'shoulders': _shoulders,
          'length': _length,
          'sleeves': _sleeves,
          'fit': _fitPreference,
        }
      }).eq('user_id', user.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Measurements saved successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving measurements: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Measurements'),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Perfect Fit Guarantee',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Update your measurements below to ensure every shirt we send fits perfectly.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            
            _buildMeasurementSlider('Chest (inches)', _chest, 34, 52, (val) => setState(() => _chest = val)),
            _buildMeasurementSlider('Shoulders (inches)', _shoulders, 15, 24, (val) => setState(() => _shoulders = val)),
            _buildMeasurementSlider('Shirt Length (inches)', _length, 25, 36, (val) => setState(() => _length = val)),
            _buildMeasurementSlider('Sleeve Length (inches)', _sleeves, 22, 30, (val) => setState(() => _sleeves = val)),
            
            const SizedBox(height: 24),
            const Text('Fit Preference', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildFitOption('Slim Fit'),
                const SizedBox(width: 12),
                _buildFitOption('Regular Fit'),
                const SizedBox(width: 12),
                _buildFitOption('Relaxed Fit'),
              ],
            ),
            
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveMeasurements,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSaving 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Save Measurements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('${value.toStringAsFixed(1)}"', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) * 2).toInt(),
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFitOption(String fitName) {
    final isSelected = _fitPreference == fitName;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _fitPreference = fitName),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
          ),
          child: Center(
            child: Text(
              fitName.split(' ')[0],
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
