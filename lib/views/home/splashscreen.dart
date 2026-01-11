import 'dart:math';
import 'package:flutter/material.dart';
import '../screenstate/screenstate.dart';
import 'package:cricket_highlight/widgets/adwidget/openadservcie.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  final int _bubbleCount = 10; // fewer bubbles for subtle look
  late List<_Bubble> _bubbles;

  @override
  void initState() {
    super.initState();

    // Initialize bubbles
    _bubbles = List.generate(
      _bubbleCount,
          (_) => _Bubble(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        radius: 8 + _random.nextDouble() * 10, // smaller radius
        dx: (_random.nextDouble() - 0.5) / 300,
        dy: (_random.nextDouble() - 0.5) / 300,
      ),
    );

    // Animation controller for bubbles
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    // Navigate to next screen after 5 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreenState()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Update bubble positions
  void _updateBubbles() {
    for (var bubble in _bubbles) {
      bubble.x += bubble.dx;
      bubble.y += bubble.dy;

      if (bubble.x < 0) bubble.x = 1;
      if (bubble.x > 1) bubble.x = 0;
      if (bubble.y < 0) bubble.y = 1;
      if (bubble.y > 1) bubble.y = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          _updateBubbles();

          return Stack(
            fit: StackFit.expand,
            children: [
              // Glowing bubbles background
              CustomPaint(
                painter: _BubblePainter(_bubbles),
              ),

              // Center logo + loader bubbles
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 150,
                    ),
                  ),
                  const SizedBox(height: 80),

                  // Loader bubbles orbiting around center
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: Stack(
                      alignment: Alignment.center,
                      children: List.generate(3, (index) {
                        final angle =
                            (index * 2 * pi / 3) + (_controller.value * 2 * pi * 8);
                        return Transform.translate(
                          offset: Offset(20 * cos(angle), 20 * sin(angle)),
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.6),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

// Bubble model
class _Bubble {
  double x;
  double y;
  double radius;
  double dx;
  double dy;

  _Bubble({
    required this.x,
    required this.y,
    required this.radius,
    required this.dx,
    required this.dy,
  });
}

// Custom painter for glowing bubbles
class _BubblePainter extends CustomPainter {
  final List<_Bubble> bubbles;

  _BubblePainter(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var bubble in bubbles) {
      final center = Offset(bubble.x * size.width, bubble.y * size.height);

      // Radial gradient for bubble
      paint.shader = RadialGradient(
        colors: [
          Colors.redAccent.withOpacity(0.2),
          Colors.redAccent.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: bubble.radius));

      canvas.drawCircle(center, bubble.radius, paint);

      // subtle glow
      paint.shader = null;
      paint.color = Colors.redAccent.withOpacity(0.05);
      canvas.drawCircle(center, bubble.radius * 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
