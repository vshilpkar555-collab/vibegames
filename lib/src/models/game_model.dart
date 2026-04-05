class GameModel {
  final String id;
  final String name;
  final String categoryId;
  final List<String> hashtags;
  final String thumbnail;
  final String type;
  final String? webUrl;
  final String? route;
  final String? videoUrl;

  GameModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.hashtags,
    required this.thumbnail,
    required this.type,
    this.webUrl,
    this.route,
    this.videoUrl,
  });


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'hashtags': hashtags,
      'thumbnail': thumbnail,
      'type': type,
      'web_url': webUrl,
      'route': route,
      'video_url': videoUrl,
    };
  }

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      hashtags: List<String>.from(json['hashtags'] ?? []),
      thumbnail: json['thumbnail'],
      type: json['type'],
      webUrl: json['web_url'],
      route: json['route'],
      videoUrl: json['video_url'],   // NEW
    );
  }
}
