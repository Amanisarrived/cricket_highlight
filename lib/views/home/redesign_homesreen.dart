import 'package:cricket_highlight/provider/categoryprovider.dart';
import 'package:cricket_highlight/provider/search_provider.dart';
import 'package:cricket_highlight/views/home/savedscreen.dart';
import 'package:cricket_highlight/widgets/app_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../service/analytics_service.dart';
import '../../widgets/apptext.dart';
import '../../widgets/final_reslt_card.dart';
import '../../service/feature_match_service.dart';
import '../../model/featured_match_model.dart';
import '../../widgets/final_result_shimmer.dart';
import '../../widgets/for_you_screen.dart';
import '../../widgets/renews_screen.dart';
import '../../widgets/short_shimmer_row.dart';
import '../../widgets/support_us.dart';
import '../../widgets/tournament_details.dart';
import '../../widgets/trending_screen.dart';
import '../../provider/reel_provider.dart';
import '../../model/moviemodel.dart';
import '../../widgets/shorts_card.dart';
import '../home/shortsscreen.dart';
import '../../service/app_visit_service.dart';
// import '../../widgets/tournament_details.dart'; // 👈 NEW IMPORT

class RedesignHomescreen extends StatefulWidget {
  const RedesignHomescreen({super.key});

  @override
  State<RedesignHomescreen> createState() => _RedesignHomescreenState();
}

class _RedesignHomescreenState extends State<RedesignHomescreen> {
  int selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _showFab = false;

  final FeatureMatchService _featureMatchService = FeatureMatchService();
  late final Stream<FeaturedMatchModel?> _featuredMatchStream;

  final List<Map<String, dynamic>> tabs = [
    {"title": "For You", "icon": LucideIcons.home},
    {"title": "Latest", "icon": LucideIcons.trendingUp},
    {"title": "News", "icon": LucideIcons.newspaper},
  ];

  bool _loaded = false;
  bool _visitChecked = false;

  @override
  void initState() {
    super.initState();

    AnalyticsService.logScreen('RedesignHomescreen');
    _featuredMatchStream = _featureMatchService.streamFeaturedMatch();

    Future.microtask(() {
      context.read<CategoryProvider>().loadMovies();
    });

    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showFab) {
        setState(() => _showFab = true);
      } else if (_scrollController.offset <= 300 && _showFab) {
        setState(() => _showFab = false);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_loaded) {
      _loaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final reelsProvider = context.read<ReelsProvider>();
        final catProvider = context.read<CategoryProvider>();
        if (reelsProvider.visibleReels.isEmpty) {
          reelsProvider.initReels(catProvider);
        }
      });
    }

    if (!_visitChecked) {
      _visitChecked = true;
      _checkVisits();
    }
  }

  void _checkVisits() async {
    final count = await AppVisitService.incrementAndGet();
    debugPrint("User visit count: $count");
    if (!mounted) return;

    if (count == 3 || count % 5 == 0) {
      SupportUsDialog.show(context);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  Widget _getTabBody(
      List<MovieModel> allMovies,
      List<MovieModel> searchResults,
      String query,
      ) {
    if (query.isNotEmpty && selectedIndex != 2) {
      return searchResults.isEmpty
          ? const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "No results found",
          style: TextStyle(color: Colors.white54),
        ),
      )
          : Column(
        children: searchResults
            .map(
              (movie) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: TrendingShortCard(
              videoUrl: movie.url,
              title: movie.name,
              onTap: () {},
            ),
          ),
        )
            .toList(),
      );
    }

    switch (selectedIndex) {
      case 0:
        return const ForYouScreen();
      case 1:
        return const TrendingScreen();
      case 2:
        return const ReNewsScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildShortsSection(List<MovieModel> reels) {
    final display = reels.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _buildSectionTitle('Cricket Shorts'),
        ),
        const SizedBox(height: 25),
        display.isEmpty
            ? const ShortsShimmerRow()
            : SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: display.length,
            itemBuilder: (context, index) {
              final reel = display[index];
              return TrendingShortCard(
                videoUrl: reel.url,
                title: reel.name,
                onTap: () {
                  final reelsProvider =
                  context.read<ReelsProvider>();
                  reelsProvider.setStartReel(reel);

                  AnalyticsService.logEvent(
                    'short_open',
                    params: {
                      'short_title': reel.name,
                      'video_url': reel.url,
                    },
                  );

                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                      const ReelsScreen(),
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
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: List.generate(tabs.length, (index) {
          bool isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => selectedIndex = index);
                AnalyticsService.logEvent(
                  'home_tab_click',
                  params: {
                    'tab_name': tabs[index]["title"],
                    'tab_index': index,
                  },
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 38,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.redAccent.withAlpha(30)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Colors.redAccent : Colors.grey,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tabs[index]["icon"],
                      color: isSelected
                          ? Colors.white
                          : Colors.grey[500],
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tabs[index]["title"],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.grey[500],
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final searchProvider = context.watch<SearchProvider>();

    return Consumer<ReelsProvider>(
      builder: (context, reelsProvider, _) {
        final reels = reelsProvider.getOrderedReels();

        return Scaffold(
          backgroundColor: Colors.black,
          floatingActionButton: _showFab
              ? FloatingActionButton(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(
                color: Colors.redAccent,
                width: 2,
              ),
            ),
            onPressed: _scrollToTop,
            child: const Icon(
              Icons.arrow_upward,
              color: Colors.white,
            ),
          )
              : null,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 70,
            title: Row(
              children: [
                Text("CrickView",
                    style:
                    GoogleFonts.bebasNeue(color: Colors.white)),
                const SizedBox(width: 5),
                Image.asset("assets/images/logo.png", height: 25),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SavedScreen()),
                  );
                },
                icon: const Icon(
                  LucideIcons.bookmark,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: AppSearchBar(
                      currentTabIndex: selectedIndex),
                ),
              ),
              SliverToBoxAdapter(child: _buildTabs()),

              // Featured match
              if (selectedIndex == 0)
                SliverToBoxAdapter(
                  child: StreamBuilder<FeaturedMatchModel?>(
                    stream: _featuredMatchStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: FinalResultCardShimmer(),
                        );
                      }

                      if (!snapshot.hasData ||
                          snapshot.data == null) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "No Featured Match",
                            style:
                            TextStyle(color: Colors.white54),
                          ),
                        );
                      }

                      final match = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12),
                        child: FinalResultCard(match: match),
                      );
                    },
                  ),
                ),


              if (selectedIndex == 0)
                SliverToBoxAdapter(
                  child: TournamentDetails(),
                ),

              // Shorts
              if (selectedIndex == 0)
                SliverToBoxAdapter(
                  child: _buildShortsSection(reels),
                ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12),
                  child: _getTabBody(
                    categoryProvider.movies,
                    searchProvider.results,
                    searchProvider.query,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildSectionTitle(String text) {
  return Row(
    children: [
      Expanded(
          child:
          Container(height: 2, color: Colors.redAccent)),
      const SizedBox(width: 10),
      AppText(text,
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w400),
      const SizedBox(width: 10),
      Expanded(
          child:
          Container(height: 2, color: Colors.redAccent)),
    ],
  );
}
