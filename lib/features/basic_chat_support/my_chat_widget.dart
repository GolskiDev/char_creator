import 'package:char_creator/features/basic_chat_support/chat.dart';
import 'package:char_creator/features/basic_chat_support/my_message_widget.dart';
import 'package:char_creator/features/chat_context/chat_context_providers.dart';
import 'package:char_creator/features/documents/document_providers.dart';
import 'package:char_creator/features/prompts/prompt_use_cases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'chat_history_repository.dart';
import 'my_message.dart';

class MyChatWidget extends HookConsumerWidget {
  const MyChatWidget({
    required this.documentId,
    super.key,
  });
  final String? documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatAsync = ref.watch(chatProvider).asData?.value;
    final messages = ref.watch(myChatHistoryProvider).asData?.value ?? [];

    Future<void> onSendPressed(String text) async {
      final String message;
      final isChatContextEnabled = ref.read(isChatContextEnabledProvider);
      if (isChatContextEnabled) {
        final chatContext = ref.read(chatContextProvider);
        final documents = await ref.read(documentsProvider.future);
        message = '$text \n\n${chatContext.toChatContextString(documents)}';
      } else {
        message = text;
      }
      chatAsync?.sendUserMessage(
        message: message,
        displayedMessage: text,
      );
    }

    Future<void> onGenerateImagePressed(String text) async {
      final String message;
      final isChatContextEnabled = ref.read(isChatContextEnabledProvider);
      if (isChatContextEnabled) {
        final chatContext = ref.read(chatContextProvider);
        final documents = await ref.read(documentsProvider.future);
        message = '$text \n\n${chatContext.toChatContextString(documents)}';
      } else {
        message = text;
      }
      chatAsync?.askForImage(
        message: PromptUseCases.addImageTemplateToPrompt(message),
        displayedMessage: text,
      );
    }

    List<Widget> buildMessages(BuildContext context) => messages.reversed.map(
          (message) {
            Widget child = Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyMessageWidget(
                text: message.text,
                documentId: documentId,
                listOfValues: message.fields,
                imageId: message.imageId,
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
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 8.0,
            ),
            child: TextField(
              controller: controller,
              onSubmitted: (text) {
                onSendPressed(text);
                controller.clear();
              },
              decoration: InputDecoration(
                hintText: 'You can type here',
                suffix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.image),
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        onGenerateImagePressed(controller.text);
                        controller.clear();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      visualDensity: VisualDensity.compact,
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
      ],
    );
  }
}
