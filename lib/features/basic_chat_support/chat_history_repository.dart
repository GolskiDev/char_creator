import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chatTypes;

import 'my_chat_widget.dart';

final chatHistoryProviderByCharacterId =
    StateProvider.family<List<chatTypes.Message>, String>(
  (ref, characterId) {
    return [];
  },
);

final myChatHistoryProviderByCharacterId =
    StateProvider.family<List<MyMessage>, String>(
  (ref, characterId) {
    return [];
  },
);
