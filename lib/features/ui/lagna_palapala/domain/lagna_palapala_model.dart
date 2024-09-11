class LagnaPalapalaModel {
  final String name;
  final String message;
  final String aya;
  final String waya;
  final String imageUrl;
  final String color;

  LagnaPalapalaModel({
    required this.name,
    required this.message,
    required this.aya,
    required this.waya,
    required this.imageUrl,
    required this.color,
  });

  factory LagnaPalapalaModel.fromMap(Map<dynamic, dynamic> map) {
    return LagnaPalapalaModel(
      name: map['name'] ?? '',
      message: map['message'] ?? '',
      aya: map['aya'] ?? '',
      waya: map['waya'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      color: map['color'] ?? '#FFFFFF',
    );
  }
}
