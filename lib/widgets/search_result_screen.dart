import 'package:cricket_highlight/widgets/video_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/search_provider.dart';
import '../widgets/shorts_card.dart';

class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    final results = searchProvider.results;
    final query = searchProvider.query;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Results for \"$query\"",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: results.isEmpty
          ? const Center(
        child: Text(
          "No results found 😕",
          style: TextStyle(color: Colors.white54),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final movie = results[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: VideoCard(movie: movie, onTap: (){

            })
          );
        },
      ),
    );
  }
}
