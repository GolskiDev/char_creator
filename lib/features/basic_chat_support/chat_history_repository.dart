import 'package:char_creator/features/basic_chat_support/my_chat_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myChatHistoryProviderByCharacterId =
    StateProvider.family<List<MyMessage>, String>(
  (ref, characterId) {
    return [];
  },
);
