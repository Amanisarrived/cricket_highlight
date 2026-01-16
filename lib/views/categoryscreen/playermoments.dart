import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:cricket_highlight/widgets/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../../provider/categoryprovider.dart';
import '../home/videoplayerscreen.dart';

class PlayerMoment extends StatefulWidget {
  const PlayerMoment({super.key});

  @override
  State<PlayerMoment> createState() => _PlayerMomentState();
}

class _PlayerMomentState extends State<PlayerMoment> {
  bool _hasLoadedOnce = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoadedOnce) {
      Provider.of<CategoryProvider>(
        context,
        listen: false,
      ).loadMovies(forceRefresh: false);
      _hasLoadedOnce = true;
    }
  }

  Future<void> _reloadData() async {
    await Provider.of<CategoryProvider>(
      context,
      listen: false,
    ).loadMovies(forceRefresh: true);
  }

  bool get _isAtTop =>
      !_scrollController.hasClients || _scrollController.offset <= 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    final twenty = provider.getMoviesByCategoryId(42).reversed.toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const AppText(
          "Best PLayer Moments",
          fontSize: 25,
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (_isAtTop) await _reloadData();
        },
        color: Colors.redAccent,
        backgroundColor: Colors.black,
        strokeWidth: 2.5,
        displacement: 30,
        child: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.redAccent),
              )
            : twenty.isEmpty
            ? const Center(
                child: AppText(
                  "No Highlights found.",
                  color: Colors.white70,
                  fontSize: 14,
                ),
              )
            : AnimationLimiter(
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 50),
                  itemCount: twenty.length,
                  itemBuilder: (context, index) {
                    final movie = twenty[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        horizontalOffset: (index % 2 == 0)
                            ? 50.0
                            : -50.0, // Alternate
                        child: FadeInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
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
              ),
      ),
    );
  }
}
