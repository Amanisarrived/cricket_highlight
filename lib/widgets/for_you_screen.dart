import 'package:cricket_highlight/widgets/shimmerbox.dart';
import 'package:cricket_highlight/widgets/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../model/moviemodel.dart';
import '../provider/categoryprovider.dart';
import '../service/analytics_service.dart';
import '../views/home/videoplayerscreen.dart';
import 'adwidget/homebannerad.dart';
import 'apptext.dart';

class ForYouScreen extends StatefulWidget {
  const ForYouScreen({super.key});

  @override
  State<ForYouScreen> createState() => _ForYouScreenState();
}

class _ForYouScreenState extends State<ForYouScreen> {
  List<MovieModel> randomMovies = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<CategoryProvider>();

      if (provider.isMoviesStale) {
        await provider.loadMovies(forceRefresh: true);
      }

      if (mounted) {
        setState(() {
          randomMovies = provider.getRandomMovies(count: 18);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionTitle("For You"),
        _buildVerticalList(context, randomMovies),
      ],
    );
  }
}

Widget _buildVerticalList(
    BuildContext context,
    List<MovieModel> list, {
      bool isSearch = false,
    }) {
  if (list.isEmpty) {
    if (isSearch) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: AppText("No results found", color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (_, index) => const Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 12),
        child: VideoCardShimmer(),
      ),
    );
  }

  // 🔥 total items including ads
  final int totalItems = list.length + (list.length ~/ 3);

  return ListView.builder(
    shrinkWrap: !isSearch,
    physics: isSearch
        ? const AlwaysScrollableScrollPhysics()
        : const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.fromLTRB(
      8,
      isSearch ? 10 : 40,
      8,
      isSearch ? 90 : 40,
    ),
    itemCount: totalItems,

    // ✅ PRELOAD
    cacheExtent: 1000,

    itemBuilder: (_, index) {
      // हर 4th item पे ad
      if ((index + 1) % 4 == 0) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 25),
          child: RepaintBoundary( // ✅ isolate ad repaint
            child: HomeBannerAd(),
          ),
        );
      }

      final realIndex = index - (index ~/ 4);
      final movie = list[realIndex];

      return AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 50),
        child: SlideAnimation(
          verticalOffset: 50,
          child: FadeInAnimation(
            child: RepaintBoundary( // ✅ isolate card repaint
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: VideoCard(
                  movie: movie,
                  onTap: () {
                    AnalyticsService.logEvent(
                      isSearch
                          ? 'search_result_opened'
                          : 'recommended_video_opened',
                      params: {'title': movie.name},
                    );

                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            VideoPlayerScreen(
                              videoUrl: movie.url,
                              title: movie.name,
                            ),
                        transitionDuration:
                        const Duration(milliseconds: 300),
                        transitionsBuilder:
                            (_, animation, __, child) =>
                            FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildSectionTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 2,
            color: Colors.redAccent,
          ),
        ),
        const SizedBox(width: 10),
        AppText(
          text,
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 2,
            color: Colors.redAccent,
          ),
        ),
      ],
    ),
  );
}
