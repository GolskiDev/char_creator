import 'package:char_creator/features/basic_chat_support/chat_history_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:langchain/langchain.dart';

import 'chat_bot.dart';

final chatBotProvider = Provider(
  (ref) {
    final messages = ref.watch(myChatHistoryProvider);
    return ChatBotWithMemory(
      ConversationBufferMemory(
        chatHistory: ChatMessageHistory(
          messages: messages.mapIndexed((index, message) {
            if (index % 2 == 1) {
              return ChatMessage.human(
                  ChatMessageContent.text(message.toString()));
            } else {
              return ChatMessage.ai(message.toString());
            }
          }).toList(),
        ),
        returnMessages: true,
      ),
    );
  },
);
