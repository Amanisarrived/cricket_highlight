import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/hive_news_model.dart';
import '../../provider/news_provider.dart';
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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NewsProvider>().loadNews(refresh: true);
    });
  }


  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;

    await context.read<NewsProvider>().refreshNews();

    _isRefreshing = false;
  }


  Future<void> _scrollToTopAndRefresh() async {
    await _controller.animateToPage(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );

    await Future.delayed(const Duration(milliseconds: 200));

    _refreshKey.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.news.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.redAccent),
          );
        }

        if (provider.error != null && provider.news.isEmpty) {
          return Center(
            child: Text(
              provider.error!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final List<Newsmodel> newsList = provider.news;

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
                    double pageOffset = 0;

                    if (_controller.position.haveDimensions) {
                      pageOffset = _controller.page! - index;
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
