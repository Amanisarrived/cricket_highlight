
import '../../model/match_status.dart';
import '../../widgets/match_engine.dart';

MatchStatus _readStatus(dynamic value) {
  try {
    if (value is MatchStatus) return value; // already correct type
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'upcoming':
          return MatchStatus.upcoming;
        case 'live':
          return MatchStatus.live;
        case 'ended':
          return MatchStatus.ended;
        default:
          return MatchStatus.upcoming;
      }
    }
    // Agar purane data me galti se bool ya kuch aur type ho to
    return MatchStatus.upcoming;
  } catch (_) {
    return MatchStatus.upcoming;
  }
}
