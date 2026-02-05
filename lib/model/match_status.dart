import 'package:hive/hive.dart';

part 'match_status.g.dart';

@HiveType(typeId: 8) // typeId unique rakho, FeaturedMatchModel is 7
enum MatchStatus {
  @HiveField(0)
  upcoming,
  @HiveField(1)
  live,
  @HiveField(2)
  ended,
}
