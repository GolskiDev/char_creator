import 'package:char_creator/work_in_progress/character/character_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/basic_chat_support/chat_widget.dart';
import '../character/character.dart';
import '../character/field.dart';
import '../notes/note.dart';

class ChatPage extends HookConsumerWidget {
  final Character character;
  const ChatPage({
    required this.character,
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
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
              tooltip: "Add To Character",
              onPressed: () async {
                final trait = Note.create(
                  value: selectedText.value!,
                );
                final characterRepository =
                    ref.read(characterRepositoryProvider);
                final otherField = character.fields.firstWhere(
                  (field) => field.name == "Other",
                  orElse: () => const Field(
                    name: "Other",
                    notes: [],
                  ),
                );
                final updatedField = otherField.copyWith(
                  notes: [
                    ...otherField.notes,
                    trait,
                  ],
                );
                final updatedCharacter = character.copyWith(
                  fields: [
                    ...character.fields.where((field) => field.name != "Other"),
                    updatedField,
                  ],
                );
                await characterRepository.updateCharacter(updatedCharacter);
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
            characterId: character.id,
            onSelectionChanged: (text) {
              selectedText.value = text;
            },
          ),
        ),
      ),
    );
  }
}
