import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityDepositScreen extends StatelessWidget {
  const SecurityDepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Deposit'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2C2C2C), Color(0xFF1E1E1E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.shield_outlined, size: 48, color: Colors.amber),
                    const SizedBox(height: 16),
                    Text(
                      '₹5,000',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'One-time Refundable Deposit',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Why is this required?',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildReasonItem(
                Icons.check_circle_outline,
                'Protects our premium inventory from severe damage or theft.',
              ),
              _buildReasonItem(
                Icons.money_off,
                'Fully refundable when you permanently close your account.',
              ),
              _buildReasonItem(
                Icons.bolt,
                'Allows for instant approvals on all future rentals.',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Show success snackbar and pop
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment Gateway Integration Pending')),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Pay Deposit Securely'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReasonItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.amber, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
