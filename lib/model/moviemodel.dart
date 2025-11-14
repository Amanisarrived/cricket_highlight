class CategoryModel {
  final int id;
  final String name;
  final String thumbnail;
  final List<MovieModel> movies;
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.movies,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      movies: (json['movies'] as List<dynamic>?)
          ?.map((e) => MovieModel.fromJson(e))
          .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'movies': movies.map((m) => m.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class MovieModel {
  final int id;
  final String name;
  final String url;
  final bool isTrending;
  final DateTime createdAt;

  MovieModel({
    required this.id,
    required this.name,
    required this.url,
    required this.isTrending,
    required this.createdAt,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      isTrending: json['is_trending'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'is_trending': isTrending,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
