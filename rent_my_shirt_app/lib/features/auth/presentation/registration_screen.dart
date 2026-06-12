import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import 'otp_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  
  final ImagePicker _picker = ImagePicker();
  XFile? _idCardImage;
  Uint8List? _idCardBytes;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _idCardImage = image;
          _idCardBytes = bytes;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _register() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final company = _companyController.text.trim();

    if (fullName.isEmpty || email.isEmpty || phone.isEmpty || company.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    if (_idCardBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload your company ID card')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      // 1. Upload ID card to Supabase Storage
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${_idCardImage!.name}';
      final storagePath = 'id_cards/$fileName';
      
      await Supabase.instance.client.storage.from('kyc_documents').uploadBinary(
        storagePath,
        _idCardBytes!,
        fileOptions: const FileOptions(upsert: true),
      );
      
      final idCardUrl = Supabase.instance.client.storage.from('kyc_documents').getPublicUrl(storagePath);

      // 2. Call send-otp edge function with registration data
      final response = await Supabase.instance.client.functions.invoke(
        'send-otp',
        body: {
          'email': email,
          'fullName': fullName,
          'phone': phone,
          'company': company,
          'idCardUrl': idCardUrl,
        },
      );
      
      if (response.status != 200) {
        final error = response.data['error'] ?? 'Registration failed. Try again.';
        if (error == 'ACCOUNT_EXISTS') {
          if (!mounted) return;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Account Exists'),
              content: const Text('An account with this email or phone number is already registered. Please go to Login.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to login screen
                  },
                  child: const Text('Go to Login', style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
          );
          return;
        }
        throw Exception(error);
      }
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! Check your email for the OTP.')),
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OtpScreen(email: email)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wearbox Registration'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Join Wearbox and upgrade your wardrobe.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              
              _buildTextField('Full Name', _fullNameController, TextInputType.name),
              const SizedBox(height: 16),
              _buildTextField('Email Address', _emailController, TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextField('Phone Number', _phoneController, TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField('Present Working Company', _companyController, TextInputType.text),
              const SizedBox(height: 24),
              
              Text('Company ID Card', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _idCardBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(_idCardBytes!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.upload_file, color: AppColors.textSecondary, size: 32),
                            const SizedBox(height: 8),
                            Text('Tap to upload ID card', style: TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                ),
              ),
              
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Register & Get OTP',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType type) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
      ),
    );
  }
}
