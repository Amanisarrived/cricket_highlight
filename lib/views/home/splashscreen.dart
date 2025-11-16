import 'package:flutter/material.dart';
import '../screenstate/screenstate.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // Navigate to MainScreenState after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreenState()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // dark premium background
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 150,
            ),
          ),
          const SizedBox(height: 80),

          // Premium circular spinner
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 4.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
              backgroundColor: Colors.redAccent.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
