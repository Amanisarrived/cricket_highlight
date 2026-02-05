import 'package:cricket_highlight/widgets/re_news_detils_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../provider/news_provider.dart';
import '../../service/analytics_service.dart';
import 'adwidget/homebannerad.dart';
import 'news_shimmer.dart';

class ReNewsScreen extends StatefulWidget {
  const ReNewsScreen({super.key});

  @override
  State<ReNewsScreen> createState() => _ReNewsScreenState();
}

class _ReNewsScreenState extends State<ReNewsScreen> {
  bool showShimmer = true;

  @override
  void initState() {
    super.initState();

    AnalyticsService.logScreen("ReNewsScreen");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<NewsProvider>().refreshNews();
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) setState(() => showShimmer = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, provider, _) {
        if ((provider.isLoading && provider.visibleNews.isEmpty) ||
            showShimmer) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: NewsShimmer(itemCount: 5),
          );
        }

        if (provider.error != null && provider.visibleNews.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                provider.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final newsList = provider.visibleNews;

        if (newsList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                "No news available",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          );
        }

        final int totalItems = newsList.length + (newsList.length ~/ 3);

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalItems,
          cacheExtent: 1000,
          itemBuilder: (context, index) {
            // हर 4th पे ad
            if ((index + 1) % 4 == 0) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: RepaintBoundary(
                  child: HomeBannerAd(),
                ),
              );
            }

            final realIndex = index - (index ~/ 4);
            if (realIndex >= newsList.length) return const SizedBox();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.loadMoreIfNeeded(realIndex);
            });

            final news = newsList[realIndex];

            return RepaintBoundary(
              child: GestureDetector(
                onTap: () {
                  AnalyticsService.logEvent(
                    "news_tile_click",
                    params: {
                      "news_title": news.title,
                      "news_id": news.id,
                    },
                  );

                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          ReNewsDetailScreen(news: news),
                      transitionDuration: const Duration(milliseconds: 300),
                      transitionsBuilder: (_, animation, __, child) =>
                          FadeTransition(opacity: animation, child: child),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withAlpha(40),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          news.imageUrl,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(height: 180, color: Colors.grey[800]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.bebasNeue(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              news.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.white12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              news.credits,
                              style: GoogleFonts.bebasNeue(
                                color: Colors.redAccent,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "${news.createdAt.day}/${news.createdAt.month}/${news.createdAt.year}",
                              style: GoogleFonts.inter(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
