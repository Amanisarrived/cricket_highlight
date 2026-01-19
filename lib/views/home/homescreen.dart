import 'package:carousel_slider/carousel_slider.dart';
import 'package:cricket_highlight/provider/categoryprovider.dart';
import 'package:cricket_highlight/service/analytics_service.dart';
import 'package:cricket_highlight/utils/fadenavigation.dart';
import 'package:cricket_highlight/views/home/news_screen.dart';
import 'package:cricket_highlight/views/home/savedscreen.dart';
import 'package:cricket_highlight/views/home/videoplayerscreen.dart';
import 'package:cricket_highlight/utils/rate_us_dialog.dart';
import 'package:cricket_highlight/widgets/app_search_bar.dart';
import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:cricket_highlight/widgets/video_card.dart';
import 'package:cricket_highlight/widgets/adwidget/homebannerad.dart';
import 'package:cricket_highlight/widgets/adwidget/interstitialadwidget.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/moviemodel.dart';
import '../../widgets/shimmerbox.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();

  List<MovieModel> randomMovies = [];
  List<MovieModel> searchResults = [];
  String query = "";

  final TextEditingController _searchController = TextEditingController();
  bool _searchEventFired = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {}); // Tab change ke liye rebuild
    });

    AnalyticsService.logScreen("HomeScreen");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<CategoryProvider>();

      // 🔹 Load movies
      if (provider.isMoviesStale) {
        await provider.loadMovies(forceRefresh: true);
      }
      if (mounted) {
        setState(() {
          randomMovies = provider.getRandomMovies(count: 18);
        });
      }

      // 🔹 Interstitial Ad
      Future.delayed(const Duration(milliseconds: 800), () {
        InterstitialService.showAdIfReady(onComplete: () {
          AnalyticsService.logEvent('interstitial_ad_shown');
        });
      });


      await _showRateUsDialogIfNeeded();
    });
  }

  Future<void> _showRateUsDialogIfNeeded() async {
    if (!mounted) return; // ensure context is valid

    final prefs = await SharedPreferences.getInstance();

    // Get current open count & reviewed state
    int openCount = prefs.getInt('appOpenCount') ?? 0;
    bool hasReviewed = prefs.getBool('hasReviewed') ?? false;

    // Increment open count
    openCount++;
    await prefs.setInt('appOpenCount', openCount);

    // Clean debug print
    debugPrint(
      'HomeScreen openCount: $openCount, hasReviewed: $hasReviewed',
      wrapWidth: 1024,
    );

    // Show RateUsDialog only on 3rd open
    if (!hasReviewed && openCount == 3) {
      if (!mounted) return;
      RateUsDialog.show(context);
    }
  }





  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = query.isNotEmpty;

    if (isSearching) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildFixedSearchAppBar(),
        body: _buildSearchResults(),
        bottomNavigationBar: _tabController.index == 1 ? null : const HomeBannerAd(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black,
              floating: true,
              snap: true,
              pinned: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(90.0),
                child: Column(
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    TabBar(
                      controller: _tabController,
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      indicatorPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.redAccent.withAlpha(80), width: 2.0),
                      ),
                      dividerHeight: 0,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white54,
                      labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      onTap: (index) {
                        _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                      },
                      tabs: const [
                        Tab(text: 'Highlights'),
                        Tab(text: 'News'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            _tabController.animateTo(index);
          },
          children: [
            _buildHighlightsPage(),
            const NewsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _tabController.index == 1 ? null : const HomeBannerAd(),
    );
  }

  AppBar _buildFixedSearchAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      elevation: 0,
      title: _buildSearchBar(),
    );
  }

  Widget _buildHighlightsPage() {
    final provider = context.watch<CategoryProvider>();
    final trending = provider.getTrendingMovies();

    return RefreshIndicator(
      onRefresh: () async {
        AnalyticsService.logEvent('home_pull_to_refresh');
        await provider.loadMovies(forceRefresh: true);
        if (mounted) {
          setState(() {
            randomMovies = provider.getRandomMovies(count: 18);
          });
        }
      },
      color: Colors.redAccent,
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildSectionTitle("Latest Highlights"),
          _buildTrendingCarousel(trending),
          _buildSectionTitle("Recommended for You"),
          _buildVerticalList(randomMovies),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final provider = context.read<CategoryProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
      child: Row(
        children: [
          Expanded(
            child: AppSearchBar(
              controller: _searchController,
              currentTabIndex: _tabController.index,
              onChanged: (value) {
                setState(() {
                  query = value;
                  if (value.isNotEmpty) {
                    searchResults = provider.searchMovies(value);
                  }
                });

                if (value.length >= 3 && !_searchEventFired) {
                  _searchEventFired = true;
                  AnalyticsService.logEvent('search_started', params: {'query': value});
                }

                if (value.isEmpty) {
                  _searchEventFired = false;
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              AnalyticsService.logEvent('saved_screen_opened');
              Navigator.push(context, FadePageRoute(page: const SavedScreen()));
            },
            icon: const Icon(LucideIcons.bookmark, size: 23, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return _buildVerticalList(searchResults, isSearch: true);
  }

  Widget _buildVerticalList(List<MovieModel> list, {bool isSearch = false}) {
    if (list.isEmpty) {
      if (isSearch) {
        return const Center(child: Padding(padding: EdgeInsets.only(top: 80), child: AppText("No results found", color: Colors.white70)));
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (_, index) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: VideoCardShimmer(),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: !isSearch,
      physics: isSearch ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        20,
        isSearch ? 10 : 40,
        20,
        isSearch ? 90 : 40,
      ),
      itemCount: list.length,
      itemBuilder: (_, index) {
        final movie = list[index];
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 50),
          child: SlideAnimation(
            verticalOffset: 50,
            child: FadeInAnimation(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: VideoCard(
                  movie: movie,
                  onTap: () {
                    AnalyticsService.logEvent(
                      isSearch ? 'search_result_opened' : 'recommended_video_opened',
                      params: {'title': movie.name},
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerScreen(videoUrl: movie.url, title: movie.name),
                      ),
                    );
                  },
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
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      child: Row(
        children: [
          Container(height: 2, width: 60, color: Colors.redAccent),
          const SizedBox(width: 10),
          AppText(text, color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
        ],
      ),
    );
  }

  Widget _buildTrendingCarousel(List<MovieModel> trending) {
    if (trending.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(height: 178, child: VideoCardShimmer()),
      );
    }

    return CarouselSlider.builder(
      itemCount: trending.length,
      itemBuilder: (context, index, _) {
        final movie = trending[index];
        return VideoCard(
          tag: "Latest",
          movie: movie,
          onTap: () {
            AnalyticsService.logEvent('trending_video_opened', params: {'title': movie.name});
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VideoPlayerScreen(videoUrl: movie.url, title: movie.name)),
            );
          },
        );
      },
      options: CarouselOptions(
        height: 178,
        enlargeCenterPage: true,
        viewportFraction: 0.80,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 900),
      ),
    );
  }
}
