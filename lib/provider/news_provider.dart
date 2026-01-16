import 'package:flutter/foundation.dart';
import '../model/hive_news_model.dart';
import '../repo/NewsRepository.dart';

class NewsProvider extends ChangeNotifier {
  final NewsRepository repository;

  NewsProvider({required this.repository});

  bool isLoading = false;
  String? _error;
  List<Newsmodel> visibleNews = [];

  // 🔥 PUBLIC GETTER
  String? get error => _error;

  Future<void> init({bool refresh = false}) async {
    isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await repository.initNews(refresh: refresh);
      visibleNews = repository.visibleNews;
    } catch (e) {
      _error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void loadMoreIfNeeded(int index) {
    repository.loadMoreIfNeeded(index);
    visibleNews = repository.visibleNews;
    notifyListeners();
  }

  Future<void> refreshNews() async {
    await init(refresh: true);
  }
}
