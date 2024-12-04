class PromptModel {
  final String documentType;
  final List<String> requiredFieldNames;
  final String prompt;
  final String outputFieldName;

  const PromptModel({
    required this.documentType,
    required this.requiredFieldNames,
    required this.prompt,
    required this.outputFieldName,
  });

  @override
  factory PromptModel.fromJson(Map<String, dynamic> json) {
    return PromptModel(
      documentType: json['documentType'],
      requiredFieldNames: List<String>.from(json['requiredFieldNames']),
      prompt: json['prompt'],
      outputFieldName: json['outputFieldName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentType': documentType,
      'requiredFieldNames': requiredFieldNames,
      'prompt': prompt,
      'outputFieldName': outputFieldName,
    };
  }
}
