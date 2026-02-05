import 'package:flutter/material.dart';

class TrendingShortCard extends StatelessWidget {
  final String videoUrl; // 🔹 Ye ab YouTube short ka URL hoga
  final String title;
  final VoidCallback? onTap;

  const TrendingShortCard({
    super.key,
    required this.videoUrl,
    required this.title,
    this.onTap,
  });

  // 🔹 YouTube video ID extract karne ka method
  String getVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return '';

    // Agar shorts link ho
    if (uri.pathSegments.contains('shorts')) {
      return uri.pathSegments.last;
    }

    // Agar normal watch link ho
    final match = RegExp(r'v=([0-9A-Za-z_-]{11})').firstMatch(url);
    return match != null ? match.group(1)! : '';
  }

  // 🔹 Thumbnail URL generator
  String getThumbnailUrl(String url) {
    final videoId = getVideoId(url);
    if (videoId.isEmpty) {
      return "https://via.placeholder.com/480x360.png?text=No+Thumbnail";
    }
    return "https://img.youtube.com/vi/$videoId/hqdefault.jpg";
  }

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = getThumbnailUrl(videoUrl);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 200,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // 🔹 Thumbnail image
              Image.network(
                thumbnailUrl,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.black54,
                  child: const Icon(Icons.videocam_off, color: Colors.white38),
                ),
              ),

              // 🔹 Gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.85),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // 🔹 Play icon
              const Center(
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white70,
                  size: 36,
                ),
              ),

              // 🔹 Title
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
