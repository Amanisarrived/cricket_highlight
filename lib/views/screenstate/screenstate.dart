import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cricket_highlight/views/home/homescreen.dart';
import 'package:cricket_highlight/views/categoryscreen/categoryscreen.dart';
import 'package:cricket_highlight/views/home/savedscreen.dart';
import 'package:cricket_highlight/views/home/settingscreen.dart';

class MainScreenState extends StatefulWidget {
  const MainScreenState({super.key});

  @override
  State<MainScreenState> createState() => _MainScreenStateState();
}

class _MainScreenStateState extends State<MainScreenState> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    Homescreen(),
    Categoryscreen(),
    SavedScreen(),
    Settingscreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _screens[_currentIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.black,
                selectedItemColor: Colors.redAccent,
                unselectedItemColor: Colors.white54,
                selectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 12),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(LucideIcons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(LucideIcons.layoutGrid),
                    label: "Category",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(LucideIcons.bookmark),
                    label: "Saved",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(LucideIcons.settings),
                    label: "Settings",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
