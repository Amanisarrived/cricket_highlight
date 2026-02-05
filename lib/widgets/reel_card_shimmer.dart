import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ReelCardShimmer extends StatelessWidget {
  const ReelCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade700,
      child: Stack(
        children: [
          // fake video background
          Positioned.fill(
            child: Container(
              color: Colors.black,
            ),
          ),

          // bottom text shimmer
          Positioned(
            left: 16,
            right: 16,
            bottom: 40,
            child: Container(
              height: 22,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
