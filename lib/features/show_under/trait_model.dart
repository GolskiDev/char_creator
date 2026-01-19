class TraitModel {
  TraitModel({
    required this.id,
    required this.title,
    required this.description,
    required this.showUnder,
  });

  final String id;
  final String title;
  final String? description;
  final List<String> showUnder;

  factory TraitModel.fromMap(Map<String, dynamic> map) {
    return TraitModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      showUnder: map['showUnder'] as List<String>,
    );
  }
}
