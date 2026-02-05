import 'package:cricket_highlight/service/upcoming_features_service.dart';
import 'package:flutter/material.dart';
import '../model/upcoming_fixture_model.dart';
import 'match_card.dart';
import 'apptext.dart';

class TournamentDetails extends StatelessWidget {
  TournamentDetails({super.key});

  final UpcomingFixtureService _service = UpcomingFixtureService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
      padding: const EdgeInsets.only(left: 8, right: 5, top: 14, bottom: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF111111), Color(0xFF111111)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: _buildSectionTitle('Upcoming Matches'),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 180,
            child: StreamBuilder<List<UpcomingFixtureModel>>(
              stream: _service.streamUpcomingFixtures(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }

                // 🔥 Only include matches with time in the future
                final now = DateTime.now();
                final matches = snapshot.data!
                    .where((match) => match.time.toDate().isAfter(now))
                    .toList();

                if (matches.isEmpty) {
                  return const Center(
                    child: AppText(
                      "No upcoming matches",
                      color: Colors.white54,
                    ),
                  );
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  itemCount: matches.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return MatchCard(match: matches[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildSectionTitle(String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text,
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
            ),
          )
        ],
      ),
    ],
  );
}
