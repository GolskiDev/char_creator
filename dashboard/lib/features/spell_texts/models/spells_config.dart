import '../services/llm_provider.dart';

class SpellsConfig {
  final LlmProvider provider;

  /// API key for the chosen provider. Leave empty for Ollama.
  final String apiKey;

  /// Model identifier, e.g. 'claude-3-haiku-20240307', 'gpt-4o-mini', 'llama3'.
  final String model;

  /// Optional base URL override (required for Ollama, optional for custom endpoints).
  final String? baseUrl;

  const SpellsConfig({
    required this.provider,
    required this.apiKey,
    required this.model,
    this.baseUrl,
  });
}
