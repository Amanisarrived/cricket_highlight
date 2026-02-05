import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'upcoming_fixture_model.g.dart';

@HiveType(typeId: 4)
class UpcomingFixtureModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String team1;

  @HiveField(2)
  final String team2;

  @HiveField(3)
  final Timestamp time;

  @HiveField(4)
  final String tournament;

  @HiveField(5)
  final String venue;

  @HiveField(6)
  final String winningTeam;

  // 🔥 NEW
  @HiveField(7)
  final String team1Logo;

  @HiveField(8)
  final String team2Logo;

  UpcomingFixtureModel({
    required this.id,
    required this.team1,
    required this.team2,
    required this.time,
    required this.tournament,
    required this.venue,
    required this.winningTeam,
    required this.team1Logo,
    required this.team2Logo,
  });

  /// Firestore -> Dart Model
  factory UpcomingFixtureModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UpcomingFixtureModel(
      id: doc.id,
      team1: data['team1']?.toString() ?? '',
      team2: data['team2']?.toString() ?? '',
      time: data['time'] as Timestamp,
      tournament: data['tournament']?.toString() ?? '',
      venue: data['venue']?.toString() ?? '',
      winningTeam: data['winningTeam']?.toString() ?? '',
      team1Logo: data['team1Logo']?.toString() ?? '',
      team2Logo: data['team2Logo']?.toString() ?? '',
    );
  }

  /// Dart Model -> Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'team1': team1,
      'team2': team2,
      'time': time,
      'tournament': tournament,
      'venue': venue,
      'winningTeam': winningTeam,
      'team1Logo': team1Logo,
      'team2Logo': team2Logo,
    };
  }
}
