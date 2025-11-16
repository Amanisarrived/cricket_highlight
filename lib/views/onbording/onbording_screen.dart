import 'package:cricket_highlight/widgets/appbutton.dart';
import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:cricket_highlight/views/onbording/onbordingscreen2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnbordingScreen extends StatelessWidget {
  const OnbordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image with opacity
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              "assets/images/onbording1.png",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
          ),

          // Foreground content
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  const AppText(
                    'THE GAME RELOADED',
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )
                      .animate()
                      .slideY(
                    begin: 1,
                    end: 0,
                    duration: 600.ms,
                    curve: Curves.easeOut,
                  )
                      .fadeIn(duration: 600.ms),

                  // Subtitle
                  const SizedBox(height: 10),
                  const AppText(
                    "Every boundary, every wicket. Catch the full story in moments.",
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  )
                      .animate(delay: 400.ms)
                      .slideY(
                    begin: 1,
                    end: 0,
                    duration: 700.ms,
                    curve: Curves.easeOut,
                  )
                      .fadeIn(duration: 700.ms),

                  const SizedBox(height: 30),

                  // Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0,20, 20),
                    child: AppButton(
                      text: "Next",
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 700),
                            pageBuilder: (_, animation, secondaryAnimation) =>
                            const OnbordingScreen2(),
                            transitionsBuilder: (_, animation, __, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    )
                        .animate(delay: 800.ms)
                        .slideY(
                      begin: 1.2,
                      end: 0,
                      duration: 700.ms,
                      curve: Curves.easeOut,
                    )
                        .fadeIn(duration: 700.ms),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
