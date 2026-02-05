import 'package:cricket_highlight/model/simplecategory.dart';
import 'package:flutter/foundation.dart';
import 'package:cricket_highlight/model/moviemodel.dart';
import '../service/app_service.dart';
import 'dart:math';

class CategoryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<CategoryModel> _categories = [];
  List<SimpleCategory> _simplecategories = [];
  List<MovieModel> _movies = [];

  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastFetchedTime;
  MovieModel? _randomMovie;
  MovieModel? get randomMovie => _randomMovie;


  static const cacheDuration = Duration(minutes: 30);

  List<CategoryModel> get categories => _categories;
  List<MovieModel> get movies => _movies;
  List<SimpleCategory> get simplecategories => _simplecategories;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isMoviesStale {
    if (_movies.isEmpty) return true;
    if (_lastFetchedTime == null) return true;
    return DateTime.now().difference(_lastFetchedTime!) > cacheDuration;
  }

  Future<void> loadCategories({bool forceRefresh = false}) async {
    if (_categories.isNotEmpty && !forceRefresh && !_shouldRefetch()) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _apiService.fetchCategories();
      _lastFetchedTime = DateTime.now();
    } catch (e) {
      _errorMessage = "Unable to load categories. Please try again later.";
      if (kDebugMode) print("CategoryProvider (Categories) Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMovies({bool forceRefresh = false}) async {
    if (_movies.isNotEmpty && !forceRefresh && !_shouldRefetch()) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _movies = await _apiService.fetchMovies();
      _lastFetchedTime = DateTime.now();
    } catch (e) {
      _errorMessage = "Unable to load movies. Please try again later.";
      if (kDebugMode) print("CategoryProvider (Movies) Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _shouldRefetch() {
    if (_lastFetchedTime == null) return true;
    return DateTime.now().difference(_lastFetchedTime!) > cacheDuration;
  }

  CategoryModel? getCategoryByName(String categoryName) {
    try {
      return _categories.firstWhere(
        (cat) => cat.name.toLowerCase() == categoryName.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  List<MovieModel> getTrendingMovies() {
    return _movies.where((m) => m.isTrending).toList();
  }

  List<MovieModel> getMoviesByCategoryId(int categoryId) {
    return _apiService.getMoviesByCategoryId(categoryId);
  }

  List<MovieModel> getRandomMovies({int count = 10}) {
    final random = Random();

    final availableMovies = _movies.where((movie) {
      final categories = movie.categoryIds ?? [];
      return !categories.contains(45);
    }).toList();

    availableMovies.shuffle(random);
    return availableMovies.take(count).toList();
  }


  List<MovieModel> searchMovies(String query) {
    if (query.isEmpty) return _movies;

    final lowerQuery = query.toLowerCase();
    return _movies
        .where((movie) => movie.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  Future<List<MovieModel>> getReels({bool refresh = false}) async {
    if (_movies.isEmpty || isMoviesStale || refresh) {
      await loadMovies(forceRefresh: true);
    }


    final reels = _movies.where((movie) {
      final categories = movie.categoryIds ?? [];
      return categories.contains(45);
    }).toList();

    debugPrint("CategoryProvider: getReels -> fetched ${reels.length} items");

    return reels;
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _simplecategories = await _apiService.fetchSimpleCategories();
      if (categories.isEmpty) {
        _errorMessage = "No categories found";
      } else {
        _errorMessage = null;
      }
    } catch (e) {
     _errorMessage = e.toString();
    }

   _isLoading = false;
    notifyListeners();
  }
}
