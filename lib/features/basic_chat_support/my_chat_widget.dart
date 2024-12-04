import 'package:char_creator/features/basic_chat_support/chat_providers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:langchain/langchain.dart';

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
    required this.documentId,
    super.key,
  });
  final String? documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(myChatHistoryProvider);
    final chatBot = ref.watch(chatBotProvider);

    Future<void> _onSendPressed(String text) async {
      List<MyMessage> updatedMessages =
          ref.read(myChatHistoryProvider.notifier).state;
      final newMessage = MyMessage(
        author: MyMessageType.human,
        text: text,
      );
      updatedMessages = [newMessage, ...messages];
      ref.read(myChatHistoryProvider.notifier).state = messages;
      final response = await chatBot.sendUserMessage(
        text,
      );
      final botMessage = MyMessage(
        author: MyMessageType.bot,
        text: response,
      );
      updatedMessages = [botMessage, ...messages];
      ref.read(myChatHistoryProvider.notifier).state = messages;
    }

    List<Widget> buildMessages(BuildContext context) => messages.map(
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
                  _onSendPressed(text);
                  controller.clear();
                },
                decoration: InputDecoration(
                  hintText: 'You can type here',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      _onSendPressed(controller.text);
                      controller.clear();
                    },
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
