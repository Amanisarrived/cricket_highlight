import 'package:hive/hive.dart';
import 'package:cricket_highlight/model/moviemodel.dart';

part 'hive_movie_model.g.dart';

@HiveType(typeId: 0)
class HiveMovieModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String url;

  @HiveField(3)
  final bool isTrending;

  @HiveField(4)
  final DateTime createdAt;

  HiveMovieModel({
    required this.id,
    required this.name,
    required this.url,
    required this.isTrending,
    required this.createdAt,
  });

  /// 🔁 Convert MovieModel → HiveMovieModel
  factory HiveMovieModel.fromMovie(MovieModel movie) {
    return HiveMovieModel(
      id: movie.id,
      name: movie.name,
      url: movie.url,
      isTrending: movie.isTrending,
      createdAt: movie.createdAt,
    );
  }

  /// 🔁 Convert HiveMovieModel → MovieModel
  MovieModel toMovieModel() {
    return MovieModel(
      id: id,
      name: name,
      url: url,
      isTrending: isTrending,
      createdAt: createdAt,
    );
  }
}
