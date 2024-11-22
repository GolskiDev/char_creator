import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notes/note.dart';
import 'chat_bots/chat_bot.dart';
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
      () => ChatBot(),
      // () => ChatBotWithMemory(
      //   ConversationBufferMemory(
      //     chatHistory: ChatMessageHistory(
      //       messages: messages.value.mapIndexed((index, message) {
      //         if (index % 2 == 1) {
      //           return ChatMessage.human(
      //               ChatMessageContent.text(message.toString()));
      //         } else {
      //           return ChatMessage.ai(message.toString());
      //         }
      //       }).toList(),
      //     ),
      //     returnMessages: true,
      //   ),
      // ),
    );

    Future<void> onSendPressed(String text) async {
      final newMessage = MyMessage(
        author: MyMessageType.human,
        text: text,
      );
      messages.value = [newMessage, ...messages.value];
      ref.read(myChatHistoryProviderByCharacterId(characterId).notifier).state =
          messages.value;
      final response = await chatBot.sendUserMessage(
        text,
        // additionalContext ?? [],
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

    final controller = useTextEditingController();

    final currentMessage = useState<String?>(null);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              shrinkWrap: true,
              reverse: true,
              children: buildMessages(context),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                onSubmitted: (text) {
                  onSendPressed(text);
                  controller.clear();
                },
                onChanged: (text) {
                  currentMessage.value = text;
                },
                decoration: InputDecoration(
                  hintText: 'You can type here',
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GenerateImageButton(
                        prompt: currentMessage.value ?? '',
                        chatBot: chatBot,
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          onSendPressed(controller.text);
                          controller.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GenerateImageButton extends StatelessWidget {
  const GenerateImageButton({
    required this.prompt,
    required this.chatBot,
    super.key,
  });
  final String prompt;
  final ChatBot chatBot;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.image),
      onPressed: () async {
        final response = await chatBot.generateImage(prompt);
        if (!context.mounted) {
          return;
        }
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Image.network(response),
            );
          },
        );
      },
    );
  }
}
