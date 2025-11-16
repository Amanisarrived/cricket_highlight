class SimpleCategory {
  final String name;
  final String thumbnail;

  SimpleCategory({
    required this.name,
    required this.thumbnail,
  });

  factory SimpleCategory.fromJson(Map<String, dynamic> json) {
    return SimpleCategory(
      name: json['name'],
      thumbnail: json['thumbnail'],
    );
  }
}
