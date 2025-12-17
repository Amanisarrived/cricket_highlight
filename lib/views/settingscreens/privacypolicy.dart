import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({super.key});

  // --- Privacy Policy Content (Updated & Accurate) ---
  final String introText =
      "Cricket Highlights respects your privacy. This app does not require login, "
      "does not store personal information, and does not use any backend services.";

  final List<String> weCollect = [
    "Basic device information automatically collected by Google Play (model, OS version)",
    "Anonymous usage data provided automatically by Google Play",
  ];

  final List<String> weDontCollect = [
    "We do not collect your name, email, phone number, or any personal identity",
    "We do not collect your photos, files, or contacts",
    "We do not track your location",
    "We do not store any user-generated data on any server",
  ];

  final List<String> howAppWorks = [
    "The app streams cricket highlights using YouTube's official player",
    "All video content is fetched directly from YouTube",
    "We do not store or download any YouTube data on our servers",
    "YouTube may collect viewing data as per their own policies",
  ];

  final List<String> thirdParty = [
    "YouTube Player API (for streaming videos)",
    "Google Play Services (for basic device metrics)"
  ];

  final String closingText =
      "By using Cricket Highlights, you agree to this Privacy Policy. "
      "We may update this policy in the future. Continued use of the app means you accept any changes.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black12,
        title: const AppText("Privacy Policy", fontSize: 25, color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withAlpha(60),
                    blurRadius: 15,
                    spreadRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset("assets/images/applogo.png"),
              ),
            ),

            const SizedBox(height: 20),

            // Intro
            _sectionContainer(
              child: AppText(
                introText,
                fontSize: 16,
                color: Colors.white,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // Info We Collect
            _sectionTitle("Information We Collect"),
            const SizedBox(height: 12),
            _buildList(weCollect),
            const SizedBox(height: 24),

            // Info We Don't Collect
            _sectionTitle("What We Don’t Collect"),
            const SizedBox(height: 12),
            _buildList(weDontCollect),
            const SizedBox(height: 24),

            // How App Works
            _sectionTitle("How the App Uses Data"),
            const SizedBox(height: 12),
            _buildList(howAppWorks),
            const SizedBox(height: 24),

            // Third Party Services
            _sectionTitle("Third-Party Services"),
            const SizedBox(height: 12),
            _buildList(thirdParty),
            const SizedBox(height: 24),

            // Closing
            _sectionContainer(
              child: AppText(
                closingText,
                fontSize: 16,
                color: Colors.white,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Helpers ---
  Widget _sectionTitle(String title) {
    return AppText(
      title,
      fontSize: 20,
      color: Colors.redAccent,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildList(List<String> items) {
    return Column(
      children: items.map(
            (item) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.redAccent.withAlpha(70), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withAlpha(20),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 10, color: Colors.redAccent),
                const SizedBox(width: 10),
                Expanded(
                  child: AppText(
                    item,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _sectionContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: child,
    );
  }
}
