import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VideoCardShimmer extends StatelessWidget {
  const VideoCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFF2A2A2A),
        highlightColor: const Color(0xFF3A3A3A),
        child: Container(
          height: 195,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              // 🔥 Thumbnail placeholder
              Positioned.fill(child: Container(color: const Color(0xFF2A2A2A))),

              // 🔥 Gradient overlay placeholder
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromARGB(180, 0, 0, 0),
                        Color.fromARGB(40, 0, 0, 0),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // 🔥 Tag placeholder
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  height: 20,
                  width: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3A3A3A),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Positioned(
                bottom: 20,
                left: 12,
                right: 80,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(6),
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
