import 'package:char_creator/features/basic_chat_support/my_chat_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myChatHistoryProvider = StateProvider<List<MyMessage>>(
  (ref) {
    return [];
  },
);
