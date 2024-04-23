class PromptModel {
  final String prompt;
  final String id;

  PromptModel({
    required this.prompt,
    required this.id,
  });

  factory PromptModel.fromJson(Map<String, dynamic> json) {
    return PromptModel(
      prompt: json['prompt'],
      id: json['id'],
    );
  }
}
