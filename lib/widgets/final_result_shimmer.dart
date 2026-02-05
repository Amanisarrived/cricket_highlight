import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FinalResultCardShimmer extends StatelessWidget {
  const FinalResultCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.white12,
        highlightColor: Colors.white24,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // STATUS + DATE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 60, height: 20, color: Colors.white12),
                  Container(width: 80, height: 14, color: Colors.white12),
                ],
              ),
              const SizedBox(height: 6),

              /// MATCH TITLE
              Container(width: 150, height: 16, color: Colors.white12),
              const SizedBox(height: 2),

              /// SERIES
              Container(width: 80, height: 12, color: Colors.white12),
              const SizedBox(height: 2),

              /// VENUE
              Container(width: 100, height: 10, color: Colors.white12),
              const SizedBox(height: 15),

              /// TEAMS ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _teamShimmer(),
                  _vsShimmer(),
                  _teamShimmer(),
                ],
              ),
              const SizedBox(height: 10),

              /// TOSS
              Container(width: 60, height: 12, color: Colors.white12),
              const SizedBox(height: 10),

              /// RESULT
              Container(width: 80, height: 12, color: Colors.white12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _teamShimmer() {
    return Column(
      children: [
        Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(22))),
        const SizedBox(height: 6),
        Container(width: 40, height: 12, color: Colors.white12),
        const SizedBox(height: 4),
        Container(width: 30, height: 12, color: Colors.white12),
        const SizedBox(height: 2),
        Container(width: 20, height: 10, color: Colors.white12),
      ],
    );
  }

  Widget _vsShimmer() {
    return Container(width: 20, height: 12, color: Colors.white12);
  }
}
