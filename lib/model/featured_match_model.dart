import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../widgets/match_engine.dart';
import 'ball_event.dart';
import 'match_format.dart';
import 'match_status.dart';

part 'featured_match_model.g.dart';

@HiveType(typeId: 7)
class FeaturedMatchModel extends HiveObject {
  @HiveField(0)
  final String matchTitle;

  @HiveField(1)
  final String series;

  @HiveField(2)
  final String team1;

  @HiveField(3)
  final String team2;

  @HiveField(4)
  final String team1Logo;

  @HiveField(5)
  final String team2Logo;

  @HiveField(6)
  final String score1;

  @HiveField(7)
  final String score2;

  @HiveField(8)
  final String over1;

  @HiveField(9)
  final String over2;

  @HiveField(10)
  final String result;

  @HiveField(11)
  final DateTime? dateTime;

  @HiveField(12)
  final String venue;

  @HiveField(13)
  final MatchStatus status;

  @HiveField(14)
  final String team1RunRate;

  @HiveField(15)
  final String team2RunRate;

  @HiveField(16)
  final String toss;

  @HiveField(17)
  final List<String> lastBalls;

  @HiveField(18)
  final String? matchFormat;

  @HiveField(19)
  final bool isListEmpty;

  @HiveField(20)
  final List<String>? team1BallsEngine;

  @HiveField(21)
  final List<String>? team2BallsEngine;

  @HiveField(22)
  final String tossWinner;

  @HiveField(23)
  final bool isFirstInningsOver;

  @HiveField(24)
  final String battingTeam;

  @HiveField(25)
  final List<String>? team1Player;

  @HiveField(26)
  final List<String>? team2Player;

  late MatchEngine engine;

  FeaturedMatchModel({
    required this.matchTitle,
    required this.series,
    required this.team1,
    required this.team2,
    required this.team1Logo,
    required this.team2Logo,
    required this.score1,
    required this.score2,
    required this.over1,
    required this.over2,
    required this.result,
    this.dateTime,
    required this.venue,
    required this.status,
    required this.team1RunRate,
    required this.team2RunRate,
    required this.toss,
    required this.tossWinner,
    required this.battingTeam,
    required this.lastBalls,
    this.matchFormat,
    this.team1BallsEngine,
    this.team2BallsEngine,
    this.isListEmpty = false,
    this.isFirstInningsOver = false,
    this.team1Player,
    this.team2Player,
  }) {
    int maxOvers;
    int maxInnings;

    switch (matchFormat) {
      case "t20":
        maxOvers = 20;
        maxInnings = 2;
        break;
      case "odi":
        maxOvers = 50;
        maxInnings = 2;
        break;
      case "test":
        maxOvers = 90;
        maxInnings = 1;
        break;
      case "t1":
        maxOvers = 1;
        maxInnings = 2;
        break;
      default:
        maxOvers = 20;
        maxInnings = 2;
    }

    engine = MatchEngine(
      FormatRules(maxOvers: maxOvers, maxInnings: maxInnings),
    );

    // ✅ Null-safe balls mapping
    engine.team1Balls =
        team1BallsEngine?.map((s) => BallEvent.fromString(s)).toList() ?? [];
    engine.team2Balls =
        team2BallsEngine?.map((s) => BallEvent.fromString(s)).toList() ?? [];

    engine.isTeam1Batting = battingTeam == "team1";
    engine.status = status;
    engine.isFirstInningsOver = isFirstInningsOver;
  }

  // Firestore -> Model
  factory FeaturedMatchModel.fromMap(Map<String, dynamic> map) {
    dynamic timestamp = map['match_date'];
    DateTime matchDate;

    if (timestamp is String) {
      matchDate = DateTime.tryParse(timestamp) ?? DateTime.now();
    } else if (timestamp is Timestamp) {
      matchDate = timestamp.toDate();
    } else {
      matchDate = DateTime.now();
    }

    return FeaturedMatchModel(
      matchTitle: map['match_title'] ?? '',
      series: map['series'] ?? '',
      team1: map['team1'] ?? '',
      team2: map['team2'] ?? '',
      team1Logo: (map['team1Logo'] ?? map['team1logo'] ?? '').toString().trim(),
      team2Logo: (map['team2Logo'] ?? map['team2logo'] ?? '').toString().trim(),
      score1: map['score1'] ?? '',
      score2: map['score2'] ?? '',
      over1: map['over1'] ?? '',
      over2: map['over2'] ?? '',
      result: map['result'] ?? '',
      dateTime: matchDate,
      venue: map['venue'] ?? '',
      status: _parseStatus(map['status'] ?? "upcoming"),
      team1RunRate: (map['team1_run_rate'] ?? '').toString(),
      team2RunRate: (map['team2_run_rate'] ?? '').toString(),
      toss: (map['toss'] ?? '').toString(),
      tossWinner: map['tossWinner'] ?? "team1",
      battingTeam: map['battingTeam'] ?? map['tossWinner'] ?? "team1",
      lastBalls: List<String>.from(map['lastBalls'] ?? []),
      matchFormat: map['matchFormat']?.toString(),
      team1BallsEngine: map['team1BallsEngine'] != null
          ? List<String>.from(map['team1BallsEngine'])
          : [],
      team2BallsEngine: map['team2BallsEngine'] != null
          ? List<String>.from(map['team2BallsEngine'])
          : [],
      isListEmpty: map['isListEmpty'] ?? false,
      isFirstInningsOver: map['isFirstInningsOver'] ?? false,
      team1Player: map['team1Player'] != null
          ? List<String>.from(map['team1Player'])
          : [],
      team2Player: map['team2Player'] != null
          ? List<String>.from(map['team2Player'])
          : [],
    );
  }

  // Model -> Firestore
  Map<String, dynamic> toMap() {
    return {
      'match_title': matchTitle,
      'series': series,
      'team1logo': team1Logo,
      'team2logo': team2Logo,
      'team1': team1,
      'team2': team2,
      'score1': score1,
      'score2': score2,
      'over1': over1,
      'over2': over2,
      'result': result,
      'match_date': dateTime?.toIso8601String() ?? '',
      'venue': venue,
      'status': status.name,
      'team1_run_rate': team1RunRate,
      'team2_run_rate': team2RunRate,
      'toss': toss,
      'tossWinner': tossWinner,
      'battingTeam': battingTeam,
      'lastBalls': lastBalls,
      'matchFormat': matchFormat,
      'team1BallsEngine': team1BallsEngine ?? [],
      'team2BallsEngine': team2BallsEngine ?? [],
      'isListEmpty': isListEmpty,
      'isFirstInningsOver': isFirstInningsOver,
      'team1Player': team1Player ?? [],
      'team2Player': team2Player ?? [],
    };
  }

  static MatchStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case "upcoming":
        return MatchStatus.upcoming;
      case "live":
        return MatchStatus.live;
      case "ended":
        return MatchStatus.ended;
      default:
        return MatchStatus.upcoming;
    }
  }

  bool get isUpcoming => status == MatchStatus.upcoming;
  bool get isLive => status == MatchStatus.live;
  bool get isEnded => status == MatchStatus.ended;
}
