import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

import '../../secrets.dart';

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
