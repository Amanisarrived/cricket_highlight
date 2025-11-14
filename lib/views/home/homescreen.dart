import 'package:carousel_slider/carousel_slider.dart';
import 'package:cricket_highlight/provider/categoryprovider.dart';
import 'package:cricket_highlight/views/home/videoplayerscreen.dart';
import 'package:cricket_highlight/widgets/app_search_bar.dart';
import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:cricket_highlight/widgets/video_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../widgets/adwidget/homebannerad.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  List randomMovies = [];
  List searchResults = [];
  String query = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<CategoryProvider>(context, listen: false);

      // Load data if stale (30 mins rule)
      if (provider.isMoviesStale) {
        await provider.loadMovies(forceRefresh: true);
      }

      _loadRecommendations(provider);
    });
  }

  void _loadRecommendations(CategoryProvider provider) {
    setState(() {
      randomMovies = provider.getRandomMovies(count: 12);
    });
  }

  Future<void> _refreshHome() async {
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    await provider.loadMovies(forceRefresh: true);
    _loadRecommendations(provider);
  }

  void _onSearchChanged(String value, CategoryProvider provider) {
    setState(() {
      query = value;
      searchResults = provider.searchMovies(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    final trendingMovies = provider.getTrendingMovies();
    final bool isSearching = query.isNotEmpty;

    // Show loading spinner if data is being fetched and empty
    if (provider.isLoading && trendingMovies.isEmpty && randomMovies.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black12,
        body: Center(
          child: CircularProgressIndicator(color: Colors.redAccent),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const AppText(
          "CricHighlights Hub",
          fontSize: 25,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshHome,
        color: Colors.redAccent,
        backgroundColor: Colors.black,
        displacement: 30,
        strokeWidth: 2.5,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔍 Search bar
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: AppSearchBar(
                  controller: _searchController,
                  onChanged: (value) => _onSearchChanged(value, provider),
                  hintText: "Search Highlights...",
                ),
              ),

              const SizedBox(height: 5,),
              if (isSearching) ...[
                // 🎯 Search Results
               const Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: AppText(
                    "Search Results",
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                searchResults.isEmpty
                    ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: AppText(
                      "No results found",
                      color: Colors.white70,
                    ),
                  ),
                )
                    : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final movie = searchResults[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: VideoCard(
                        movie: movie,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  VideoPlayerScreen(videoUrl: movie.url),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ] else ...[
                // 🔥 Trending Section
                _buildTrendingSection(provider, trendingMovies),

                // 🎯 Recommendations
                _buildRecommendationsSection(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingSection(
      CategoryProvider provider, List trendingMovies) {
    if (provider.isLoading && trendingMovies.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: CircularProgressIndicator(color: Colors.redAccent),
        ),
      );
    }

    if (trendingMovies.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: AppText("No trending videos found", color: Colors.white70),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Container(height: 2, width: 80, color: Colors.redAccent),
              const AppText(
                "Latest Highlights",
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w100,
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 200,
          child: CarouselSlider.builder(
            itemCount: trendingMovies.length,
            itemBuilder: (context, index, realIndex) {
              final movie = trendingMovies[index];
              return VideoCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoPlayerScreen(videoUrl: movie.url),
                    ),
                  );
                },
                movie: movie,
              );
            },
            options: CarouselOptions(
              height: 400,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
              viewportFraction: 0.85,
              padEnds: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection() {
    final provider = context.watch<CategoryProvider>();

    if (provider.isLoading && randomMovies.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: CircularProgressIndicator(color: Colors.redAccent),
        ),
      );
    }

    if (randomMovies.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Center(
          child: AppText("No recommendations found", color: Colors.white70),
        ),
      );
    }

    // Calculate total items including ads
    int totalItems = randomMovies.length + (randomMovies.length ~/ 5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Container(height: 2, width: 80, color: Colors.redAccent),
              const AppText(
                "Recommended For You",
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w100,
              ),
            ],
          ),
        ),
        AnimationLimiter(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: totalItems,
            itemBuilder: (context, index) {
              // Every 5th item: show ad
              if ((index + 1) % 6 == 0) { // index 5, 11, 17 ...
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: HomeBannerAd(),
                );
              }

              // Adjust index to get the correct movie
              int movieIndex = index - (index ~/ 6);
              final movie = randomMovies[movieIndex];

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                      child: VideoCard(
                        movie: movie,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  VideoPlayerScreen(videoUrl: movie.url),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

}
