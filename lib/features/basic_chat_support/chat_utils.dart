import 'package:flutter_chat_types/flutter_chat_types.dart' as chatTypes;

class ChatUtils {
  static chatTypes.User get chatUser {
    return const chatTypes.User(
      id: '1',
      firstName: 'User',
    );
  }
}
