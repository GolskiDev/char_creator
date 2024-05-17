import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

import '../../secrets.dart';

class LC {
  final chat = ChatOpenAI(apiKey: chatGPTApiKey);

  Future<String> promptChat(String prompt) {
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

  Future<Map<String, dynamic>> askChatForJson(String prompt) {
    final promptTemplate = ChatPromptTemplate.fromPromptMessages([
      HumanChatMessagePromptTemplate.fromTemplate(
        '{input}',
      ),
    ]);
    final jsonOutputParser = JsonOutputParser<ChatResult>();

    final chain = promptTemplate.pipe(chat).pipe(jsonOutputParser);

    final response = chain.invoke({'input': prompt});
    return response;
  }

  Future<Map<String, dynamic>> askChatForJsonWithInstructions(String prompt) {
    final promptTemplate = ChatPromptTemplate.fromPromptMessages([
      HumanChatMessagePromptTemplate.fromTemplate(
        '''
        Answer this question:
        {input}

        If user wants to get information about a return it in like this:
        {
          "trait": {
            "traitKey": //Any of:
              name
              race
              characterClass
              skills
              equipment
              alignment
              personalityTraits
              ideals
              bonds
              flaws
              appearance
              alliesAndOrganizations
              treasure
              characterHistory
            "traitValue": value
          },
          "message": Message to user
        }

        Do not return multiple trait at once.
        If user asks for multiple just return one. and tell him in message that you can only return one at a time.
        ''',
      ),
    ]);
    final jsonOutputParser = JsonOutputParser<ChatResult>();

    final chain = promptTemplate.pipe(chat).pipe(jsonOutputParser);

    final response = chain.invoke({'input': prompt});
    return response;
  }
}
