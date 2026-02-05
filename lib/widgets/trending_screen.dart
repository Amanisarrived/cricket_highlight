import 'package:cricket_highlight/widgets/shimmerbox.dart';
import 'package:cricket_highlight/widgets/video_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/moviemodel.dart';
import '../provider/categoryprovider.dart';
import '../service/analytics_service.dart';
import '../views/home/videoplayerscreen.dart';
import '../widgets/apptext.dart';

class TrendingScreen extends StatelessWidget {
  const TrendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    final trending = provider.getTrendingMovies();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 Trending Videos Vertical
            _buildSectionTitle("Latest Highlights"),
            const SizedBox(height: 15),
            trending.isEmpty
                ? const SizedBox(
              height: 300,
              child: VideoCardShimmer(),
            )
                : ListView.builder(
              reverse: true,
              shrinkWrap: true, // Column ke andar scrollable
              physics: const NeverScrollableScrollPhysics(), // parent scroll me clash na ho
              itemCount: trending.length,
              itemBuilder: (context, index) {
                final movie = trending[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: VideoCard(
                    tag: "Latest",
                    movie: movie,
                    onTap: () {
                      AnalyticsService.logEvent(
                        'trending_video_opened',
                        params: {'title': movie.name},
                      );

                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => VideoPlayerScreen(
                              videoUrl: movie.url, title: movie.name),
                          transitionDuration:
                          const Duration(milliseconds: 300),
                          transitionsBuilder: (_, animation, __, child) =>
                              FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        children: [
          Expanded(child: Container(height: 2, color: Colors.redAccent)),
          const SizedBox(width: 10),
          AppText(
            text,
            color: Colors.white,
            fontSize: 20, // title thoda bada
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(width: 10),
          Expanded(child: Container(height: 2, color: Colors.redAccent)),
        ],
      ),
    );
  }
}
