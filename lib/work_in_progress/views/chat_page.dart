import 'package:char_creator/work_in_progress/character_trait_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/basic_chat_support/chat_widget.dart';
import '../character_trait.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CharacterTraitRepository characterTraitRepository =
        ref.watch(characterTraitRepositoryProvider);
    final selectedText = useState<String?>(null);
    final focusNode = useFocusNode();

    final title = selectedText.value == "" || selectedText.value == null
        ? "Chat"
        : selectedText.value!;

    return SelectionArea(
      onSelectionChanged: (text) {
        selectedText.value = text?.plainText;
      },
      focusNode: focusNode,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            if (selectedText.value != null && selectedText.value!.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: "Add trait",
                onPressed: () {
                  characterTraitRepository.saveTrait(
                    Note(
                      id: selectedText.value!,
                      value: selectedText.value!,
                    ),
                  );
                  focusNode.unfocus();
                },
              ),
          ],
        ),
        body: Center(
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
