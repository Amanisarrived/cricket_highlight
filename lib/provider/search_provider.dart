// search_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../model/moviemodel.dart';

class SearchProvider extends ChangeNotifier {
  List<MovieModel> _results = [];
  Timer? _debounce;
  String _query = "";

  List<MovieModel> get results => _results;
  String get query => _query;

  void search(String query, List<MovieModel> allMovies) {
    _query = query;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isEmpty) {
        _results = [];
      } else {
        _results = allMovies
            .where((movie) =>
            movie.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      notifyListeners();
    });
  }

  void clear() {
    _query = "";
    _results = [];
    notifyListeners();
  }
}
