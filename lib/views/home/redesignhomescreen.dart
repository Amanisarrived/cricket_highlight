import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Redesignhomescreen extends StatefulWidget {
  const Redesignhomescreen({super.key});

  @override
  State<Redesignhomescreen> createState() => _RedesignhomescreenState();
}

class _RedesignhomescreenState extends State<Redesignhomescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const AppText(
          "CrickStream",
          color: Colors.white,
          fontSize: 25,
        ).animate().fade(duration: 800.ms),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Image.asset(
              "assets/images/logo.png",
              scale: 7,
            ).animate().fade(duration: 800.ms),
          ),
        ],
      ),
    );
  }
}
