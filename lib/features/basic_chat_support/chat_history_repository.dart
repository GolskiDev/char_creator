import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chatTypes;

final chatHistoryProviderByCharacterId =
    StateProvider.family<List<chatTypes.Message>, String>(
  (ref, characterId) {
    return [];
  },
);
