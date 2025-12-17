import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  TermsAndConditionsScreen({super.key});

  // --- Terms & Conditions Content ---
  final String introText =
      "Welcome to Cricket Highlights. By using this application, you agree to the "
      "Terms & Conditions outlined below. Please read them carefully.";

  final List<String> usageRules = [
    "You may use the app only for personal and non-commercial viewing.",
    "You agree not to copy, download, or redistribute video content.",
    "You may not attempt to modify, reverse-engineer, or hack the app.",
    "You must comply with all applicable laws while using the app.",
  ];

  final List<String> contentOwnership = [
    "All video content is streamed using YouTube’s official API.",
    "We do not own or host any videos displayed within the app.",
    "All rights to videos belong to their respective owners or channels.",
    "Any copyright claims should be directed to YouTube or the content owner.",
  ];

  final List<String> limitations = [
    "We do not guarantee uninterrupted or error-free service.",
    "We are not responsible for YouTube API changes impacting app behavior.",
    "We do not collect personal data or store user information.",
    "App availability may vary depending on region, device, and network.",
  ];

  final List<String> terminationPolicy = [
    "We reserve the right to restrict or terminate app access if misuse is detected.",
    "Users violating the Terms & Conditions may be restricted from future updates.",
  ];

  final String closingText =
      "By continuing to use Cricket Highlights, you acknowledge that you have read, "
      "understood, and agree to these Terms & Conditions. We may update these terms "
      "from time to time, and your continued use of the app signifies your acceptance "
      "of the updated terms.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black12,
        title: const AppText("Terms & Conditions", fontSize: 23, color: Colors.white),
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

            _sectionTitle("App Usage Rules"),
            const SizedBox(height: 12),
            _buildList(usageRules),
            const SizedBox(height: 24),

            _sectionTitle("Content Ownership"),
            const SizedBox(height: 12),
            _buildList(contentOwnership),
            const SizedBox(height: 24),

            _sectionTitle("Limitations & Liability"),
            const SizedBox(height: 12),
            _buildList(limitations),
            const SizedBox(height: 24),

            _sectionTitle("Termination Policy"),
            const SizedBox(height: 12),
            _buildList(terminationPolicy),
            const SizedBox(height: 24),

            _sectionContainer(
              child: AppText(
                closingText,
                fontSize: 16,
                color: Colors.white,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
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
