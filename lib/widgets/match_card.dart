import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/upcoming_fixture_model.dart';
import 'apptext.dart';

class MatchCard extends StatelessWidget {
  final UpcomingFixtureModel match;

  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final isCompleted = match.winningTeam.isNotEmpty;

    final date = match.time.toDate();
    final formattedTime = DateFormat("d MMM yy HH:mm").format(date);

    return Container(
      width: 190,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: isCompleted
            ? const LinearGradient(
          colors: [
            Color(0x842A0A0A),
            Color(0xFF0F0F0F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : const LinearGradient(
          colors: [
            Color(0xFF000000),
            Color(0xFF1A1A1A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? Colors.redAccent.withOpacity(0.5)
              : Colors.white12,
        ),
        boxShadow: isCompleted
            ? [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 1,
          )
        ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tournament
          AppText(
            match.tournament,
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(height: 14),

          // Teams row with names
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _teamBlock(match.team1Logo, match.team1),
              const AppText(
                "VS",
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              _teamBlock(match.team2Logo, match.team2),
            ],
          ),

          const Spacer(),

          // Time / Winner
          AppText(
            isCompleted
                ? "Winner: ${match.winningTeam}"
                : formattedTime,
            color: isCompleted
                ? Colors.redAccent
                : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),

          const SizedBox(height: 4),

          // Venue
          AppText(
            match.venue,
            color: Colors.white38,
            fontSize: 11,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _teamBlock(String logoUrl, String name) {
    return Column(
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white10,
          ),
          child: ClipOval(
            child: Image.network(
              logoUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.sports_cricket,
                color: Colors.white54,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        AppText(
          name,
          color: Colors.white70,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
