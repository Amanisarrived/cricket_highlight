import 'package:cricket_highlight/views/screenstate/screenstate.dart';
import 'package:cricket_highlight/widgets/appbutton.dart';
import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnbordingScreen3 extends StatelessWidget {
  const OnbordingScreen3({super.key});

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
              "assets/images/onbording3.png",
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
                        'CRICKET UNFILTERED.',
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
                        "The tension, the sledges, the victory roars. It's all here.",
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
                    child: AppButton(text: "Get Started", onPressed: () {
                      Navigator.pushReplacement(context, PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 700),
                        pageBuilder: (_, animation, secondaryAnimation) =>
                        const MainScreenState(),
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
                      ));
                    })
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
