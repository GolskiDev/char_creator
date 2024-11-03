import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:langchain/langchain.dart';

import '../../work_in_progress/notes/note.dart';
import 'chat_bot.dart';
import 'chat_history_repository.dart';

enum MyMessageType {
  human,
  bot,
}

class MyMessage {
  final String text;
  final MyMessageType author;
  MyMessage({
    required this.text,
    required this.author,
  });
}

class MyChatWidget extends HookConsumerWidget {
  const MyChatWidget({
    required this.characterId,
    this.additionalContext,
    super.key,
  });
  final String characterId;
  final List<Note>? additionalContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = useState<List<MyMessage>>(
      ref.watch(
        myChatHistoryProviderByCharacterId(characterId),
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

    Future<void> _onSendPressed(String text) async {
      final newMessage = MyMessage(
        author: MyMessageType.human,
        text: text,
      );
      messages.value = [newMessage, ...messages.value];
      ref.read(myChatHistoryProviderByCharacterId(characterId).notifier).state =
          messages.value;
      final response = await chatBot.sendUserMessageWithContext(
        text,
        additionalContext ?? [],
      );
      final botMessage = MyMessage(
        author: MyMessageType.bot,
        text: response,
      );
      messages.value = [botMessage, ...messages.value];
      ref.read(myChatHistoryProviderByCharacterId(characterId).notifier).state =
          messages.value;
    }

    List<Widget> buildMessages(BuildContext context) => messages.value.map(
          (message) {
            Widget child = Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message.text,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );

            child = switch (message.author) {
              MyMessageType.human => Card(
                  child: child,
                ),
              MyMessageType.bot => Card.filled(
                  child: child,
                ),
            };

            final maxWidthRatio = 0.8;

            child = Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * maxWidthRatio,
              ),
              child: child,
            );

            child = switch (message.author) {
              MyMessageType.human => Align(
                  alignment: Alignment.centerRight,
                  child: child,
                ),
              MyMessageType.bot => Align(
                  alignment: Alignment.centerLeft,
                  child: child,
                ),
            };

            return child;
          },
        ).toList();

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            reverse: true,
            children: buildMessages(context),
          ),
        ),
        Card.outlined(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (text) {
                _onSendPressed(text);
              },
            ),
          ),
        ),
      ],
    );
  }
}
