enum BallType { run, wide, noBall, wicket }

class BallEvent {
  final BallType type;
  final int runs; // runs by batsman (0 by default)
  final int strikerIndex; // 0 ya 1 -> kaunsa batsman strike par
  final bool isOut; // wicket ke liye

  BallEvent({
    required this.type,
    this.runs = 0,
    this.strikerIndex = 0, // default 0
    this.isOut = false, // default false
  });

  // ----------------------------
  // Factory from backend string
  // ----------------------------
  factory BallEvent.fromString(String s) {
    s = s.toUpperCase().trim();

    if (s.startsWith("WD")) {
      int extraRun = 0;
      if (s.length > 2) extraRun = int.tryParse(s.substring(2)) ?? 0;
      return BallEvent(type: BallType.wide, runs: extraRun);
    } else if (s.startsWith("NB")) {
      int extraRun = 0;
      if (s.length > 2) extraRun = int.tryParse(s.substring(2)) ?? 0;
      return BallEvent(type: BallType.noBall, runs: extraRun);
    } else if (s == "W") {
      return BallEvent(type: BallType.wicket, isOut: true);
    } else {
      int run = int.tryParse(s) ?? 0;
      return BallEvent(type: BallType.run, runs: run);
    }
  }

  @override
  String toString() {
    switch (type) {
      case BallType.wicket:
        return "W";
      case BallType.wide:
        return runs > 0 ? "WD$runs" : "WD";
      case BallType.noBall:
        return runs > 0 ? "NB$runs" : "NB";
      case BallType.run:
        return runs.toString();
    }
  }
}
