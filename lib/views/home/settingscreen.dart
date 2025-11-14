import 'package:cricket_highlight/views/settingscreens/aboutus.dart';
import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart'; // Lucide icons package
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';

class Settingscreen extends StatelessWidget {
  const Settingscreen({super.key});

  // Example URLs - replace with your actual links
  final String privacyPolicyUrl = 'https://yourapp.com/privacy';
  final String termsUrl = 'https://yourapp.com/terms';
  final String aboutUsUrl = 'https://yourapp.com/about';

  // Open URLs in browser
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final InAppReview inAppReview = InAppReview.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: const AppText("Setting", fontSize: 25, color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: Colors.black12,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            _buildTile(
              icon: LucideIcons.shield,
              title: 'Privacy Policy',
              onTap: () => _launchUrl(privacyPolicyUrl),
            ),
            _buildTile(
              icon: LucideIcons.fileText,
              title: 'Terms & Conditions',
              onTap: () => _launchUrl(termsUrl),
            ),
            _buildTile(
              icon: LucideIcons.info,
              title: 'About Us',
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => AboutUsScreen(),
                    transitionDuration: const Duration(milliseconds: 300),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildTile(
              icon: LucideIcons.star,
              title: 'Rate Us',
              onTap: () async {
                if (await inAppReview.isAvailable()) {
                  inAppReview.requestReview();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Review not available on this device.'),
                    ),
                  );
                }
              },
            ),
            _buildTile(
              icon: LucideIcons.share2,
              title: 'Share App',
              onTap: () {
                Share.share(
                  'Check out this amazing app: https://play.google.com/store/apps/details?id=com.yourapp',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black, // Tile background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.redAccent.withAlpha(70),
          width: 1.5,
        ), // Red accent border
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withAlpha(30), // subtle shadow
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.redAccent, size: 28),
        title: AppText(
          title,
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.redAccent,
          size: 18,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
