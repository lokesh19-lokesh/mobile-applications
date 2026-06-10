import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('Available Balance', style: GoogleFonts.inter(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text('₹1,250', style: GoogleFonts.inter(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.primary,
                      ),
                      child: const Text('Add Money'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Recent Transactions', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTransactionTile('Added to Wallet', 'June 10', '+₹500', true),
            _buildTransactionTile('Rental Payment', 'May 1', '-₹499', false),
            _buildTransactionTile('Added to Wallet', 'April 10', '+₹1200', true),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(String title, String date, String amount, bool isCredit) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: isCredit ? Colors.green.shade50 : Colors.red.shade50,
        child: Icon(
          isCredit ? Icons.arrow_downward : Icons.arrow_upward,
          color: isCredit ? Colors.green : Colors.red,
        ),
      ),
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      subtitle: Text(date, style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12)),
      trailing: Text(
        amount,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: isCredit ? Colors.green : Colors.red,
          fontSize: 16,
        ),
      ),
    );
  }
}
