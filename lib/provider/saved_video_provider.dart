import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:cricket_highlight/model/hive_movie_model.dart';

class SavedVideosProvider extends ChangeNotifier {
  static const String _boxName = 'saved_videos';
  late Box<HiveMovieModel> _savedVideosBox;
  bool _initialized = false;

  /// ✅ Initialize Hive box (only once)
  Future<void> init() async {
    if (_initialized) return;
    _savedVideosBox = await Hive.openBox<HiveMovieModel>(_boxName);
    _initialized = true;
  }

  /// ✅ Toggle save/remove
  Future<void> toggleSave(HiveMovieModel movie) async {
    await init();

    if (_savedVideosBox.containsKey(movie.id)) {
      await _savedVideosBox.delete(movie.id);
    } else {
      await _savedVideosBox.put(movie.id, movie);
    }

    notifyListeners();
  }

  /// ✅ Check if video is saved (synchronous now)
  bool isSaved(int id) {
    if (!_initialized) return false;
    return _savedVideosBox.containsKey(id);
  }

  /// ✅ Get all saved videos
  List<HiveMovieModel> get savedVideos {
    if (!_initialized) return [];
    return _savedVideosBox.values.toList();
  }

  /// ✅ Remove specific video
  Future<void> removeSaved(int id) async {
    await init();
    await _savedVideosBox.delete(id);
    notifyListeners();
  }

  /// ✅ Clear all saved videos
  Future<void> clearAll() async {
    await init();
    await _savedVideosBox.clear();
    notifyListeners();
  }

  /// ✅ Close box safely (on logout, etc.)
  Future<void> closeBox() async {
    if (_initialized) {
      await _savedVideosBox.close();
      _initialized = false;
    }
  }
}
