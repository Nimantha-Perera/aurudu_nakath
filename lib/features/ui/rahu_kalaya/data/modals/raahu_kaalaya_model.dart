class RaahuKaalayaModel {
  final String dawasa;
  final String welawa;

  RaahuKaalayaModel({required this.dawasa, required this.welawa});

  factory RaahuKaalayaModel.fromMap(Map<dynamic, dynamic> map) {
    return RaahuKaalayaModel(
      dawasa: map['dawasa'] ?? '',
      welawa: map['welawa'] ?? '',
    );
  }
}
