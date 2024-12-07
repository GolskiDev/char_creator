import 'my_chat_widget.dart';
import 'my_message.dart';

class MessageViewModel {
  final String message;
  final MyMessageType author;
  final DateTime time;

  MessageViewModel({
    required this.message,
    required this.author,
    required this.time,
  });
}
