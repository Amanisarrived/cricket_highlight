class Batsman {
  final String name;
  int runs = 0;
  int balls = 0;
  int fours = 0;
  int sixes = 0;
  bool isOut = false;

  Batsman({required this.name});

  double get strikeRate =>
      balls > 0 ? (runs / balls) * 100 : 0;
}
