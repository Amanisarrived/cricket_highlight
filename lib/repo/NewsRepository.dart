import 'dart:math';
import 'package:cricket_highlight/model/news_model.dart';
import 'package:hive/hive.dart';
import '../model/hive_news_model.dart';
import '../service/app_service.dart';

class NewsRepository {
  final ApiService apiService;
  final Box<Newsmodel> newsBox;

  NewsRepository({
    required this.apiService,
    required this.newsBox,
  });

  Future<List<Newsmodel>> getNews({bool refresh = false}) async {
    List<Newsmodel> newsList = [];


    _removeOldLocalNews();

    if (newsBox.isNotEmpty && !refresh) {
      newsList = newsBox.values.toList();
    } else {
      final List<NewsModel> freshNewsFromApi =
      await apiService.fetchNews();

      final now = DateTime.now();


      final freshNews = freshNewsFromApi.where((news) {
        return now.difference(news.createdAt).inDays < 3;
      }).toList();


      newsList = freshNews
          .map((news) => Newsmodel.fromApi(news))
          .toList();


      await newsBox.clear();
      for (final news in newsList) {
        await newsBox.put(news.id, news);
      }
    }

    newsList.shuffle(Random());
    return newsList.reversed.toList();
  }


  void _removeOldLocalNews() {
    final now = DateTime.now();

    for (final key in newsBox.keys) {
      final news = newsBox.get(key);
      if (news == null) continue;

      if (now.difference(news.createdAt).inDays >= 3) {
        newsBox.delete(key);
      }
    }
  }
}
