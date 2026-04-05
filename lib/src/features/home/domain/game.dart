class Game {
  final String id;
  final String title;
  final String type; // "local" or "web"
  final String? thumbnail;
  final String? route;
  final String? webUrl;

  Game({
    required this.id,
    required this.title,
    required this.type,
    this.thumbnail,
    this.route,
    this.webUrl,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      thumbnail: json['thumbnail'] as String?,
      route: json['route'] as String?,
      webUrl: json['web_url'] as String? ?? json['webUrl'] as String?,
    );
  }
}
