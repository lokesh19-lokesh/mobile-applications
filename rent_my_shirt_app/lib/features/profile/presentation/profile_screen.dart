import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import 'security_deposit_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/login_screen.dart';
import 'rental_history_screen.dart';
import 'wallet_screen.dart';
import 'offers_screen.dart';
import 'support_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '+91 9876543210',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Security Deposit',
                        style: GoogleFonts.inter(color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹5,000',
                        style: GoogleFonts.inter(
                          color: AppColors.accent,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: Active',
                        style: GoogleFonts.inter(color: Colors.greenAccent, fontSize: 12),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                    ),
                    child: const Text('Withdraw'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildListTile(Icons.wallet, 'Wallet & Deposit (₹5000 Paid)', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SecurityDepositScreen()));
            }),
            _buildListTile(Icons.history, 'Rental History', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RentalHistoryScreen()));
            }),
            _buildListTile(Icons.account_balance_wallet_outlined, 'My Wallet', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletScreen()));
            }),
            _buildListTile(Icons.local_offer_outlined, 'Offers & Coupons', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const OffersScreen()));
            }),
            _buildListTile(Icons.help_outline, 'Help & Support', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen()));
            }),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: Text('Logout', style: GoogleFonts.inter(color: AppColors.error, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
