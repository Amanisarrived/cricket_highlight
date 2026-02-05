import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../../model/moviemodel.dart';
import '../../model/hive_movie_model.dart';
import '../service/app_service.dart';
import '../../provider/categoryprovider.dart';

class ReelsRepository {
  final ApiService apiService;
  final Box<HiveMovieModel> reelsBox;

  final List<MovieModel> _cache = [];
  final List<MovieModel> visibleReels = [];

  bool _isFetched = false;

  ReelsRepository({
    required this.apiService,
    required this.reelsBox,
  });

  /// INIT (same as before)
  Future<void> initReels({CategoryProvider? catProvider}) async {
    if (_cache.isNotEmpty) {
      visibleReels
        ..clear()
        ..addAll(_cache);
      return;
    }

    final data = catProvider != null
        ? await catProvider.getReels()
        : apiService.getMoviesByCategoryId(45);

    _cache
      ..clear()
      ..addAll(data);

    visibleReels
      ..clear()
      ..addAll(_cache);

    shuffleOnce();
  }

  // 🔥 ONLY SHUFFLE FUNCTION (tu baad me remove kar sakta hai)
  void shuffleVisibleOnce() {
    if (visibleReels.isEmpty) return;

    final temp = List<MovieModel>.from(visibleReels);
    temp.shuffle(Random());

    visibleReels
      ..clear()
      ..addAll(temp);

    debugPrint("🔥 Reels shuffled (visible only)");
  }

  void loadMoreIfNeeded(int index) {}

  void resetForRefresh() {
    _isFetched = false;
    _cache.clear();
    visibleReels.clear();
  }

  List<MovieModel> getTrendingReels() {
    return _cache.where((m) => m.isTrending == true).toList();
  }

  List<MovieModel> getPreviewReels(int count) {
    if (visibleReels.isEmpty) return [];
    return visibleReels.take(count).toList();
  }
  void shuffleOnce() {
    visibleReels
      ..clear()
      ..addAll(_cache);

    visibleReels.shuffle(Random());
  }

}

