import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

import '../../secrets.dart';

class LC {
  final chat = ChatOpenAI(apiKey: chatGPTApiKey);

  Future<String> responseStream(String prompt) {
    final promptTemplate = ChatPromptTemplate.fromPromptMessages([
      HumanChatMessagePromptTemplate.fromTemplate(
        '{input}',
      ),
    ]);
    const stringOutputParser = StringOutputParser<ChatResult>();

    final chain = promptTemplate.pipe(chat).pipe(stringOutputParser);

    final stream = chain.invoke({'input': prompt});
    return stream;
  }
}
