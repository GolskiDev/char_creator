import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

import '../../secrets.dart';
import 'my_message.dart';

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
    final promptTemplate = ChatPromptTemplate.fromPromptMessages(
      [
        SystemChatMessagePromptTemplate.fromTemplate(
          '{input}',
        ),
      ],
    );
    const stringOutputParser = StringOutputParser<ChatResult>();

    final chain = promptTemplate.pipe(chat).pipe(stringOutputParser);

    final response = chain.invoke({'input': prompt});
    return response;
  }
}

class ChatBotWithMemory implements ChatBot {
  @override
  final chat = ChatOpenAI(
    apiKey: chatGPTApiKey,
    defaultOptions: const ChatOpenAIOptions(
      model: 'gpt-4-turbo',
    ),
  );
  final ConversationBufferMemory memory;

  ChatBotWithMemory(this.memory);

  factory ChatBotWithMemory.fromChatHistory(List<MyMessage> messages) {
    return ChatBotWithMemory(
      ConversationBufferMemory(
        chatHistory: ChatMessageHistory(
          messages: messages.map(
            (message) {
              switch (message.author) {
                case MyMessageType.human:
                  return ChatMessage.humanText(
                    message.text,
                  );
                case MyMessageType.bot:
                  return ChatMessage.ai(
                    message.text,
                  );
              }
            },
          ).toList(),
        ),
        returnMessages: true,
      ),
    );
  }

  @override
  Future<String> sendUserMessage(String prompt) async {
    final promptTemplate = ChatPromptTemplate.fromPromptMessages(
      [
        const MessagesPlaceholder(variableName: 'history'),
        HumanChatMessagePromptTemplate.fromTemplate(
          '''
{input}
Return all the details for user to see in "textMessage".
    Return all additional values in "values" array.
    This is request from application
    Return JSON only. Don't add extra text.
    Don't add extra ',' and escape special characters:
    {
      "textMessage": "String",
      "values": [
        {
          "value", "value",
          "fieldName": "specifiedFieldName"
        }
      ],
    }
    Return JSON in a format above. 
          ''',
        ),
      ],
    );

    const stringOutputParser = StringOutputParser<ChatResult>();

    final chain = Runnable.fromMap(
      {
        'input': Runnable.passthrough(),
        'history': Runnable.mapInput(
          (_) async {
            final m = await memory.loadMemoryVariables();
            return m['history'];
          },
        ),
      },
    ).pipe(promptTemplate).pipe(chat).pipe(stringOutputParser);

    final response = await chain.invoke({'input': prompt});

    await memory.saveContext(
      inputValues: {'input': prompt},
      outputValues: {'output': response},
    );

    return response;
  }

  Future<String> generateImage(String prompt) async {
    final tools = <Tool>[
      OpenAIDallETool(
        apiKey: chatGPTApiKey,
        defaultOptions: const OpenAIDallEToolOptions(
          model: 'dall-e-2',
          size: ImageSize.v256x256,
          quality: ImageQuality.standard,
          responseFormat: ImageResponseFormat.url,
        ),
      ),
    ];
    final agent = OpenAIToolsAgent.fromLLMAndTools(
      llm: chat,
      tools: tools,
    );
    final executor = AgentExecutor(agent: agent);
    final res = await executor.run(
      prompt,
    );
    return res;
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
