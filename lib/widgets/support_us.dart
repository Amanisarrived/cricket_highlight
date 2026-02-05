import 'package:flutter/material.dart';
import 'adwidget/rewarded_ads.dart';

class SupportUsDialog extends StatefulWidget {
  const SupportUsDialog({super.key});

  /// Static method to show dialog
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const SupportUsDialog(),
    );
  }

  @override
  State<SupportUsDialog> createState() => _SupportUsDialogState();
}

class _SupportUsDialogState extends State<SupportUsDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.8,
      upperBound: 1.2,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // 🔥 Heart animation
            ScaleTransition(
              scale: _heartController,
              child: const Icon(
                Icons.favorite,
                color: Colors.redAccent,
                size: 50,
              ),
            ),
            const SizedBox(height: 14),

            // Title
            const Text(
              "Support CrickView ❤️",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),

            // Description
            const Text(
              "Enjoying the app? Watch a short ad to support us and keep it free!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),

            // Row with clickable text + Watch Ad button
            Row(
              children: [
                // ✅ Clickable text for Maybe Later
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context), // close dialog
                    child: const Center(
                      child: Text(
                        "Maybe Later",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Watch Ad button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: Colors.redAccent.withOpacity(0.6),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // close dialog

                      RewardedAdService.show(
                        onRewardEarned: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Thanks for supporting us! ❤️"),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Watch Ad",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
