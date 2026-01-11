import 'package:flutter/material.dart';
import '../model/hive_news_model.dart';
import '../repo/NewsRepository.dart';

class NewsProvider extends ChangeNotifier {
  final NewsRepository repository;

  NewsProvider({required this.repository});

  // UI states
  bool isLoading = false;
  String? error;
  List<Newsmodel> news = [];


  Future<void> loadNews({bool refresh = false}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      news = await repository.getNews(refresh: refresh); // <-- yaha refresh pass kar
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }



  Future<void> refreshNews() async {
    isLoading = true;
    notifyListeners();

    try {
      news = await repository.getNews(refresh: true);
      error = null;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

}
