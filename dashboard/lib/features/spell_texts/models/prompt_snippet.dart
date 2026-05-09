class PromptSnippet {
  final String id;

  /// The name used in {{snippet:name}} references.
  /// Must match [a-z0-9_-]+.
  final String name;

  final String content;
  final DateTime createdAt;

  const PromptSnippet({
    required this.id,
    required this.name,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PromptSnippet.fromJson(Map<String, dynamic> json) => PromptSnippet(
        id: json['id'] as String,
        name: json['name'] as String,
        content: json['content'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  /// First 60 chars of content for display in lists.
  String get preview {
    final first = content.split('\n').first.trim();
    return first.length > 60 ? '${first.substring(0, 59)}…' : first;
  }

  /// Validates that [name] contains only lowercase letters, digits, underscores, hyphens.
  static bool isValidName(String name) =>
      name.isNotEmpty && RegExp(r'^[a-z0-9_-]+$').hasMatch(name);
}
