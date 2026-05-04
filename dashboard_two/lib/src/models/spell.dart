class Spell {
  final String id;
  final String title;
  final String description;

  /// Absolute file path or Flutter asset path to the spell image. Null if no image.
  final String? imagePath;

  const Spell({
    required this.id,
    required this.title,
    required this.description,
    this.imagePath,
  });
}
