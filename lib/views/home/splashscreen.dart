import 'dart:math';
import 'package:flutter/material.dart';
import '../screenstate/screenstate.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();


    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale =
        Tween<double>(begin: 0.85, end: 1).animate(CurvedAnimation(
          parent: _logoController,
          curve: Curves.easeOutCubic,
        ));

    _logoOpacity =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _logoController,
          curve: Curves.easeOut,
        ));

    _logoController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreenState()),
      );
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // premium animated gradient
              CustomPaint(
                painter: _WaveGradientPainter(_bgController.value),
              ),

              // dark overlay
              Container(
                color: Colors.black.withOpacity(0.35),
              ),

              // logo + loader
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _logoOpacity,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 160,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),

                  const _DotLoader(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

///// ================== LOADER ==================

class _DotLoader extends StatefulWidget {
  const _DotLoader();

  @override
  State<_DotLoader> createState() => _DotLoaderState();
}

class _DotLoaderState extends State<_DotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
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
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final scale =
                1 + sin((_controller.value * 2 * pi) + (i * pi / 2)) * 0.4;
            return Transform.scale(
              scale: scale,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.6),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

///// ================== BACKGROUND ==================

class _WaveGradientPainter extends CustomPainter {
  final double progress;

  _WaveGradientPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: const [
        Color(0xFF0F0F0F),
        Color(0xFF1A0000),
        Color(0xFF300000),
        Color(0xFF0F0F0F),
      ],
      stops: [
        0,
        0.3 + progress * 0.3,
        0.6 + progress * 0.3,
        1,
      ],
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
