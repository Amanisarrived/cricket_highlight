import 'package:animations/animations.dart';
import 'package:cricket_highlight/provider/categoryprovider.dart';
import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:cricket_highlight/widgets/video_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/home/videoplayerscreen.dart';

class HighlightsSection extends StatelessWidget {
  const HighlightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final highlightMovies = categoryProvider.getMoviesByCategoryId(35).reversed.toList();

    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  "Highlights",
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 4),
                Container(height: 2, width: 80, color: Colors.redAccent),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 🧠 Handle different states
          if (categoryProvider.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(color: Colors.redAccent),
              ),
            )
          else if (highlightMovies.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "No highlights available.",
                style: TextStyle(color: Colors.white70),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  for (var movie in highlightMovies)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: VideoCard(movie: movie, onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 600),
                            reverseTransitionDuration: const Duration(milliseconds: 400),
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                VideoPlayerScreen(videoUrl: movie.url),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SharedAxisTransition(
                                animation: animation,
                                secondaryAnimation: secondaryAnimation,
                                transitionType: SharedAxisTransitionType.horizontal,
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
        ],
      ),
    );
  }
}
