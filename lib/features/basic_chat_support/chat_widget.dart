import 'package:char_creator/features/basic_chat_support/chat_bot.dart';
import 'package:char_creator/features/basic_chat_support/chat_utils.dart';
import 'package:char_creator/work_in_progress/views/list_of_notes_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chatTypes;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:langchain/langchain.dart';

import 'chat_history_repository.dart';

class ChatWidget extends HookConsumerWidget {
  const ChatWidget({
    required this.characterId,
    super.key,
  });
  final String characterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final someContext = ref.watch(selectedNotesProvider);
    final messages = useState<List<chatTypes.Message>>(
      ref.watch(
        chatHistoryProviderByCharacterId(characterId),
      ),
    );
    final chatBot = useMemoized(
      () => ChatBotWithMemory(
        ConversationBufferMemory(
          chatHistory: ChatMessageHistory(
            messages: messages.value.mapIndexed((index, message) {
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
      ),
    );

    Future<void> _onSendPressed(chatTypes.PartialText message) async {
      final newMessage = chatTypes.TextMessage(
        author: ChatUtils.chatUser,
        id: messages.value.length.toString(),
        text: message.text,
      );
      messages.value = [newMessage, ...messages.value];
      ref.read(chatHistoryProviderByCharacterId(characterId).notifier).state =
          messages.value;
      final response = await chatBot.sendUserMessageWithContext(
        message.text,
        someContext,
      );
      final botMessage = chatTypes.TextMessage(
        author: ChatUtils.botUser,
        id: messages.value.length.toString(),
        text: response,
      );
      messages.value = [botMessage, ...messages.value];
      ref.read(chatHistoryProviderByCharacterId(characterId).notifier).state =
          messages.value;
    }

    return Chat(
      messages: messages.value,
      onSendPressed: _onSendPressed,
      user: ChatUtils.chatUser,
      textMessageBuilder: (p0, {required messageWidth, required showName}) {
        return Container(
          padding: EdgeInsets.all(8),
          child: Text(
            p0.text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      },
    );
  }
}
