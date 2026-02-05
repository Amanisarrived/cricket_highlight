import 'package:flutter/material.dart';
import 'reel_card_shimmer.dart';

class ShortsShimmerRow extends StatelessWidget {
  const ShortsShimmerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const ReelCardShimmer(),
              ),
            ),
          );
        },
      ),
    );
  }
}
