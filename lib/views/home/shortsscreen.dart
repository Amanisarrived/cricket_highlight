import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../provider/reel_provider.dart';
import '../../provider/categoryprovider.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();
  final Map<int, YoutubePlayerController> _controllers = {};

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final catProvider = context.read<CategoryProvider>();
      final reelsProvider = context.read<ReelsProvider>();

      if (catProvider.movies.isEmpty) {
        await catProvider.loadMovies();
      }

      await reelsProvider.initReels(catProvider);

      _initController(0);
      _initController(1);
      setState(() {});
    });
  }

  void _initController(int index) {
    final reels = context.read<ReelsProvider>().visibleReels;
    if (index < 0 || index >= reels.length) return;
    if (_controllers.containsKey(index)) return;

    final url = convertShortsToWatchUrl(reels[index].url);
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId == null) return;

    _controllers[index] = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        loop: true,
        hideControls: true,
      ),
    );

    _disposeFar(index);
  }

  void _disposeFar(int index) {
    _controllers.keys
        .where((k) => (k - index).abs() > 1)
        .toList()
        .forEach((k) {
      _controllers[k]?.dispose();
      _controllers.remove(k);
    });
  }

  void _onPageChanged(int index) {
    final provider = context.read<ReelsProvider>();
    provider.loadMoreIfNeeded(index);

    _initController(index);
    _initController(index + 1);

    _controllers.forEach((k, c) {
      k == index ? c.play() : c.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reels = context.watch<ReelsProvider>().visibleReels;

    if (reels.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: reels.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (_, index) {
          final controller = _controllers[index];
          if (controller == null) {
            _initController(index);
            return const Center(child: CircularProgressIndicator());
          }

          return YoutubePlayer(controller: controller);
        },
      ),
    );
  }
}

String convertShortsToWatchUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return '';

  if (uri.path.contains('shorts')) {
    return 'https://www.youtube.com/watch?v=${uri.pathSegments.last}';
  }
  return url;
}
