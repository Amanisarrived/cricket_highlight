import 'package:flutter/material.dart';
import '../model/moviemodel.dart';

class ReelCard extends StatelessWidget {
  final MovieModel movie;
  final Widget playerWidget;

  const ReelCard({
    super.key,
    required this.movie,
    required this.playerWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: playerWidget),

        Positioned(
          left: 16,
          right: 16,
          bottom: 40,
          child: Text(
            movie.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(blurRadius: 6, color: Colors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
