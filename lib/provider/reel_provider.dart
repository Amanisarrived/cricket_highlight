import 'package:flutter/foundation.dart';
import '../model/moviemodel.dart';
import '../repo/reels_repo.dart';
import 'categoryprovider.dart';

class ReelsProvider with ChangeNotifier {
  final ReelsRepository repository;

  ReelsProvider({required this.repository});

  bool _isLoading = false;
  String? _error;

  List<MovieModel> get visibleReels => repository.visibleReels;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initReels(CategoryProvider catProvider) async {
    _isLoading = true;
    notifyListeners();

    try {
      await repository.initReels(catProvider: catProvider);
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
    await initReels(catProvider);
  }
}
