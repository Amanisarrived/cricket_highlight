import 'package:flutter/material.dart';

class MiniScoreCardLive extends StatelessWidget {
  final String team1, team2, team1Logo, team2Logo, team1Overs, team2Overs, team1RR, team2RR;
  final int team1Runs, team1Wickets, team2Runs, team2Wickets;

  const MiniScoreCardLive({
    super.key,
    required this.team1,
    required this.team2,
    required this.team1Logo,
    required this.team2Logo,
    required this.team1Runs,
    required this.team1Wickets,
    required this.team2Runs,
    required this.team2Wickets,
    required this.team1Overs,
    required this.team2Overs,
    required this.team1RR,
    required this.team2RR,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.redAccent.withAlpha(50)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _teamColumn(team1, team1Logo, team1Runs, team1Wickets, team1Overs, team1RR),
          const Text("VS", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
          _teamColumn(team2, team2Logo, team2Runs, team2Wickets, team2Overs, team2RR),
        ],
      ),
    );
  }

  Widget _teamColumn(String team, String logo, int runs, int wickets, String overs, String rr) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: logo.isNotEmpty
              ? Image.network(logo, width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholderLogo())
              : _placeholderLogo(),
        ),
        const SizedBox(height: 4),
        Text(team, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        Text("$runs/$wickets", style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
        Text(overs, style: const TextStyle(color: Colors.white38, fontSize: 10)),
        Text("RR: $rr", style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _placeholderLogo() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.sports_cricket, color: Colors.white24, size: 20),
    );
  }
}