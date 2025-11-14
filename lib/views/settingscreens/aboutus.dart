import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  AboutUsScreen({super.key});

  // App description and features
  final String appDescription =
      "Cricket Highlights brings you all the latest cricket moments, World Cup matches, "
      "and all format games in one place. Watch highlights without ads, save your favorite "
      "clips, and relive cricketing moments anytime.";

  final List<String> features = [
    "Watch highlights from all cricket formats",
    "Save your favorite moments",
    "No ads, uninterrupted experience",
    "Trending matches and top players moments",
    "World Cup and major tournaments coverage",
  ];

  final List<String> categories = [
    "ODI Highlights",
    "T20 Highlights",
    "Test Match Highlights",
    "World Cup Highlights",
    "Trending Matches",
    "Top Players Moments",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black12,
        title: const AppText("About Us", fontSize: 25, color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16,16, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App logo placeholder
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withAlpha(60),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                child: AppText(
                  "CH",
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // App description
            Container(
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
              child: AppText(
                appDescription,
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // Features section
            AppText(
              "Features",
              fontSize: 20,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 12),
            Column(
              children: features.map(
                    (feature) {
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
                        const Icon(Icons.check, color: Colors.redAccent),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppText(
                            feature,
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 24),

            // Categories section
            AppText(
              "Categories",
              fontSize: 20,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: categories.map(
                    (cat) {
                  return Container(
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
                    child: AppText(
                      cat,
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
