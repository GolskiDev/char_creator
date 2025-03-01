class Open5eSpellModel {
  final String name;
  final String description;
  final String slug;

  Open5eSpellModel({
    required this.slug,
    required this.name,
    required this.description,
  });

  factory Open5eSpellModel.fromJson(Map<String, dynamic> json) {
    return Open5eSpellModel(
      slug: json['slug'],
      name: json['name'],
      description: json['desc'],
    );
  }
}