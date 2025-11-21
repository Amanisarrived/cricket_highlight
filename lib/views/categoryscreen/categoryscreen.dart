
import 'package:cricket_highlight/views/categoryscreen/bestcathces.dart';
import 'package:cricket_highlight/views/categoryscreen/funnymoments.dart';
import 'package:cricket_highlight/views/categoryscreen/highlights.dart';
import 'package:cricket_highlight/views/categoryscreen/odiscreen.dart';
import 'package:cricket_highlight/views/categoryscreen/playermoments.dart';
import 'package:cricket_highlight/views/categoryscreen/testmatchesscreen.dart';
import 'package:cricket_highlight/views/categoryscreen/twentyscreen.dart';
import 'package:cricket_highlight/views/categoryscreen/world_cup_matches.dart';
import 'package:cricket_highlight/widgets/apptext.dart';
import 'package:cricket_highlight/widgets/categoriescard.dart';
import 'package:flutter/material.dart';

class Categoryscreen extends StatelessWidget {
  const Categoryscreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final categoryprovider = Provider.of<CategoryProvider>(context);
    // final apiCategories = categoryprovider.categories;



    final categories = [
      {
        'title': 'Highlights',
        'icon': Icons.play_circle_fill,
        "imageurl": "assets/images/highlights.png",
        "screen": const HighlightsScreen(),
      },
      {
        'title': 'T20 Matches',
        'icon': Icons.sports_cricket,
        "imageurl": "assets/images/t20.png",
        "screen": const Twentyscreen(),
      },
      {
        'title': 'ODI Matches',
        'icon': Icons.tv,
        "imageurl": "assets/images/odi.png",
        "screen" : const OdiScreen()

      },
      {
        'title': 'Test Matches',
        'icon': Icons.flag_circle,
        "imageurl": "assets/images/testmatch.png",
        "screen" : const TestMatchesScreen()
      },
      {
        'title': 'World Cup',
        'icon': Icons.emoji_events,
        "imageurl": "assets/images/worldcup.png",
        "screen" : const WorldcupMatches()
      },
      {
        'title': 'Player Moments',
        'icon': Icons.person_pin,
        "imageurl": "assets/images/playermoment.png",
        "screen" : const PlayerMoment()
      },
      {
        'title': 'Funny Moments',
        'icon': Icons.mic,
        "imageurl": "assets/images/funny.png",
        "screen" : const FunnyMoments()
      },
      {
        'title': 'Best Catches',
        'icon': Icons.video_camera_back,
        "imageurl": "assets/images/catches.png",
        "screen" : const BestCatches()
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const AppText(
          "Categories",
          fontSize: 25,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.redAccent.withAlpha(80), height: 1.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
            childAspectRatio: 0.85,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(
              title: category['title'] as String,
              icon: category['icon'] as IconData,
              imageUrl: category["imageurl"] as String,
              onTap: () {
                debugPrint("${category['title']} tapped");

                final screen = category['screen'];
                if (screen != null && screen is Widget) {
                  Navigator.of(context).push(_noFlashRoute(screen));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent.withAlpha(80),
                      content: Text("${category['title']} tapped"),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  Route _noFlashRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      opaque: true,
      barrierColor: Colors.black, // ensures no white flash
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(
          begin: const Offset(0.05, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
    );
  }
}
