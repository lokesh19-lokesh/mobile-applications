import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/login_screen.dart';

class WebLandingPage extends StatelessWidget {
  const WebLandingPage({super.key});

  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 800;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopNavBar(context),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildHeroSection(context),
                    const SizedBox(height: 60),
                    _buildFeatureBanner(context),
                    const SizedBox(height: 80),
                    _buildHowItWorks(context),
                    const SizedBox(height: 80),
                    _buildPlansSection(context),
                    const SizedBox(height: 80),
                    _buildNewInThisWeek(context),
                    const SizedBox(height: 80),
                    _buildReviewsSection(context),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavBar(BuildContext context) {
    bool isDesktop = _isDesktop(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/logo.png', height: 80),
          if (isDesktop)
            Row(
              children: [
                _navLink('How It Works'),
                const SizedBox(width: 32),
                _navLink('Collections'),
                const SizedBox(width: 32),
                _navLink('Plans'),
                const SizedBox(width: 32),
                _navLink('About Us'),
                const SizedBox(width: 32),
                _navLink('Reviews'),
              ],
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Get Started', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _navLink(String title) {
    return TextButton(
      onPressed: () {},
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    bool isDesktop = _isDesktop(context);
    
    Widget textContent = Padding(
      padding: EdgeInsets.only(right: isDesktop ? 40.0 : 0, left: isDesktop ? 40.0 : 20.0, bottom: isDesktop ? 0 : 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PREMIUM WORKWEAR. ZERO HASSLE.',
            style: TextStyle(
              color: Colors.red.shade400,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: isDesktop ? 64 : 48,
                fontWeight: FontWeight.w900,
                height: 1.1,
                color: Colors.black87,
              ),
              children: const [
                TextSpan(text: 'Your Wardrobe.\n'),
                TextSpan(text: 'On Subscription.', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '4 Fresh Shirts + 1 Premium Tee\nDelivered Every Monday.',
            style: TextStyle(fontSize: isDesktop ? 20 : 16, color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Start Subscription', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: const BorderSide(color: Colors.grey),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Explore Plans', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );

    Widget imageContent = Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 500,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            image: const DecorationImage(
              image: AssetImage('assets/images/hero_image.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 1, child: textContent),
          Expanded(flex: 1, child: imageContent),
        ],
      );
    } else {
      return Column(
        children: [
          textContent,
          imageContent,
        ],
      );
    }
  }

  Widget _buildFeatureBanner(BuildContext context) {
    bool isDesktop = _isDesktop(context);
    var items = [
      _featureItem(Icons.verified_outlined, 'Premium Quality', 'Finest fabrics'),
      _featureItem(Icons.local_shipping_outlined, 'Weekly Fresh Box', 'Handpicked for you'),
      _featureItem(Icons.sync_outlined, 'Easy Returns', 'Hassle-free pickup'),
      _featureItem(Icons.wash_outlined, 'No Laundry', 'We handle it'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: isDesktop 
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((e) => Padding(padding: const EdgeInsets.only(bottom: 24), child: e)).toList(),
          ),
    );
  }

  Widget _featureItem(IconData icon, String title, String subtitle) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.red, size: 32),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildHowItWorks(BuildContext context) {
    bool isDesktop = _isDesktop(context);
    var cards = [
      _stepCard('01', 'We Deliver', 'Fresh box at your doorstep every Monday.', Colors.grey.shade100),
      _stepCard('02', 'You Wear', 'Rock your week, stress-free.', Colors.grey.shade100),
      _stepCard('03', 'We Pickup', 'We pickup every weekend. Easy returns.', Colors.grey.shade100),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('How It Works', style: GoogleFonts.poppins(fontSize: isDesktop ? 32 : 24, fontWeight: FontWeight.bold)),
              if (isDesktop) TextButton(onPressed: () {}, child: const Text('View all', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 32),
          if (isDesktop)
            Row(
              children: [
                Expanded(child: cards[0]),
                const SizedBox(width: 24),
                Expanded(child: cards[1]),
                const SizedBox(width: 24),
                Expanded(child: cards[2]),
              ],
            )
          else
            Column(
              children: [
                cards[0],
                const SizedBox(height: 16),
                cards[1],
                const SizedBox(height: 16),
                cards[2],
              ],
            ),
        ],
      ),
    );
  }

  Widget _stepCard(String number, String title, String desc, Color bgColor) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(number, style: const TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: Colors.black54)),
          const Spacer(),
          const Align(
            alignment: Alignment.bottomRight,
            child: Icon(Icons.inventory_2_outlined, size: 64, color: Colors.black12),
          )
        ],
      ),
    );
  }

  Widget _buildPlansSection(BuildContext context) {
    bool isDesktop = _isDesktop(context);
    var plans = [
      _planCard('Starter', '1499', '3 Shirts', 'Perfect for getting started', false),
      _planCard('Professional', '2499', '4 Shirts + 1 Tee', 'Our best-selling plan', true),
      _planCard('Executive', '3999', 'Premium Collection', 'Premium shirts. Premium you.', false),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Choose Your Plan', style: GoogleFonts.poppins(fontSize: isDesktop ? 32 : 24, fontWeight: FontWeight.bold)),
                    const Text('Simple plans. Premium experience.', style: TextStyle(fontSize: 16, color: Colors.black54)),
                  ],
                ),
              ),
              if (isDesktop) TextButton(onPressed: () {}, child: const Text('View all plans', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 40),
          if (isDesktop)
            Row(
              children: [
                Expanded(child: plans[0]),
                const SizedBox(width: 24),
                Expanded(child: plans[1]),
                const SizedBox(width: 24),
                Expanded(child: plans[2]),
              ],
            )
          else
            Column(
              children: [
                plans[0],
                const SizedBox(height: 24),
                plans[1],
                const SizedBox(height: 24),
                plans[2],
              ],
            ),
        ],
      ),
    );
  }

  Widget _planCard(String title, String price, String feature1, String desc, bool isPopular) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isPopular ? Colors.red : Colors.grey.shade300, width: isPopular ? 2 : 1),
        boxShadow: isPopular ? [BoxShadow(color: Colors.red.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10))] : [],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPopular) ...[
            const Center(child: Text('MOST POPULAR', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2))),
            const SizedBox(height: 24),
          ],
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹$price', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(' /month', style: TextStyle(fontSize: 16, color: Colors.black54)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(feature1, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 40),
          if (isPopular)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Select Plan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          else
            TextButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Text('Select Plan', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNewInThisWeek(BuildContext context) {
    bool isDesktop = _isDesktop(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('New In This Week', style: GoogleFonts.poppins(fontSize: isDesktop ? 32 : 24, fontWeight: FontWeight.bold)),
                    const Text('Handpicked styles. Fresh every week.', style: TextStyle(fontSize: 16, color: Colors.black54)),
                  ],
                ),
              ),
              if (isDesktop) TextButton(onPressed: () {}, child: const Text('View all collection', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _shirtThumbnail(Colors.grey.shade100),
              _shirtThumbnail(Colors.pink.shade100),
              _shirtThumbnail(Colors.blue.shade100),
              _shirtThumbnail(Colors.grey.shade400),
              _shirtThumbnail(Colors.grey.shade800),
              _shirtThumbnail(Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shirtThumbnail(Color color) {
    return Container(
      width: 150,
      height: 200,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Icon(Icons.checkroom, size: 64, color: color == Colors.grey.shade800 ? Colors.white54 : Colors.black26),
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    bool isDesktop = _isDesktop(context);
    var reviews = [
      _reviewCard('Wearbox has completely changed the way I dress for work. Super convenient!', '- Rohit, Software Engineer'),
      _reviewCard('Premium shirts, always fresh and perfect fit.', '- Ankit, Product Manager'),
      _reviewCard('No more laundry or last-minute ironing. Love it!', '- Vivek, Consultant'),
      _reviewCard('Best subscription I\'ve ever had.', '- Arjun, Financial Analyst'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red.shade700,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('Loved by 10,000+ Professionals', style: GoogleFonts.poppins(fontSize: isDesktop ? 24 : 20, fontWeight: FontWeight.bold, color: Colors.white))),
                if (isDesktop) TextButton(onPressed: () {}, child: const Text('View all reviews', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 40),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: reviews[0]),
                  const SizedBox(width: 24),
                  Expanded(child: reviews[1]),
                  const SizedBox(width: 24),
                  Expanded(child: reviews[2]),
                  const SizedBox(width: 24),
                  Expanded(child: reviews[3]),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  reviews[0],
                  const SizedBox(height: 24),
                  reviews[1],
                  const SizedBox(height: 24),
                  reviews[2],
                  const SizedBox(height: 24),
                  reviews[3],
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _reviewCard(String text, String author) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.star, color: Colors.white, size: 16),
            Icon(Icons.star, color: Colors.white, size: 16),
            Icon(Icons.star, color: Colors.white, size: 16),
            Icon(Icons.star, color: Colors.white, size: 16),
            Icon(Icons.star, color: Colors.white, size: 16),
          ],
        ),
        const SizedBox(height: 16),
        Text('"$text"', style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
        const SizedBox(height: 16),
        Text(author, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    bool isDesktop = _isDesktop(context);
    
    Widget column1 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/images/logo.png', height: 80),
        const SizedBox(height: 24),
        const Text(
          'Find the perfect premium workwear and shirts on subscription for professionals in India.',
          style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.6),
        ),
        const SizedBox(height: 24),
        const Row(
          children: [
            Icon(Icons.facebook, color: Colors.black54, size: 24),
            SizedBox(width: 16),
            Icon(Icons.camera_alt_outlined, color: Colors.black54, size: 24),
            SizedBox(width: 16),
            Icon(Icons.alternate_email, color: Colors.black54, size: 24),
            SizedBox(width: 16),
            Icon(Icons.play_circle_outline, color: Colors.black54, size: 24),
          ],
        ),
      ],
    );

    Widget column2 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _footerLink('How It Works'),
        _footerLink('Collections'),
        _footerLink('Plans'),
      ],
    );

    Widget column3 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _footerLink('About Us'),
        _footerLink('Reviews'),
        _footerLink('FAQ & Support'),
      ],
    );

    Widget column4 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Contact Us', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(width: 30, height: 2, color: Colors.red),
        const SizedBox(height: 24),
        _contactItem(Icons.location_on_outlined, 'Banjara Hills, Hyderabad, India'),
        const SizedBox(height: 16),
        _contactItem(Icons.phone_outlined, '+91 94937 02966'),
        const SizedBox(height: 16),
        _contactItem(Icons.email_outlined, 'contact@wearbox.com'),
      ],
    );

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 20, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: column1),
                    const SizedBox(width: 40),
                    Expanded(flex: 1, child: column2),
                    Expanded(flex: 1, child: column3),
                    Expanded(flex: 1, child: column4),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    column1,
                    const SizedBox(height: 40),
                    column2,
                    const SizedBox(height: 24),
                    column3,
                    const SizedBox(height: 24),
                    column4,
                  ],
                ),
              const SizedBox(height: 60),
              Divider(color: Colors.grey.shade200, thickness: 1),
              const SizedBox(height: 24),
              if (isDesktop)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('© 2026 wearbox. All rights reserved. Powered by Wearbox Tech.', style: TextStyle(color: Colors.black54, fontSize: 14)),
                    Row(
                      children: [
                        TextButton(onPressed: () {}, child: const Text('Privacy Policy', style: TextStyle(color: Colors.black54))),
                        const SizedBox(width: 16),
                        TextButton(onPressed: () {}, child: const Text('Terms & Conditions', style: TextStyle(color: Colors.black54))),
                      ],
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(onPressed: () {}, child: const Text('Privacy Policy', style: TextStyle(color: Colors.black54))),
                        const SizedBox(width: 16),
                        TextButton(onPressed: () {}, child: const Text('Terms & Conditions', style: TextStyle(color: Colors.black54))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('© 2026 wearbox. All rights reserved.', style: TextStyle(color: Colors.black54, fontSize: 14), textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    const Text('Powered by Wearbox Tech.', style: TextStyle(color: Colors.black54, fontSize: 14), textAlign: TextAlign.center),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footerLink(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
        ),
      ),
    );
  }

  Widget _contactItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.black54, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.4),
          ),
        ),
      ],
    );
  }
}
