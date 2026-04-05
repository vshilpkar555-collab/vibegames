class BlockModel {
  final String type;        // games / categories
  final List<String> ids;

  BlockModel({required this.type, required this.ids});

  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
      type: json['type'],
      ids: List<String>.from(json['ids']),
    );
  }
}
