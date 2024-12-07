import 'dart:convert';

import 'package:char_creator/features/basic_chat_support/chat_bot.dart';
import 'package:char_creator/features/basic_chat_support/chat_response_model.dart';
import 'package:riverpod/riverpod.dart';

import 'chat_history_repository.dart';
import 'my_message.dart';

final chatProvider = FutureProvider<Chat>(
  (ref) async {
    final messages = await ref.watch(myChatHistoryProvider.future);
    final messagesRepository = ref.watch(chatRepositoryProvider);

    return Chat(
      chatBot: ChatBotWithMemory.fromChatHistory(messages),
      chatHistoryRepository: messagesRepository,
    );
  },
);

class Chat {
  final ChatBotWithMemory chatBot;
  final ChatHistoryRepository chatHistoryRepository;

  Chat({
    required this.chatBot,
    required this.chatHistoryRepository,
  });

  Future<void> sendUserMessage(String message) async {
    await chatHistoryRepository.saveMessage(
      MyMessage(
        text: message,
        author: MyMessageType.human,
      ),
    );
    final response = await chatBot.sendUserMessage(message);
    var parsedResponse;
    try {
      parsedResponse = ChatResponseModel.fromMap(jsonDecode(response));
    } catch (e) {
      print("Error parsing response: $e");
      parsedResponse = response;
    }
    print('responseText: $response');
    switch (parsedResponse) {
      case ChatResponseModel responseModel:
        final myMessage = MyMessage(
          text: responseModel.response,
          author: MyMessageType.bot,
          fields: responseModel.values,
        );
        await chatHistoryRepository.saveMessage(myMessage);
        break;
      default:
        final myMessage = MyMessage(
          text: parsedResponse,
          author: MyMessageType.bot,
        );
        await chatHistoryRepository.saveMessage(myMessage);
        break;
    }
  }
}
