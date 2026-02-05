import 'package:flutter/foundation.dart';
import '../model/moviemodel.dart';
import '../repo/reels_repo.dart';
import 'categoryprovider.dart';

class ReelsProvider with ChangeNotifier {
  final ReelsRepository repository;

  ReelsProvider({required this.repository});

  bool _isLoading = false;
  String? _error;
  MovieModel? _forcedStart;

  List<MovieModel> get visibleReels => repository.visibleReels;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 🔥 INIT + ONE TIME SHUFFLE
  Future<void> initReels(CategoryProvider catProvider) async {
    _isLoading = true;
    notifyListeners();

    try {
      await repository.initReels(catProvider: catProvider);

      // 🔁 shuffle only once after fetch
      repository.shuffleVisibleOnce();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void loadMoreIfNeeded(int index) {
    repository.loadMoreIfNeeded(index);
    notifyListeners();
  }

  Future<void> refresh(CategoryProvider catProvider) async {
    repository.resetForRefresh();
    _forcedStart = null;
    await initReels(catProvider);
  }

  /// 🎯 jab home se reel click ho
  void setStartReel(MovieModel reel) {
    _forcedStart = reel;
  }

  /// 🧠 reels screen ke liye correct order
  List<MovieModel> getOrderedReels() {
    if (_forcedStart == null) {
      return repository.visibleReels;
    }

    final list = repository.visibleReels.toList();

    // remove if already exists
    list.removeWhere((e) => e.id == _forcedStart!.id);

    // insert at top
    list.insert(0, _forcedStart!);

    return list;
  }

  /// 🧹 clear forced reel after screen closed
  void clearForcedStart() {
    _forcedStart = null;
  }
}
