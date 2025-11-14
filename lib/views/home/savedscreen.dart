import 'package:cricket_highlight/model/hive_movie_model.dart';
import 'package:cricket_highlight/provider/saved_video_provider.dart';
import 'package:cricket_highlight/views/home/videoplayerscreen.dart';
import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:cricket_highlight/widgets/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedVideos();
  }

  Future<void> _loadSavedVideos() async {
    final provider = Provider.of<SavedVideosProvider>(context, listen: false);
    await provider.init();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final savedProvider = context.watch<SavedVideosProvider>();
    final List<HiveMovieModel> savedVideos = savedProvider.savedVideos;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const AppText(
          "Saved Videos",
          fontSize: 25,
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.redAccent),
      )
          : savedVideos.isEmpty
          ? const Center(
        child: AppText(
          "No saved videos yet.",
          color: Colors.white70,
          fontSize: 14,
        ),
      )
          : AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 50),
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          itemCount: savedVideos.length,
          itemBuilder: (context, index) {
            final movie = savedVideos[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 400),
              child: SlideAnimation(
                horizontalOffset:
                (index % 2 == 0) ? 50.0 : -50.0, // alternate slide
                child: FadeInAnimation(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: VideoCard(
                      movie: movie.toMovieModel(),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoPlayerScreen(
                              videoUrl: movie.url,
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
    );
  }
}
