import 'package:char_creator/features/basic_chat_support/chat_bots/chat_bot.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

import '../../../secrets.dart';
import '../../notes/note.dart';

class ChatBotWithMemory implements ChatBot {
  @override
  final chat = ChatOpenAI(apiKey: chatGPTApiKey);
  final ConversationBufferMemory memory;

  ChatBotWithMemory(this.memory);

  @override
  Future<String> sendUserMessage(String prompt) async {
    final promptTemplate = ChatPromptTemplate.fromPromptMessages(
      [
        const MessagesPlaceholder(variableName: 'history'),
        HumanChatMessagePromptTemplate.fromTemplate(
          '{input}',
        ),
      ],
    );

    const stringOutputParser = StringOutputParser<ChatResult>();

    final chain = Runnable.fromMap({
          'input': Runnable.passthrough(),
          'history': Runnable.mapInput(
            (_) async {
              final m = await memory.loadMemoryVariables();
              return m['history'];
            },
          ),
        }) |
        promptTemplate |
        chat |
        stringOutputParser;

    final response = await chain.invoke({'input': prompt}) as String;

    await memory.saveContext(
      inputValues: {'input': prompt},
      outputValues: {'output': response},
    );

    return response;
  }

  Future<String> sendUserMessageWithContext(
    String prompt,
    List<Note> someContext,
  ) async {
    final promptTemplate = ChatPromptTemplate.fromPromptMessages(
      [
        const MessagesPlaceholder(variableName: 'history'),
        HumanChatMessagePromptTemplate.fromTemplate(
          '{input}',
        ),
      ],
    );

    const stringOutputParser = StringOutputParser<ChatResult>();

    final chain = Runnable.fromMap({
          'input': Runnable.passthrough(),
          'history': Runnable.mapInput(
            (_) async {
              final m = await memory.loadMemoryVariables();
              return m['history'];
            },
          ),
        }) |
        promptTemplate |
        chat |
        stringOutputParser;

    final inputWithContext =
        "$prompt context: ${someContext.map((note) => note.value).join("\n")}";

    final response = await chain.invoke({
      'input': inputWithContext,
    }) as String;

    await memory.saveContext(
      inputValues: {'input': inputWithContext},
      outputValues: {'output': response},
    );

    return response;
  }

  @override
  Future<String> sendSystemMessage(String prompt) async {
    final promptTemplate = ChatPromptTemplate.fromPromptMessages([
      const MessagesPlaceholder(variableName: 'history'),
      SystemChatMessagePromptTemplate.fromTemplate(
        '{input}',
      ),
    ]);

    const stringOutputParser = StringOutputParser<ChatResult>();

    final chain = Runnable.fromMap({
          'input': Runnable.passthrough(),
          'history': Runnable.mapInput(
            (_) async {
              final m = await memory.loadMemoryVariables();
              return m['history'];
            },
          ),
        }) |
        promptTemplate |
        chat |
        stringOutputParser;

    final response = await chain.invoke({'input': prompt}) as String;

    await memory.saveContext(
      inputValues: {'input': prompt},
      outputValues: {'output': response},
    );

    return response;
  }

  @override
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
