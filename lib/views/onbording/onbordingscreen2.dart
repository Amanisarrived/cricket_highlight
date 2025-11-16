import 'package:cricket_highlight/widgets/appbutton.dart';
import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:cricket_highlight/views/onbording/onbording_screen3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnbordingScreen2 extends StatelessWidget {
  const OnbordingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              "assets/images/onbording2.png",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AppText(
                        'FEEL THE HEAT.',
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

                  const AppText(
                        "Don't just watch the game, experience the defining moments.",
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0,20, 20),
                    child: AppButton(text: "Next", onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 700),
                          pageBuilder: (_, animation, secondaryAnimation) =>
                          const OnbordingScreen3(),
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
                    }),
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
