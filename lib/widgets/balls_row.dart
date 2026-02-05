import 'dart:math';
import 'package:flutter/material.dart';

class BallsRow extends StatefulWidget {
  final List<String> team1Balls;
  final List<String> team2Balls;
  final bool isTeam1Batting;
  final bool isFirstInningsOver;

  const BallsRow({
    super.key,
    required this.team1Balls,
    required this.team2Balls,
    required this.isTeam1Batting,
    required this.isFirstInningsOver,
  });

  @override
  State<BallsRow> createState() => _BallsRowState();
}

class _BallsRowState extends State<BallsRow> {
  bool _showCurrentBattingTeam = true;
  DateTime? _inningsSwitchTime;
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(BallsRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if innings switched (batting team changed)
    if (oldWidget.isTeam1Batting != widget.isTeam1Batting) {
      // Innings switch hui hai
      _inningsSwitchTime = DateTime.now();

      setState(() {
        _showCurrentBattingTeam = false; // pehle purani team dikhao
      });

      // 2 minute delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showCurrentBattingTeam = true; // 2 min baad nayi team dikhao
          });
          _scrollToEnd();
        }
      });
    }


    final oldBalls = oldWidget.isTeam1Batting ? oldWidget.team1Balls : oldWidget.team2Balls;
    final newBalls = widget.isTeam1Batting ? widget.team1Balls : widget.team2Balls;

    if (oldBalls.length != newBalls.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToEnd();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Auto-scroll to end
  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  List<Widget> _buildBallsWithSeparators(List<String> balls) {
    List<Widget> widgets = [];
    int legalBallCount = 0;

    for (int i = 0; i < balls.length; i++) {
      final ball = balls[i];

      bool isLegal = !ball.startsWith("WD") && !ball.startsWith("NB");

      if (isLegal) {
        legalBallCount++;
      }
      widgets.add(_buildBallWidget(ball, i));
      if (legalBallCount == 6 && i < balls.length - 1) {
        widgets.add(_buildSeparator());
        legalBallCount = 0;
      }
    }

    return widgets;
  }


  Widget _buildBallWidget(String ball, int index) {

    bool shouldAnimate = ball == "W" || ball.contains("4") || ball.contains("6");

    Color bgColor = Colors.white24;
    Color glowColor = Colors.transparent;
    CelebrationType? celebrationType;

    if (ball.contains("4")) {
      bgColor = Colors.orange;

      celebrationType = CelebrationType.boundary;
    } else if (ball.contains("6")) {
      bgColor = Colors.orange;

      celebrationType = CelebrationType.six;
    } else if (ball == "W") {
      bgColor = Colors.red;

      celebrationType = CelebrationType.wicket;
    } else if (ball.startsWith("WD") || ball.startsWith("NB")) {
      bgColor = Colors.blueAccent;
    }

    Widget ballContainer = Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 25,
      constraints: const BoxConstraints(minWidth: 30),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          ball,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
    );


    if (shouldAnimate && celebrationType != null) {
      return _CelebrationBall(
        key: ValueKey('$index-$ball'),
        glowColor: glowColor,
        celebrationType: celebrationType,
        child: ballContainer,
      );
    }

    return ballContainer;
  }

  // Build separator widget
  Widget _buildSeparator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 2,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white38,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Decide which balls to show
    final List<String> ballsToShow;

    if (!widget.isFirstInningsOver) {

      ballsToShow = widget.isTeam1Batting ? widget.team1Balls : widget.team2Balls;
    } else {

      if (_showCurrentBattingTeam) {

        ballsToShow = widget.isTeam1Batting ? widget.team1Balls : widget.team2Balls;
      } else {

        ballsToShow = widget.isTeam1Batting ? widget.team2Balls : widget.team1Balls;
      }
    }

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _buildBallsWithSeparators(ballsToShow),
      ),
    );
  }
}


enum CelebrationType { boundary, six, wicket }


class _CelebrationBall extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final CelebrationType celebrationType;

  const _CelebrationBall({
    super.key,
    required this.child,
    required this.glowColor,
    required this.celebrationType,
  });

  @override
  State<_CelebrationBall> createState() => _CelebrationBallState();
}

class _CelebrationBallState extends State<_CelebrationBall>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;
  final List<Particle> particles = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // ✅ FIXED: Simple Tween instead of TweenSequence
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));


    _generateParticles();


    _controller.forward();
  }

  void _generateParticles() {
    final random = Random();
    int particleCount;

    switch (widget.celebrationType) {
      case CelebrationType.six:
        particleCount = 12;
        break;
      case CelebrationType.boundary:
        particleCount = 8;
        break;
      case CelebrationType.wicket:
        particleCount = 10;
        break;
    }

    for (int i = 0; i < particleCount; i++) {
      particles.add(Particle(
        angle: (2 * pi * i / particleCount) + random.nextDouble() * 0.3,
        distance: 20 + random.nextDouble() * 15,
        size: 2 + random.nextDouble() * 2,
        color: widget.glowColor,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          clipBehavior: Clip.none, // ✅ Allow overflow for glow effect
          alignment: Alignment.center,
          children: [
            ...particles.map((particle) {
              final progress = _controller.value.clamp(0.0, 1.0);
              final distance = particle.distance * progress;
              final opacity = (1.0 - progress).clamp(0.0, 1.0);

              return Positioned(
                left: cos(particle.angle) * distance,
                top: sin(particle.angle) * distance,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: particle.size,
                    height: particle.size,
                    decoration: BoxDecoration(
                      color: particle.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }).toList(),

            // Main ball with animations
            Transform.rotate(
              angle: _rotationAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.glowColor.withOpacity(_glowAnimation.value * 0.8),
                        blurRadius: 12 * _glowAnimation.value,
                        spreadRadius: 4 * _glowAnimation.value,
                      ),
                    ],
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


class Particle {
  final double angle;
  final double distance;
  final double size;
  final Color color;

  Particle({
    required this.angle,
    required this.distance,
    required this.size,
    required this.color,
  });
}