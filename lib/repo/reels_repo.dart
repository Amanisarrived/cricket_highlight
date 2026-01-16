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

  List<MovieModel> _allReels = [];
  List<MovieModel> visibleReels = [];

  int _currentPointer = 0;
  final int pageSize = 1;
  final int visibleLimit = 100;

  ReelsRepository({
    required this.apiService,
    required this.reelsBox,
  });

  /// INIT
  Future<void> initReels({CategoryProvider? catProvider}) async {
    debugPrint("ReelsRepository: initReels");

    if (catProvider != null) {
      _allReels = await catProvider.getReels();
    } else {
      _allReels = apiService.getMoviesByCategoryId(45);
    }

    if (_allReels.isEmpty) return;

    _allReels.shuffle(Random());
    visibleReels.clear();
    _currentPointer = 0;
    _addNext();
    _addNext();
    _addNext();
  }

  /// Pagination
  void loadMoreIfNeeded(int index) {
    if (index >= visibleReels.length - 1) {
      _addNext();
    }
  }

  /// Core logic
  void _addNext() {
    if (_allReels.isEmpty) return;

    final reel = _allReels[_currentPointer];
    visibleReels.add(reel);

    _currentPointer++;

    if (_currentPointer >= _allReels.length) {
      _currentPointer = 0;
      _allReels.shuffle(Random());
    }

    if (visibleReels.length > visibleLimit) {
      visibleReels.removeAt(0);
    }
  }

  void resetForRefresh() {
    _currentPointer = 0;
    visibleReels.clear();
    _allReels.clear();
  }
}
