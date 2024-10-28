import 'package:char_creator/work_in_progress/character/widgets/list_of_characters_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'work_in_progress/views/chat_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Row(
          children: [
            Expanded(
              flex: 2,
              child: Scaffold(
                body: ListOfCharactersPage(),
              ),
            ),
            Expanded(
              flex: 5,
              child: ChatPage(),
            ),
          ],
        ),
      ),
    );
  }
}
