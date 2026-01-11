import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../model/news_model.dart';

part 'hive_news_model.g.dart';

@HiveType(typeId: 1)
class Newsmodel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String credits;

  @HiveField(5)
  final String url;

  @HiveField(6)
  final DateTime createdAt;

  Newsmodel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.credits,
    required this.url,
    required this.createdAt,
  });

  factory Newsmodel.fromApi(NewsModel model) {
    return Newsmodel(
      id: model.id.isNotEmpty ? model.id : const Uuid().v4(),
      title: model.title,
      imageUrl: model.imageUrl,
      description: model.description,
      credits: model.credits,
      url: model.url,
      createdAt: model.createdAt, // 🔥 yahi missing tha
    );
  }
}
