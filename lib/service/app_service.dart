import 'package:cricket_highlight/model/moviemodel.dart';
import 'package:dio/dio.dart';

import '../model/simplecategory.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://cricket.kritishmovie.xyz/api/",
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
    ),
  );

  /// Cache raw movie JSON data for category filtering
  List<Map<String, dynamic>> _cachedRawMovies = [];

  /// Fetch all categories
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await _dio.get("categories");

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data["categories"] != null) {
          return (data["categories"] as List)
              .map((e) => CategoryModel.fromJson(e))
              .toList();
        } else {
          throw Exception("Invalid data format from server.");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception("Something went wrong: ${e.toString()}");
    }
  }

  /// Fetch all movies
  Future<List<MovieModel>> fetchMovies() async {
    try {
      final response = await _dio.get("movies");

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data["movies"] != null) {
          final moviesList = (data["movies"] as List);

          // Cache raw JSON for category-based filtering later
          _cachedRawMovies =
          List<Map<String, dynamic>>.from(moviesList.map((e) => Map<String, dynamic>.from(e)));

          // Convert to MovieModel
          return moviesList.map((e) => MovieModel.fromJson(e)).toList();
        } else {
          throw Exception("Invalid data format from server.");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception("Something went wrong: ${e.toString()}");
    }
  }

  /// ✅ Get movies by category ID (filtered locally)
  List<MovieModel> getMoviesByCategoryId(int categoryId) {
    final filtered = _cachedRawMovies.where((movie) {
      final categories = movie['categories'] as List?;
      if (categories == null) return false;
      return categories.any((cat) => cat['id'] == categoryId);
    }).toList();

    return filtered.map((m) => MovieModel.fromJson(m)).toList();
  }

  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return "Connection timeout. Please check your internet.";
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return "Server took too long to respond.";
    } else if (e.type == DioExceptionType.badResponse) {
      return "Received invalid response from server.";
    } else if (e.type == DioExceptionType.connectionError) {
      return "No internet connection.";
    } else {
      return "Unexpected error: ${e.message}";
    }
  }

  Future<List<SimpleCategory>> fetchSimpleCategories() async {
    try {
      final response = await _dio.get("categories");

      if (response.statusCode == 200) {
        final data = response.data;
        final List categories = data["categories"];

        return categories
            .map((json) => SimpleCategory.fromJson(json))
            .toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching simple categories: $e");
    }
  }


}
