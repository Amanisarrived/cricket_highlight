import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/hive_news_model.dart';
import '../utils/fadenavigation.dart';
import '../utils/time_helper.dart';
import '../views/home/news_detils_screen.dart';


class NewsCard extends StatelessWidget {
  final Newsmodel news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      FadePageRoute(
                        page: NewsByIdScreen(newsId: news.id),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: AspectRatio(
                      aspectRatio: 16 / 8,
                      child: Image.network(
                        news.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade900,
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.white30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),


                // 🔗 SHARE BUTTON TOP-RIGHT
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        final shareText =
                            '${news.title}\n\nRead full news 👇${news.url}';
                        Share.share(shareText);
                      },
                      icon: const Icon(
                        Icons.share_rounded,
                        color: Colors.white70,
                        size: 20,
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
              ],
            ),
          ),



          /// 📜 CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: GoogleFonts.bebasNeue(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 1.15,
                    ),
                  ),
                  Divider(thickness: 1,color: Colors.white.withAlpha(40),),
                  const SizedBox(height: 10),
                  Flexible(
                    child: Text(
                      news.description,
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.45,
                        fontWeight: FontWeight.w200
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 🔗 SOURCE
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white12)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {
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
                    "Source · ${news.credits}",
                    style: GoogleFonts.bebasNeue(
                      color: Colors.white60,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                 const SizedBox(width: 20,),
                Text(
                  formatTimeAgo(news.createdAt),
                  style: GoogleFonts.bebasNeue(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
