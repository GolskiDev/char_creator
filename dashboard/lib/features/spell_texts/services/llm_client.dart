/// Internal abstraction over any LLM backend.
/// Tests can substitute a fake without pulling in langchain.
abstract class LlmClient {
  /// [temperature] controls output randomness (0.0 = deterministic, 1.0 = most varied).
  Future<String> generate(String prompt, {double temperature = 1.0});
}
