import 'dart:convert';

import 'package:char_creator/features/basic_chat_support/chat_bot.dart';
import 'package:char_creator/features/basic_chat_support/chat_response_model.dart';
import 'package:char_creator/features/images/image_use_cases.dart';
import 'package:char_creator/features/images/images_repostitory.dart';
import 'package:riverpod/riverpod.dart';

import '../images/image_providers.dart';
import 'chat_history_repository.dart';
import 'my_message.dart';

final chatProvider = FutureProvider<Chat>(
  (ref) async {
    final messages = await ref.watch(myChatHistoryProvider.future);
    final messagesRepository = ref.watch(chatRepositoryProvider);
    final ImageRepository imageRepository =
        await ref.watch(imageRepositoryProvider.future);

    return Chat(
      chatBot: ChatBotWithMemory.fromChatHistory(messages),
      chatHistoryRepository: messagesRepository,
      imageRepository: imageRepository,
    );
  },
);

class Chat {
  final ChatBotWithMemory chatBot;
  final ChatHistoryRepository chatHistoryRepository;
  final ImageRepository imageRepository;

  Chat({
    required this.chatBot,
    required this.chatHistoryRepository,
    required this.imageRepository,
  });

  Future<void> sendUserMessage(String message) async {
    await chatHistoryRepository.saveMessage(
      MyMessage(
        text: message,
        author: MyMessageType.human,
      ),
    );
    final response = await chatBot.sendUserMessage(message);

    await _saveResponse(response);
  }

  Future<void> askForImage(String message) async {
    await chatHistoryRepository.saveMessage(
      MyMessage(
        text: message,
        author: MyMessageType.human,
      ),
    );
    final response = await chatBot.generateImage(message);

    await _saveResponse(response);
  }

  _saveResponse(String response) async {
    dynamic parsedResponse;
    try {
      parsedResponse = ChatResponseModel.fromMap(jsonDecode(response));
    } catch (e) {
      parsedResponse = response;
    }
    switch (parsedResponse) {
      case ChatResponseModel responseModel:
        final String? imageId;
        if (responseModel.imageUrl != null &&
            responseModel.imageUrl!.isNotEmpty) {
          final imageModel = await ImageUseCases.saveImageFromUrl(
            imageRepository,
            responseModel.imageUrl!,
          );
          imageId = imageModel.id;
        } else {
          imageId = null;
        }
        final myMessage = MyMessage(
          text: responseModel.response,
          author: MyMessageType.bot,
          fields: responseModel.values,
          imageId: imageId,
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
