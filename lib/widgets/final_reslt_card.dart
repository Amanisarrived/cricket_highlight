import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../model/ball_event.dart';
import '../model/match_status.dart';
import '../model/featured_match_model.dart';
import 'balls_row.dart';
import 'match_engine.dart';

class FinalResultCard extends StatefulWidget {
  final FeaturedMatchModel match;

  const FinalResultCard({super.key, required this.match});

  @override
  State<FinalResultCard> createState() => _FinalResultCardState();
}

class _FinalResultCardState extends State<FinalResultCard>
    with SingleTickerProviderStateMixin {
  List<String> displayBalls = [];
  final _extras = ["WD", "NB", "B", "LB"];
  late ScrollController _scrollController;
  late AnimationController _controller;
  late MatchEngine engine;

  bool showSecondTeam = false;
  Timer? inningsTimer;
  Timer? countdownTimer;
  Duration? timeRemaining;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();



    _setupEngine();
    _startCountdownTimer();
  }

  @override
  void didUpdateWidget(covariant FinalResultCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.match != widget.match) {
      _setupEngine();
      _startCountdownTimer();
    }
  }

  void _setupEngine() {
    engine = MatchEngine.fromBackendFormat(
      battingTeam: widget.match.battingTeam,
      backendFormat: widget.match.matchFormat ?? "t20",
      isListEmpty: widget.match.isListEmpty ?? false,
    );

    if (widget.match.team1BallsEngine != null) {
      engine.team1Balls = widget.match.team1BallsEngine!
          .map((s) => BallEvent.fromString(s))
          .toList();
    }
    if (widget.match.team2BallsEngine != null) {
      engine.team2Balls = widget.match.team2BallsEngine!
          .map((s) => BallEvent.fromString(s))
          .toList();
    }

    engine.status = widget.match.status;

    inningsTimer?.cancel();
    if (engine.isFirstInningsOver) {
      inningsTimer = Timer(const Duration(minutes: 2), () {
        if (mounted) {
          setState(() {
            showSecondTeam = true;
          });
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateDisplayBalls();
    });
  }

  void _startCountdownTimer() {
    countdownTimer?.cancel();

    if (widget.match.dateTime != null) {
      final matchDateTime = widget.match.dateTime!;
      final now = DateTime.now();

      if (matchDateTime.isAfter(now)) {
        timeRemaining = matchDateTime.difference(now);

        countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {
              final now = DateTime.now();
              final difference = matchDateTime.difference(now);

              if (difference.isNegative || difference.inSeconds <= 0) {
                timeRemaining = Duration.zero;
                timer.cancel();
                // Update match status to live when timer reaches zero
                if (engine.status == MatchStatus.upcoming) {
                  engine.status = MatchStatus.live;
                }
              } else {
                timeRemaining = difference;
              }
            });
          }
        });
      } else {
        timeRemaining = null;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    inningsTimer?.cancel();
    countdownTimer?.cancel();
    super.dispose();
  }

  void _updateDisplayBalls() {
    if (widget.match.isListEmpty == true) {
      displayBalls = [];
    } else {
      List<String> battingBalls = [];
      try {
        final stats = engine.currentBattingStats();
        if (stats['lastBalls'] != null) {
          battingBalls = List<String>.from(stats['lastBalls']);
        }
      } catch (e) {
        battingBalls = widget.match.team1BallsEngine ?? [];
      }

      List<String> temp = [];
      int legalBalls = 0;

      for (final ball in battingBalls) {
        temp.add(ball);
        if (!_extras.contains(ball)) legalBalls++;
        if (legalBalls == 6) {
          temp.add("|");
          legalBalls = 0;
        }
      }

      displayBalls = temp;
    }

    if (mounted) {
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  String _formatCountdown(Duration duration) {
    if (duration.inDays > 0) {
      return "${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m";
    } else if (duration.inHours > 0) {
      return "${duration.inHours}h ${duration.inMinutes % 60}m ${duration.inSeconds % 60}s";
    } else if (duration.inMinutes > 0) {
      return "${duration.inMinutes}m ${duration.inSeconds % 60}s";
    } else {
      return "${duration.inSeconds}s";
    }
  }

  @override
  Widget build(BuildContext context) {
    final team1Runs = engine.totalRuns(engine.team1Balls);
    final team1Wickets = min(engine.totalWickets(engine.team1Balls), 10);
    final team2Runs = engine.totalRuns(engine.team2Balls);
    final team2Wickets = min(engine.totalWickets(engine.team2Balls), 10);
    final team1Overs = engine.overs(engine.team1Balls);
    final team2Overs = engine.overs(engine.team2Balls);
    final team1RR = engine.runRate(engine.team1Balls).toStringAsFixed(1);
    final team2RR = engine.runRate(engine.team2Balls).toStringAsFixed(1);

    bool firstInningsTeam1 = engine.isTeam1Batting;
    bool showTeam1Balls;

    if (engine.isFirstInningsOver && showSecondTeam) {
      showTeam1Balls = !firstInningsTeam1;
    } else {
      showTeam1Balls = firstInningsTeam1;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // STATUS + FORMAT + TIMER/DATE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _statusChip(engine.status),
                    const SizedBox(width: 6),
                    _formatChip(widget.match.matchFormat),
                  ],
                ),

                timeRemaining != null && timeRemaining!.inSeconds > 0
                    ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orangeAccent.withOpacity(0.5)),
                  ),
                  child: Text(
                    _formatCountdown(timeRemaining!),
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                    : Text(
                  _formatDate(widget.match.dateTime ?? DateTime.now()),
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),

            const SizedBox(height: 6),
            Text(widget.match.matchTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(widget.match.series,
                style: const TextStyle(color: Colors.white54, fontSize: 11)),
            const SizedBox(height: 2),
            Text(widget.match.venue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white38, fontSize: 10)),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _team(widget.match.team1, team1Runs, team1Wickets,
                    team1Overs, widget.match.team1Logo, team1RR),
                _vs(),
                _team(widget.match.team2, team2Runs, team2Wickets,
                    team2Overs, widget.match.team2Logo, team2RR),
              ],
            ),

            const SizedBox(height: 16),
            if (displayBalls.isNotEmpty)
              BallsRow(
                team1Balls: engine.team1Balls.map((e) => e.toString()).toList(),
                team2Balls: engine.team2Balls.map((e) => e.toString()).toList(),
                isTeam1Batting: showTeam1Balls,
                isFirstInningsOver: engine.isFirstInningsOver,
              ),

            const SizedBox(height: 10),
            if (widget.match.toss.isNotEmpty)
              Text("Toss: ${widget.match.toss}",
                  style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Text(widget.match.result,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),

            const SizedBox(height: 12),

            // ⭐ VIEW SCORE CARD BUTTON
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.white12,
            //     foregroundColor: Colors.white,
            //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) => ScoreCardScreen(
            //           matchEngine: engine,
            //           team1Players: widget.match.team1Player!,
            //           team2Players: widget.match.team2Player!,
            //           matchModel: widget.match,
            //         ),
            //       ),
            //     );
            //   },
            //   child: const Text(
            //     "View Score Card",
            //     style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _formatChip(String? format) {
    final text = (format ?? "T20").toUpperCase();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _team(String team, int runs, int wickets, String over,
      String logo, String runRate) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Image.network(logo, width: 50, height: 50, fit: BoxFit.cover),
        ),
        const SizedBox(height: 6),
        Text(team,
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        Text("$runs/$wickets",
            style: const TextStyle(
                color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
        Text(over, style: const TextStyle(color: Colors.white38, fontSize: 10)),
        if (runRate.isNotEmpty)
          Text("RR: $runRate",
              style: const TextStyle(
                  color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _vs() {
    return const Text("VS",
        style: TextStyle(
            color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w600));
  }

  Widget _statusChip(MatchStatus status) {
    switch (status) {
      case MatchStatus.upcoming:
        return _chip("UPCOMING", Colors.blueAccent);
      case MatchStatus.live:
        return _liveChip();
      case MatchStatus.ended:
        return _chip("ENDED", Colors.blueGrey);
    }
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _liveChip() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double value = 0.5 + 0.5 * sin(2 * pi * _controller.value);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.6 * value),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Text("LIVE",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
        );
      },
    );
  }

  String _formatDate(DateTime dt) {
    final months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    String month = months[dt.month - 1];
    String day = dt.day.toString();
    String hour = dt.hour.toString().padLeft(2, '0');
    String minute = dt.minute.toString().padLeft(2, '0');
    return "$month $day, $hour:$minute LOCAL";
  }
}