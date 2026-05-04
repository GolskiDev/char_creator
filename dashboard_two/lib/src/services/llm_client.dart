/// Internal abstraction over any LLM backend.
/// Tests can substitute a fake without pulling in langchain.
abstract class LlmClient {
  Future<String> generate(String prompt);
}
