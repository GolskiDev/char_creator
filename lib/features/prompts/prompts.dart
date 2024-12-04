class Prompts {
  static final List<Map<String, dynamic>> prompts = [
    {
      'documentType': 'character',
      'requiredFieldNames': ['class', 'race'],
      'displayedPrompt':
          '''Generate names for my character based on my {class} and {race}''',
      'prompt':
          'Generate name for my character based on my {class} and {race}. Show me why you think this name is good, and from which culture or word it comes from.',
      'outputFieldName': 'name',
    },
    {
      'documentType': 'character',
      'requiredFieldNames': ['class', 'race'],
      'displayedPrompt':
          '''Generate names for my character based on my {class} and {race}''',
      'prompt':
          'Generate 10 names for my character based on my {class} and {race}. Show me why you think this name is good, and from which culture or word it comes from.',
      'outputFieldName': 'name',
    },
  ];
}
