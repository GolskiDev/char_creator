import 'package:char_creator/work_in_progress/notes/note_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/basic_chat_support/chat_widget.dart';
import '../notes/note.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NoteRepository characterTraitRepository =
        ref.watch(characterTraitRepositoryProvider);
    final selectedText = useState<String?>(null);
    final focusNode = useFocusNode();

    final title = selectedText.value == "" || selectedText.value == null
        ? "Chat"
        : selectedText.value!;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (selectedText.value != null && selectedText.value!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.add),
              iconSize: 40,
              tooltip: "Add trait",
              onPressed: () async {
                final trait = Note.create(
                  value: selectedText.value!,
                );
                await characterTraitRepository.saveTrait(trait);
                focusNode.unfocus();
              },
            ),
        ],
      ),
      body: SelectionArea(
        onSelectionChanged: (value) {
          selectedText.value = value?.plainText;
        },
        child: Center(
          child: ChatWidget(
            onSelectionChanged: (text) {
              selectedText.value = text;
            },
          ),
        ),
      ),
    );
  }
}
