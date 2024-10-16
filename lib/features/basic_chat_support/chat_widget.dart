import 'package:char_creator/features/basic_chat_support/chat_bot.dart';
import 'package:char_creator/features/basic_chat_support/chat_utils.dart';
import 'package:char_creator/work_in_progress/views/list_of_notes_widgettt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chatTypes;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:langchain/langchain.dart';

class ChatWidget extends HookConsumerWidget {
  const ChatWidget({
    this.onSelectionChanged,
    super.key,
  });
  final void Function(
    String? selection,
  )? onSelectionChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final someContext = ref.watch(selectedNotesProvider);
    final messages = useState<List<chatTypes.Message>>([]);
    final chatBot = useMemoized(() => ChatBotWithMemory(
          ConversationBufferMemory(returnMessages: true),
        ));

    Future<void> _onSendPressed(chatTypes.PartialText message) async {
      final newMessage = chatTypes.TextMessage(
        author: ChatUtils.chatUser,
        id: messages.value.length.toString(),
        text: message.text,
      );
      messages.value = [newMessage, ...messages.value];
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
    }

    return Chat(
      messages: messages.value,
      onSendPressed: _onSendPressed,
      user: ChatUtils.chatUser,
      textMessageBuilder: (p0, {required messageWidth, required showName}) {
        return Container(
          padding: EdgeInsets.all(8),
          child: Text(p0.text),
        );
      },
      onMessageLongPress: (context, p1) async {
        if (p1.author.id == ChatUtils.chatUser.id) {
          return;
        }
        final message = p1 as chatTypes.TextMessage;
        final prompt = message.text;
        final response = await chatBot.extractJson(prompt);
      },
    );
  }
}
