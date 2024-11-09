import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

import '../../secrets.dart';
import '../notes/note.dart';

class ChatBot {
  final chat = ChatOpenAI(apiKey: chatGPTApiKey);

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
}

class ChatBotWithMemory implements ChatBot {
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
}
