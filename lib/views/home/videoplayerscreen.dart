import 'package:cricket_highlight/provider/categoryprovider.dart';
import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:cricket_highlight/widgets/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with AutomaticKeepAliveClientMixin {
  late YoutubePlayerController _controller;
  bool _isDisposing = false;
  double _playerOpacity = 1.0;
  List randomMovies = [];

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
        hideControls: false,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecommendations();
    });
  }

  @override
  bool get wantKeepAlive => true;

  void _loadRecommendations() {
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    setState(() {
      randomMovies = provider.getRandomMovies(count: 15);
    });
  }

  Future<void> _refreshRecommendations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _loadRecommendations();
  }

  Future<void> _handlePop(BuildContext context) async {
    if (_isDisposing) return;
    _isDisposing = true;

    setState(() => _playerOpacity = 0.0);
    try {
      _controller.pause();
    } catch (_) {}

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      _controller.dispose();
    } catch (_) {}

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    if (!_isDisposing) {
      _controller.dispose();
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedOpacity(
        opacity: _playerOpacity,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: YoutubePlayerBuilder(
          onEnterFullScreen: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]);
          },
          onExitFullScreen: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ]);
          },
          player: YoutubePlayer(
            aspectRatio: 16/9,
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.redAccent,
          ),
          builder: (context, player) {
            if (_controller.value.isFullScreen) {
              return SizedBox.expand(child: player);
            }

            return Column(
              children: [
                // ✅ Top Header
                SafeArea(
                  top: true,
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => _handlePop(context),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 6),
                            const AppText(
                              "Now Playing",
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20,),

                // ✅ YouTube Player with gap fix
                SizedBox(
                      height: MediaQuery.of(context).size.width * 9 / 16,
                      width: double.infinity,
                      child: player,
                    ),



                // ✅ Recommended Section
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(20, 20, 20, 16),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Container(
                                height: 2,
                                width: 80,
                                color: Colors.redAccent,
                              ),
                              const AppText(
                                "Recommended For You",
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w100,
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: _refreshRecommendations,
                            color: Colors.redAccent,
                            backgroundColor: Colors.black,
                            strokeWidth: 2.5,
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              itemCount: randomMovies.length,
                              separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final movie = randomMovies[index];
                                return VideoCard(
                                  movie: movie,
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                        const Duration(milliseconds: 300),
                                        pageBuilder: (_, __, ___) =>
                                            VideoPlayerScreen(
                                              videoUrl: movie.url,
                                            ),
                                        transitionsBuilder:
                                            (_, animation, __, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
