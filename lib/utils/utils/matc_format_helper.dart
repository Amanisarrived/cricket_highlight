import '../../model/match_format.dart';

MatchFormat parseFormat(String format) {
  switch (format.toLowerCase()) {
    case "t20":
      return MatchFormat.t20;
    case "odi":
      return MatchFormat.odi;
    case "test":
      return MatchFormat.test;
    default:
      return MatchFormat.t20; // fallback agar kuch galat aaya
  }
}

// Enum ke basis pe FormatRules generate kare
FormatRules getRules(MatchFormat format) {
  switch (format) {
    case MatchFormat.t20:
      return FormatRules(maxOvers: 20, maxInnings: 1);
    case MatchFormat.odi:
      return FormatRules(maxOvers: 50, maxInnings: 1);
    case MatchFormat.test:
      return FormatRules(maxOvers: null, maxInnings: 2);
    case MatchFormat.t1:
      return FormatRules(maxOvers: 1, maxInnings: 1);
  }
}
