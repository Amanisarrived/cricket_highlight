import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/hive_news_model.dart';
import '../../provider/news_provider.dart';
import '../../service/analytics_service.dart';
import '../../widgets/news_card.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final PageController _controller = PageController();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
  GlobalKey<RefreshIndicatorState>();

  bool _isRefreshing = false;

  /// Analytics helpers
  int _currentIndex = 0;
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();

    // Screen visit log
    AnalyticsService.logScreen("NewsScreen");

    // Start timing first news
    _stopwatch.start();

    // Page change listener (swipe detect)
    _controller.addListener(_onPageChanged);

    // Init provider + load first batch
    Future.microtask(() {
      if (mounted) {
        context.read<NewsProvider>().init(refresh: true);
      }
    });
  }

  void _onPageChanged() {
    if (!_controller.position.haveDimensions) return;

    final int newIndex = (_controller.page ?? _controller.initialPage.toDouble()).round();

    if (newIndex != _currentIndex) {
      // Stop timing old news
      _logNewsReadTime(_currentIndex);

      // Reset & start timing new news
      _stopwatch
        ..reset()
        ..start();

      _currentIndex = newIndex;

      // Load next page if buffer running out
      if (mounted) {
        context.read<NewsProvider>().loadMoreIfNeeded(newIndex);
      }
    }
  }

  void _logNewsReadTime(int index) {
    final seconds = _stopwatch.elapsed.inSeconds;
    if (seconds == 0) return;

    AnalyticsService.logEvent(
      "news_read",
      params: {
        "index": index,
        "time_spent_sec": seconds,
      },
    );
  }

  @override
  void dispose() {
    // Log last viewed news before exit
    _logNewsReadTime(_currentIndex);

    _controller.removeListener(_onPageChanged);
    _controller.dispose();
    _stopwatch.stop();

    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;

    AnalyticsService.logEvent("news_pull_to_refresh");

    if (mounted) {
      await context.read<NewsProvider>().refreshNews();
    }

    _isRefreshing = false;
  }

  Future<void> _scrollToTopAndRefresh() async {
    AnalyticsService.logEvent("news_scroll_to_top");

    if (mounted) {
      await _controller.animateToPage(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );

      await Future.delayed(const Duration(milliseconds: 200));
      _refreshKey.currentState?.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.visibleNews.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.redAccent),
          );
        }

        if (provider.error != null && provider.visibleNews.isEmpty) {
          return Center(
            child: Text(
              provider.error!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final List<Newsmodel> newsList = provider.visibleNews;

        if (newsList.isEmpty) {
          return const Center(
            child: Text(
              "No news available",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          floatingActionButton: FloatingActionButton(
            elevation: 2,
            backgroundColor: Colors.grey.shade900,
            onPressed: _scrollToTopAndRefresh,
            child: const Icon(
              Icons.arrow_upward_rounded,
              color: Colors.white70,
              size: 18,
            ),
          ),
          body: RefreshIndicator(
            key: _refreshKey,
            onRefresh: _handleRefresh,
            color: Colors.redAccent,
            backgroundColor: Colors.black,
            edgeOffset: 80,
            child: PageView.builder(
              controller: _controller,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    double pageOffset = 0.0;

                    if (_controller.position.haveDimensions) {
                      pageOffset =
                          (_controller.page ?? _controller.initialPage.toDouble()) - index;
                    }

                    final double eased = Curves.easeOutCubic
                        .transform((1 - pageOffset.abs()).clamp(0.0, 1.0));

                    final double scale = 0.92 + (0.08 * eased);
                    final double translateY = 60 * (1 - eased);
                    final double opacity = 0.6 + (0.4 * eased);

                    return Opacity(
                      opacity: opacity,
                      child: Transform.translate(
                        offset: Offset(0, translateY),
                        child: Transform.scale(
                          scale: scale,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: NewsCard(
                    news: newsList[index],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
