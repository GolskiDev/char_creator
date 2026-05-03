import 'package:langchain/langchain.dart';
import 'package:langchain_anthropic/langchain_anthropic.dart';
import 'package:langchain_ollama/langchain_ollama.dart';
import 'package:langchain_openai/langchain_openai.dart';

import '../models/spells_config.dart';
import 'llm_client.dart';
import 'llm_provider.dart';

class _LangchainLlmClient implements LlmClient {
  final BaseChatModel _model;

  _LangchainLlmClient(this._model);

  @override
  Future<String> generate(String prompt) async {
    final response = await _model.invoke(PromptValue.string(prompt));
    return response.output.content.trim();
  }
}

LlmClient buildLlmClient(SpellsConfig config) {
  final BaseChatModel model;
  switch (config.provider) {
    case LlmProvider.openAI:
      model = ChatOpenAI(
        apiKey: config.apiKey,
        defaultOptions: ChatOpenAIOptions(model: config.model),
      );
    case LlmProvider.anthropic:
      model = ChatAnthropic(
        apiKey: config.apiKey,
        defaultOptions: ChatAnthropicOptions(model: config.model),
      );
    case LlmProvider.ollama:
      model = ChatOllama(
        baseUrl: config.baseUrl ?? 'http://localhost:11434/api',
        defaultOptions: ChatOllamaOptions(model: config.model),
      );
  }
  return _LangchainLlmClient(model);
}
