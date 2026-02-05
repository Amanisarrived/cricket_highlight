import 'dart:math';
import 'package:hive/hive.dart';
import '../model/hive_news_model.dart';
import '../service/app_service.dart';

class NewsRepository {
  final ApiService apiService;
  final Box<Newsmodel> newsBox;

  List<Newsmodel> _source = [];
  List<Newsmodel> visibleNews = [];

  int _pointer = 0;
  final int pageSize = 5;
  final int maxDays = 6;

  NewsRepository({
    required this.apiService,
    required this.newsBox,
  });

  Future<void> initNews({bool refresh = false}) async {
    if (refresh) {
      _pointer = 0;
      visibleNews.clear();
    }

    final apiData = await apiService.fetchNews();
    final now = DateTime.now();

    // 🔥 Filter by maxDays + sort newest first
    _source = apiData
        .map((e) => Newsmodel.fromApi(e))
        .where(
          (news) => now.difference(news.createdAt).inDays <= maxDays,
    )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest first

    if (_source.isEmpty) return;

    // await newsBox.clear();
    await newsBox.putAll({for (var n in _source) n.id: n});

    _addNext();
  }

  /// 🔥 Pagination
  void loadMoreIfNeeded(int index) {
    if (index >= visibleNews.length - 2) {
      _addNext();
    }
  }

  /// 🔥 Add next batch
  void _addNext() {
    int added = 0;

    while (added < pageSize && _pointer < _source.length) {
      visibleNews.add(_source[_pointer]);
      _pointer++;
      added++;
    }
  }

  bool get hasMore => _pointer < _source.length;
}
