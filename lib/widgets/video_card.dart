import 'package:cricket_highlight/model/hive_movie_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../model/moviemodel.dart';
import '../provider/saved_video_provider.dart';

class VideoCard extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback onTap;

  const VideoCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  // Extract YouTube video ID from the URL
  String extractVideoId(String url) {
    final RegExp regExp = RegExp(
      r'(?:v=|\/)([0-9A-Za-z_-]{11}).*',
      caseSensitive: false,
      multiLine: false,
    );
    final match = regExp.firstMatch(url);
    return match != null ? match.group(1)! : '';
  }

  @override
  Widget build(BuildContext context) {
    final savedProvider = context.watch<SavedVideosProvider>();
    final isSaved = savedProvider.isSaved(movie.id);

    final videoId = extractVideoId(movie.url);
    final thumbnailUrl = videoId.isNotEmpty
        ? "https://img.youtube.com/vi/$videoId/hqdefault.jpg"
        : "https://via.placeholder.com/480x360.png?text=No+Thumbnail";

    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // ✅ Video Thumbnail
              Positioned.fill(
                child: Image.network(
                  height: 800,
                  thumbnailUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.grey.shade900,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.redAccent,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade700,
                    child: const Icon(
                      Icons.videocam_off,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),

              // ✅ Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // ✅ Save button (top right)
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    await savedProvider.toggleSave(HiveMovieModel.fromMovie(movie));

                    // Optional feedback (vibration or snackbar)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.black.withOpacity(0.9),
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.redAccent, width: 1),
                        ),
                        content: Row(
                          children: [
                            Icon(
                              isSaved ? Icons.favorite_border : Icons.favorite,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              isSaved ? 'Removed from Saved' : 'Added to Saved',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );

                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: isSaved
                          ? [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ]
                          : [],
                    ),
                    child: Icon(
                      isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isSaved ? Colors.redAccent : Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),

              // ✅ Title text (bottom)
              Positioned(
                bottom: 20,
                left: 12,
                right: 12,
                child: Text(
                  movie.name,
                  style: GoogleFonts.bebasNeue(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    shadows: const [
                      Shadow(
                        color: Colors.black87,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
