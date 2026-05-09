import 'package:langchain/langchain.dart';
import 'package:langchain_anthropic/langchain_anthropic.dart';
import 'package:langchain_ollama/langchain_ollama.dart';
import 'package:langchain_openai/langchain_openai.dart';

import '../models/spells_config.dart';
import 'llm_client.dart';
import 'llm_provider.dart';

class _LangchainLlmClient implements LlmClient {
  final SpellsConfig _config;

  _LangchainLlmClient(this._config);

  /// Builds a fresh model instance with the given temperature.
  /// [temperature] is passed directly to the provider API — use the
  /// provider's native scale (0.0–2.0 for OpenAI, 0.0–1.0 for others).
  BaseChatModel _buildModel(double temperature) {
    final apiTemp = temperature;
    switch (_config.provider) {
      case LlmProvider.openAI:
        return ChatOpenAI(
          apiKey: _config.apiKey,
          defaultOptions: ChatOpenAIOptions(
            model: _config.model,
            temperature: apiTemp,
          ),
        );
      case LlmProvider.anthropic:
        return ChatAnthropic(
          apiKey: _config.apiKey,
          defaultOptions: ChatAnthropicOptions(
            model: _config.model,
            temperature: apiTemp,
          ),
        );
      case LlmProvider.ollama:
        return ChatOllama(
          baseUrl: _config.baseUrl ?? 'http://localhost:11434/api',
          defaultOptions: ChatOllamaOptions(
            model: _config.model,
            temperature: apiTemp,
          ),
        );
    }
  }

  @override
  Future<String> generate(String prompt, {double temperature = 1.0}) async {
    final model = _buildModel(temperature);
    final response = await model.invoke(PromptValue.string(prompt));
    return response.output.content.trim();
  }
}

LlmClient buildLlmClient(SpellsConfig config) =>
    _LangchainLlmClient(config);
