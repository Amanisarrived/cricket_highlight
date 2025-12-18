import 'package:carousel_slider/carousel_slider.dart';
import 'package:cricket_highlight/provider/categoryprovider.dart';
import 'package:cricket_highlight/utils/fadenavigation.dart';
import 'package:cricket_highlight/views/home/savedscreen.dart';
import 'package:cricket_highlight/views/home/videoplayerscreen.dart';
import 'package:cricket_highlight/widgets/app_search_bar.dart';
import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:cricket_highlight/widgets/video_card.dart';
import 'package:cricket_highlight/widgets/adwidget/homebannerad.dart';
import 'package:cricket_highlight/widgets/adwidget/openadservcie.dart'; // ← APP OPEN AD SERVICE
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../model/moviemodel.dart';
import '../../widgets/shimmerbox.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MovieModel> randomMovies = [];
  List<MovieModel> searchResults = [];
  String query = "";

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AppOpenAdService().loadAd();

      Future.delayed(const Duration(milliseconds: 800), () {
        AppOpenAdService().showAdIfAvailable(onComplete: () {});
      });

      // Load home screen movies
      final provider = context.read<CategoryProvider>();

      if (provider.isMoviesStale) {
        await provider.loadMovies(forceRefresh: true);
      }

      setState(() {
        randomMovies = provider.getRandomMovies(count: 18);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    final trending = provider.getTrendingMovies();
    final isSearching = query.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildTopAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await provider.loadMovies(forceRefresh: true);
          setState(() {
            randomMovies = provider.getRandomMovies(count: 18,);
          });
        },
        color: Colors.redAccent,
        backgroundColor: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(provider),
              if (isSearching)
                _buildSearchResults(provider)
              else ...[
                _buildSectionTitle("Latest Highlights"),
                _buildTrendingCarousel(trending),
                _buildSectionTitle("Recommended for You"),
                _buildVerticalList(randomMovies),
              ],
            ],
          ),
        ),
      ),

      bottomNavigationBar: const HomeBannerAd(),
    );
  }

  AppBar _buildTopAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const AppText(
        "CricHighlights+",
        fontSize: 25,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () {
              Navigator.push(context,FadePageRoute(page: const SavedScreen()));
            },
            icon: const Icon(
              LucideIcons.bookmark,
              size: 28,
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(CategoryProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: AppSearchBar(
        controller: _searchController,
        hintText: "Search Highlights...",
        onChanged: (value) {
          setState(() {
            query = value;
            searchResults = provider.searchMovies(value);
          });
        },
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      child: Row(
        children: [
          Container(height: 2, width: 60, color: Colors.redAccent),
          const SizedBox(width: 10),
          AppText(
            text,
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    VideoPlayerScreen(videoUrl: movie.url, title: movie.name),
              ),
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

  Widget _buildSearchResults(CategoryProvider provider) {
    if (searchResults.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 80),
        child: Center(
          child: AppText("No results found", color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: searchResults.length,
      itemBuilder: (_, i) {
        final movie = searchResults[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: VideoCard(
            movie: movie,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      VideoPlayerScreen(videoUrl: movie.url, title: movie.name),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildVerticalList(List<MovieModel> list) {
    if (list.isEmpty) {
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

    return AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (_, index) {
          final movie = list[index];

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 400),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: VideoCard(
                    movie: movie,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoPlayerScreen(
                            videoUrl: movie.url,
                            title: movie.name,
                          ),
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
    );
  }
}
