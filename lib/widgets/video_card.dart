import 'package:cricket_highlight/model/hive_movie_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../model/moviemodel.dart';
import '../provider/saved_video_provider.dart';

class VideoCard extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback onTap;

  /// Optional LATEST tag badge
  final String? tag;

  const VideoCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.tag,
  });

  // Extract YouTube video ID
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
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(77, 0, 0, 0),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Thumbnail
              Positioned.fill(
                child: Image.network(
                  thumbnailUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: const Color(0xFF1A1A1A),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.redAccent,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF444444),
                    child: const Icon(
                      Icons.videocam_off,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),

              // Dark gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromARGB(220, 0, 0, 0),
                        Color.fromARGB(90, 0, 0, 0),
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.45, 1.0],
                    ),
                  ),
                ),
              ),

              // 🔥 Black × Neon Red LATEST tag
              // Premium Minimal Tag Badge
              if (tag != null)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0x66000000), // soft transparent black
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.redAccent.withOpacity(0.4), // subtle red outline
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33FF5252), // extremely soft red glow
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.fiber_manual_record_rounded,
                          size: 8,
                          color: Colors.redAccent.withOpacity(0.8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tag!.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


              // Save button
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    await savedProvider
                        .toggleSave(HiveMovieModel.fromMovie(movie));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color.fromARGB(230, 0, 0, 0),
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                              color: Colors.redAccent, width: 1),
                        ),
                        content: Row(
                          children: [
                            Icon(
                              isSaved
                                  ? Icons.favorite_border
                                  : Icons.favorite,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              isSaved
                                  ? 'Removed from Saved'
                                  : 'Added to Saved',
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
                      color: const Color.fromARGB(120, 0, 0, 0),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: isSaved
                          ? [
                        const BoxShadow(
                          color: Color.fromARGB(128, 255, 82, 82),
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

              // Title Text
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
                        color: Color.fromARGB(200, 0, 0, 0),
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
