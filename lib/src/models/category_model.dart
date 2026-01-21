class CategoryModel {
  final String id;
  final String name;
  final String thumbnail;
  final String color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.color,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      thumbnail: json['thumbnail'],
      color: json['color'],
    );
  }
}
