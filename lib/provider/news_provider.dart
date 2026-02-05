import 'package:flutter/foundation.dart';
import '../model/hive_news_model.dart';
import '../repo/NewsRepository.dart';

class NewsProvider extends ChangeNotifier {
  final NewsRepository repository;

  NewsProvider({required this.repository});

  bool isLoading = false;
  String? _error;
  List<Newsmodel> visibleNews = [];

  String? get error => _error;

  Future<void> init({bool refresh = false}) async {
    if (refresh) visibleNews.clear();

    isLoading = true;
    _error = null;
    if (!refresh) notifyListeners();

    try {
      await repository.initNews(refresh: refresh);
      visibleNews = List.from(repository.visibleNews); // newest first already
    } catch (e) {
      _error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void loadMoreIfNeeded(int index) {
    repository.loadMoreIfNeeded(index);
    visibleNews = List.from(repository.visibleNews);
    notifyListeners();
  }

  Future<void> refreshNews() async {
    await init(refresh: true);
  }
}
