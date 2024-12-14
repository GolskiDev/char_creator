import 'package:char_creator/features/chat_context/chat_context.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final chatContextProvider = StateProvider<ChatContext>(
  (ref) {
    return ChatContext.empty();
  },
);

final isChatContextEnabledProvider = StateProvider<bool>(
  (ref) => false,
);
