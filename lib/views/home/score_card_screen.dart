import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/ball_event.dart';
import '../../model/batsmen.dart';
import '../../widgets/match_engine.dart';
import '../../model/featured_match_model.dart';
import '../../widgets/mini_score_card.dart';

class ScoreCardScreen extends StatefulWidget {
  final MatchEngine matchEngine;
  final List<String> team1Players;
  final List<String> team2Players;
  final FeaturedMatchModel? matchModel;

  const ScoreCardScreen({
    super.key,
    required this.matchEngine,
    required this.team1Players,
    required this.team2Players,
    this.matchModel,
  });

  @override
  State<ScoreCardScreen> createState() => _ScoreCardScreenState();
}

class _ScoreCardScreenState extends State<ScoreCardScreen> {
  late List<Batsman> team1Batsmen;
  late List<Batsman> team2Batsmen;

  @override
  void initState() {
    super.initState();
    team1Batsmen =
        widget.team1Players.map((e) => Batsman(name: e)).toList();
    team2Batsmen =
        widget.team2Players.map((e) => Batsman(name: e)).toList();
  }

  void _updateBatsmenStats(
      List<BallEvent> team1Balls,
      List<BallEvent> team2Balls) {
    team1Batsmen =
        widget.matchEngine.buildScoreCard(widget.team1Players, team1Balls);
    team2Batsmen =
        widget.matchEngine.buildScoreCard(widget.team2Players, team2Balls);

    void updateStrike(List<Batsman> batsmen, List<BallEvent> balls) {
      if (balls.isEmpty || batsmen.length < 2) return;

      int strikerPos = 0;
      int nonStrikerPos = 1;
      int nextBatsmanPos = 2;

      for (int i = 0; i < balls.length; i++) {
        final ball = balls[i];

        if (ball.type == BallType.wicket) {
          batsmen[strikerPos].isOut = true;
          if (nextBatsmanPos < batsmen.length) {
            strikerPos = nextBatsmanPos;
            nextBatsmanPos++;
          }
        } else {
          if (ball.runs % 2 == 1) {
            final temp = strikerPos;
            strikerPos = nonStrikerPos;
            nonStrikerPos = temp;
          }
        }

        if ((i + 1) % 6 == 0) {
          final temp = strikerPos;
          strikerPos = nonStrikerPos;
          nonStrikerPos = temp;
        }
      }

      final striker = batsmen[strikerPos];
      final nonStriker = batsmen[nonStrikerPos];

      batsmen.remove(striker);
      batsmen.remove(nonStriker);

      batsmen.insert(0, striker);
      batsmen.insert(1, nonStriker);
    }

    updateStrike(team1Batsmen, team1Balls);
    updateStrike(team2Batsmen, team2Balls);
  }

  Widget _batsmanRow(Batsman batsman, int index) {
    final isStriker = index == 0;
    final name = isStriker ? "${batsman.name} *" : batsman.name;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(name, style: const TextStyle(color: Colors.white))),
          Expanded(child: Center(child: Text("${batsman.runs}", style: const TextStyle(color: Colors.white)))),
          Expanded(child: Center(child: Text("${batsman.balls}", style: const TextStyle(color: Colors.white)))),
          Expanded(child: Center(child: Text("${batsman.fours}", style: const TextStyle(color: Colors.white)))),
          Expanded(child: Center(child: Text("${batsman.sixes}", style: const TextStyle(color: Colors.white)))),
          Expanded(child: Center(child: Text(batsman.strikeRate.toStringAsFixed(1), style: const TextStyle(color: Colors.white)))),
        ],
      ),
    );
  }

  Widget _scoreTable(String teamName, List<Batsman> batsmen) {
    final visibleBatsmen = batsmen.take(2).toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(teamName,
              style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 6),
          const Row(
            children: [
              Expanded(flex: 4, child: Text("Batsman", style: TextStyle(color: Colors.white38))),
              Expanded(child: Center(child: Text("R", style: TextStyle(color: Colors.white38)))),
              Expanded(child: Center(child: Text("B", style: TextStyle(color: Colors.white38)))),
              Expanded(child: Center(child: Text("4s", style: TextStyle(color: Colors.white38)))),
              Expanded(child: Center(child: Text("6s", style: TextStyle(color: Colors.white38)))),
              Expanded(child: Center(child: Text("SR", style: TextStyle(color: Colors.white38)))),
            ],
          ),
          const Divider(color: Colors.white12),
          ...visibleBatsmen
              .asMap()
              .entries
              .map((e) => _batsmanRow(e.value, e.key)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('featured_match')
          .doc('current')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final battingTeam = data['battingTeam'];

        final team1Balls =
            (data['team1BallsEngine'] as List<dynamic>?)
                ?.map((e) => BallEvent.fromString(e.toString()))
                .toList() ?? [];

        final team2Balls =
            (data['team2BallsEngine'] as List<dynamic>?)
                ?.map((e) => BallEvent.fromString(e.toString()))
                .toList() ?? [];

        _updateBatsmenStats(team1Balls, team2Balls);

        final isTeam1Batting = battingTeam == "team1";

        final activeBatsmen =
        isTeam1Batting ? team1Batsmen : team2Batsmen;

        final activeTeamName = isTeam1Batting
            ? widget.matchModel?.team1 ?? "Team 1"
            : widget.matchModel?.team2 ?? "Team 2";

        final team1Runs = widget.matchEngine.totalRuns(team1Balls);
        final team1Wickets = min(widget.matchEngine.totalWickets(team1Balls), 10);
        final team1Overs = widget.matchEngine.overs(team1Balls);
        final team1RR =
        widget.matchEngine.runRate(team1Balls).toStringAsFixed(1);

        final team2Runs = widget.matchEngine.totalRuns(team2Balls);
        final team2Wickets = min(widget.matchEngine.totalWickets(team2Balls), 10);
        final team2Overs = widget.matchEngine.overs(team2Balls);
        final team2RR =
        widget.matchEngine.runRate(team2Balls).toStringAsFixed(1);

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            title: const Text("Score Card"),
            backgroundColor: const Color(0xFF1E1E1E),
          ),
          body: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              if (widget.matchModel != null)
                MiniScoreCardLive(
                  team1: widget.matchModel!.team1,
                  team2: widget.matchModel!.team2,
                  team1Logo: widget.matchModel!.team1Logo,
                  team2Logo: widget.matchModel!.team2Logo,
                  team1Runs: team1Runs,
                  team1Wickets: team1Wickets,
                  team2Runs: team2Runs,
                  team2Wickets: team2Wickets,
                  team1Overs: team1Overs,
                  team2Overs: team2Overs,
                  team1RR: team1RR,
                  team2RR: team2RR,
                ),

              // 👇 Sirf batting team ka detailed card
              _scoreTable(activeTeamName, activeBatsmen),
            ],
          ),
        );
      },
    );
  }
}
