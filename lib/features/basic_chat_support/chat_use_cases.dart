import 'package:char_creator/features/basic_chat_support/chat_bot.dart';

class ChatUseCases {
  static Future<String> getChatResponse(String message) async {
    ChatBot chatBot = ChatBot();
    final response = chatBot.sendUserMessage(message);
    return response;
  }
}
