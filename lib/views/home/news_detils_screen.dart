import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/hive_news_model.dart';

class NewsByIdScreen extends StatelessWidget {
  final String newsId;

  const NewsByIdScreen({super.key, required this.newsId});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Newsmodel>('news');
    final news = box.get(newsId);

    if (news == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'News not found',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "News Detail",
          style: TextStyle(color: Colors.white70),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼 IMAGE WITH SHARE BUTTON
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        news.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade900,
                          height: 220,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.white30,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 16,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          final shareText =
                              '${news.title}\n\nRead full news 👇\nhttps://crickethighlight.app/news/${news.url}';
                          Share.share(shareText);
                        },
                        icon: const Icon(
                          Icons.share_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                        padding: const EdgeInsets.all(5),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 📝 TITLE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  news.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 📝 DESCRIPTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  news.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 🔗 SOURCE BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade900, // dul color
                      foregroundColor: Colors.white, // text color
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (news.url.trim().isEmpty) return;
                      final uri = Uri.tryParse(news.url);
                      if (uri != null) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    child: Text(
                      "Read from Source: ${news.credits}",
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
