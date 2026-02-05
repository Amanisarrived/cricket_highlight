import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/ball_event.dart';
import '../model/batsmen.dart';
import '../model/match_format.dart';
import '../model/match_status.dart';
import '../utils/utils/matc_format_helper.dart';



class MatchEngine {
  final FormatRules rules;

  List<BallEvent> team1Balls = [];
  List<BallEvent> team2Balls = [];

  bool isTeam1Batting = true;
  MatchStatus status = MatchStatus.upcoming;
  bool isFirstInningsOver = false;

  MatchEngine(this.rules);

  factory MatchEngine.fromBackendFormat({
    required String backendFormat,
    required String battingTeam,
    bool isListEmpty = false,
    List<String>? team1BallsEngine,
    List<String>? team2BallsEngine,
    bool isFirstInningsOver = false,
  }) {
    MatchFormat matchFormat = parseFormat(backendFormat);
    FormatRules rules = getRules(matchFormat);
    MatchEngine engine = MatchEngine(rules);

    if (!isListEmpty) {
      if (team1BallsEngine != null) {
        engine.team1Balls =
            team1BallsEngine.map((s) => BallEvent.fromString(s)).toList();
      }
      if (team2BallsEngine != null) {
        engine.team2Balls =
            team2BallsEngine.map((s) => BallEvent.fromString(s)).toList();
      }
    } else {
      FirebaseFirestore.instance
          .collection('featured_match')
          .doc('current')
          .update({
        'team1BallsEngine': [],
        'team2BallsEngine': [],
        'isFirstInningsOver': false,
        'battingTeam': battingTeam,
      });

      engine.team1Balls = [];
      engine.team2Balls = [];
    }

    engine.isTeam1Batting = battingTeam == "team1";
    engine.status = MatchStatus.upcoming;
    engine.isFirstInningsOver = isFirstInningsOver;
    return engine;
  }

  void addBall(BallEvent ball) {
    final currentBalls = isTeam1Batting ? team1Balls : team2Balls;
    currentBalls.add(ball);

    if (status == MatchStatus.upcoming) status = MatchStatus.live;

    FirebaseFirestore.instance
        .collection('featured_match')
        .doc('current')
        .update({
      isTeam1Batting
          ? 'team1BallsEngine'
          : 'team2BallsEngine': currentBalls.map((e) => e.toString()).toList(),
    });
  }

  int totalRuns(List<BallEvent> balls) {
    return balls.fold(0, (sum, b) {
      switch (b.type) {
        case BallType.run:
        case BallType.wicket:
          return sum + b.runs;
        case BallType.wide:
        case BallType.noBall:
          return sum + 1 + b.runs;
      }
    });
  }

  int totalWickets(List<BallEvent> balls) {
    return balls.where((b) => b.type == BallType.wicket).length;
  }

  String overs(List<BallEvent> balls) {
    int legalBalls = balls
        .where((b) => b.type != BallType.wide && b.type != BallType.noBall)
        .length;
    return "${legalBalls ~/ 6}.${legalBalls % 6}";
  }

  double runRate(List<BallEvent> balls) {
    int legalBalls = balls
        .where((b) => b.type != BallType.wide && b.type != BallType.noBall)
        .length;
    int runs = totalRuns(balls);
    return legalBalls > 0 ? runs * 6 / legalBalls : 0;
  }

  List<String> lastBalls(List<BallEvent> balls) {
    return balls.reversed.take(6).map((b) {
      switch (b.type) {
        case BallType.wicket:
          return "W";
        case BallType.wide:
          return b.runs > 0 ? "WD${b.runs}" : "WD";
        case BallType.noBall:
          return b.runs > 0 ? "NB${b.runs}" : "NB";
        case BallType.run:
          return b.runs.toString();
      }
    }).toList().reversed.toList();
  }

  Map<String, dynamic> currentBattingStats() {
    final balls = isTeam1Batting ? team1Balls : team2Balls;
    return {
      "runs": totalRuns(balls),
      "wickets": totalWickets(balls),
      "overs": overs(balls),
      "runRate": runRate(balls),
      "lastBalls": lastBalls(balls),
    };
  }

  Map<String, dynamic> fullScore() {
    return {
      "team1": {
        "runs": totalRuns(team1Balls),
        "wickets": totalWickets(team1Balls),
        "overs": overs(team1Balls),
        "runRate": runRate(team1Balls),
        "lastBalls": lastBalls(team1Balls),
      },
      "team2": {
        "runs": totalRuns(team2Balls),
        "wickets": totalWickets(team2Balls),
        "overs": overs(team2Balls),
        "runRate": runRate(team2Balls),
        "lastBalls": lastBalls(team2Balls),
      },
      "battingTeam": isTeam1Batting ? "team1" : "team2",
      "status": status.toString().split('.').last,
    };
  }

  List<String> ballsForUI() {
    return isTeam1Batting
        ? team1Balls.map(_ballToString).toList()
        : team2Balls.map(_ballToString).toList();
  }

  String _ballToString(BallEvent b) {
    switch (b.type) {
      case BallType.wicket:
        return "W";
      case BallType.wide:
        return b.runs > 0 ? "WD${b.runs}" : "WD";
      case BallType.noBall:
        return b.runs > 0 ? "NB${b.runs}" : "NB";
      case BallType.run:
        return b.runs.toString();
    }
  }

  // ========================
  // Build ScoreCard function
  // ========================
  List<Batsman> buildScoreCard(List<String> players, List<BallEvent> balls) {
    List<Batsman> batsmen = players.map((p) => Batsman(name: p)).toList();

    int strikerIndex = 0;
    int nonStrikerIndex = 1;
    int nextPlayerIndex = 2;

    for (final ball in balls) {
      final striker = batsmen[strikerIndex];

      switch (ball.type) {
        case BallType.run:
          striker.runs += ball.runs;
          striker.balls += 1;
          if (ball.runs == 4) striker.fours++;
          if (ball.runs == 6) striker.sixes++;
          if (ball.runs % 2 == 1) {
            final temp = strikerIndex;
            strikerIndex = nonStrikerIndex;
            nonStrikerIndex = temp;
          }
          break;

        case BallType.wicket:
          striker.isOut = true;
          striker.balls += 1;
          if (nextPlayerIndex < batsmen.length) {
            strikerIndex = nextPlayerIndex;
            nextPlayerIndex++;
          }
          break;

        case BallType.wide:
        case BallType.noBall:
        // legal ball nahi count hota
          break;
      }
    }

    return batsmen;
  }
}
