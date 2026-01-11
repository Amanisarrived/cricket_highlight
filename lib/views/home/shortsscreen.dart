import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../model/moviemodel.dart';
import '../../provider/categoryprovider.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();
  List<MovieModel> reels = [];
  final Map<int, YoutubePlayerController> _controllers = {};
  int _currentPage = 0;
  bool _dataLoaded = false; // track if screen has loaded data

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = context.read<CategoryProvider>();

      // Agar movies stale ya empty hai → fetch kare
      if (provider.isMoviesStale || provider.movies.isEmpty) {
        await provider.loadMovies();
      }

      _initReels(provider);
    });
  }

  void _initReels(CategoryProvider provider) {
    if (_dataLoaded) return;

    final fetched = provider.getMoviesByCategoryId(45);

    reels = fetched.where((movie) {
      final url = convertShortsToWatchUrl(movie.url);
      if (url.isEmpty) return false;
      movie.url = url;
      return true;
    }).toList();

    // 🔥 Shuffle + Reverse
    reels.shuffle(Random());
    reels = reels.reversed.toList();

    if (reels.isEmpty) return;

    _dataLoaded = true;
    setState(() {});

    _initializeController(0);
  }


  void _initializeController(int index) {
    if (_controllers.containsKey(index)) return;
    final movie = reels[index];
    final videoId = YoutubePlayer.convertUrlToId(movie.url);
    if (videoId == null) return;

    final controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
        hideControls: true,
        disableDragSeek: true,
      ),
    );

    _controllers[index] = controller;

    _disposeFarControllers(index);
  }

  void _disposeFarControllers(int currentIndex) {
    final keys = _controllers.keys.toList();
    for (final k in keys) {
      if ((k - currentIndex).abs() > 1) {
        _controllers[k]?.pause();
        _controllers[k]?.dispose();
        _controllers.remove(k);
      }
    }
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);

    _initializeController(index);
    if (index + 1 < reels.length) _initializeController(index + 1);
    if (index - 1 >= 0) _initializeController(index - 1);

    _controllers.forEach((key, ctrl) {
      if (key == index) {
        if (!ctrl.value.isPlaying && ctrl.value.isReady) ctrl.play();
      } else {
        if (ctrl.value.isPlaying) ctrl.pause();
      }
    });
  }

  @override
  void dispose() {
    _controllers.forEach((_, ctrl) => ctrl.dispose());
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (reels.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: reels.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final movie = reels[index];
          final controller = _controllers[index];

          if (controller == null) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          return YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: false,
            ),
            builder: (context, player) {
              return Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  SizedBox.expand(child: player),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      movie.name,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// ----------------
/// Helper functions
/// ----------------

String convertShortsToWatchUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return '';
  if (uri.host.contains('youtube.com')) {
    if (uri.pathSegments.contains('shorts') && uri.pathSegments.length >= 2) {
      final id = uri.pathSegments[1].split('?')[0];
      return 'https://www.youtube.com/watch?v=$id';
    } else if (uri.queryParameters.containsKey('v')) {
      return url;
    }
  } else if (uri.host.contains('youtu.be')) {
    final id = uri.pathSegments[0];
    return 'https://www.youtube.com/watch?v=$id';
  }
  return '';
}