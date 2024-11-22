import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

import '../../../secrets.dart';

class ChatBot {
  final chat = ChatOpenAI(
    apiKey: chatGPTApiKey,
    defaultOptions: const ChatOpenAIOptions(
      model: 'gpt-4o-mini',
      temperature: 0,
    ),
  );

  Future<String> sendUserMessage(String prompt) {
    final promptTemplate = ChatPromptTemplate.fromPromptMessages([
      HumanChatMessagePromptTemplate.fromTemplate(
        '{input}',
      ),
    ]);
    const stringOutputParser = StringOutputParser<ChatResult>();

    final chain = promptTemplate.pipe(chat).pipe(stringOutputParser);

    final response = chain.invoke({'input': prompt});
    return response;
  }

  Future<String> sendSystemMessage(String prompt) {
    final promptTemplate = ChatPromptTemplate.fromPromptMessages([
      SystemChatMessagePromptTemplate.fromTemplate(
        '{input}',
      ),
    ]);
    const stringOutputParser = StringOutputParser<ChatResult>();

    final chain = promptTemplate.pipe(chat).pipe(stringOutputParser);

    final response = chain.invoke({'input': prompt});
    return response;
  }

  Future<String> generateImage(String prompt) async {
    final tools = OpenAIDallETool(
      apiKey: chatGPTApiKey,
      defaultOptions: const OpenAIDallEToolOptions(
        model: 'dall-e-2',
        size: ImageSize.v256x256,
        responseFormat: ImageResponseFormat.url,
      ),
    );

    final agent = OpenAIToolsAgent.fromLLMAndTools(
      llm: chat,
      tools: [tools],
    );

    final executor = AgentExecutor(agent: agent);

    final response = await executor.run(
        "$prompt Return ONLY the URL of the image. Do not add any explanation.");

    return response;
  }
}
