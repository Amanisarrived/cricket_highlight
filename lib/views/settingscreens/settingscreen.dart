import 'package:cricket_highlight/views/settingscreens/aboutus.dart';
import 'package:cricket_highlight/views/settingscreens/privacypolicy.dart';
import 'package:cricket_highlight/views/settingscreens/termsandconditons.dart';
import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Settingscreen extends StatefulWidget {
  const Settingscreen({super.key});

  @override
  State<Settingscreen> createState() => _SettingscreenState();
}

class _SettingscreenState extends State<Settingscreen> {
  String appVersion = '';
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
      buildNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final InAppReview inAppReview = InAppReview.instance;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black12,
        title: const AppText("Settings", fontSize: 25, color: Colors.white),
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
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => PrivacyPolicyScreen(),
                  transitionDuration: const Duration(milliseconds: 300),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
                ),
              ),
            ),
            _buildTile(
              icon: LucideIcons.fileText,
              title: 'Terms & Conditions',
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => TermsAndConditionsScreen(),
                  transitionDuration: const Duration(milliseconds: 300),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
                ),
              ),
            ),
            _buildTile(
              icon: LucideIcons.info,
              title: 'About Us',
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => AboutUsScreen(),
                  transitionDuration: const Duration(milliseconds: 300),
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
                ),
              ),
            ),

            const SizedBox(height: 24),

            _buildTile(
              icon: LucideIcons.star,
              title: 'Rate Us',
              onTap: () async {
                final messenger = ScaffoldMessenger.of(context);

                final isAvailable = await inAppReview.isAvailable();

                if (isAvailable) {
                  inAppReview.openStoreListing(
                    appStoreId: '',
                    microsoftStoreId: '',
                  );
                } else {
                  messenger.showSnackBar(
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
                SharePlus.instance.share(
                  ShareParams(
                    text:
                        "'Check out this amazing app: https://play.google.com/store/apps/details?id=com.yourapp',",
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            _buildTile(
              icon: LucideIcons.badgeInfo,
              title: 'App Version: $appVersion',
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: const Color.fromARGB(230, 0, 0, 0),
                    elevation: 6,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.redAccent, width: 1),
                    ),
                    content: Text('App Version: $appVersion'),
                  ),
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
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.redAccent.withAlpha(70), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withAlpha(30),
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
