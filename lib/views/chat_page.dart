import 'package:char_creator/features/character/character_providers.dart';
import 'package:char_creator/features/character/character_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/basic_chat_support/my_chat_widget.dart';
import '../features/character/character.dart';
import '../features/character/field.dart';
import '../features/character/widgets/selectable_list_of_fields.dart';
import '../common/widgets/default_async_id_page_builder.dart';
import '../features/notes/note.dart';

class ChatPage extends HookConsumerWidget {
  final String characterId;
  const ChatPage({
    required this.characterId,
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final characterAsync = ref.watch(characterByIdProvider(characterId));

    return DefaultAsyncIdPageBuilder<Character>(
      asyncValue: characterAsync,
      pageBuilder: (context, character) {
        final selectedText = useState<String?>(null);
        final focusNode = useFocusNode();

        final idsOfNotesForChatContext = useState<List<String>>([]);
        final notesForChatContext =
            character.fields.expand((field) => field.notes).toList().where(
                  (note) => idsOfNotesForChatContext.value.contains(note.id),
                );

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
                  tooltip: "Add To Character",
                  onPressed: () async {
                    await _createNoteFromSeleciton(
                      selectedText,
                      ref,
                      focusNode,
                      character,
                    );
                  },
                ),
            ],
          ),
          endDrawer: Drawer(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "Context for Chat",
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: SelectableListOfFields(
                        character: character,
                        selectedNotesIds: idsOfNotesForChatContext.value,
                        onNotePressed: (pressedNote) {
                          if (idsOfNotesForChatContext.value
                              .contains(pressedNote.id)) {
                            idsOfNotesForChatContext.value = List.from(
                              idsOfNotesForChatContext.value
                                ..removeWhere((id) => id == pressedNote.id),
                            );
                          } else {
                            idsOfNotesForChatContext.value = List.from(
                              idsOfNotesForChatContext.value
                                ..add(pressedNote.id),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SelectionArea(
            onSelectionChanged: (value) {
              selectedText.value = value?.plainText;
            },
            child: Center(
              child: MyChatWidget(
                characterId: character.id,
                additionalContext: notesForChatContext.toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _createNoteFromSeleciton(
    ValueNotifier<String?> selectedText,
    WidgetRef ref,
    FocusNode focusNode,
    Character character,
  ) async {
    final trait = Note.create(
      value: selectedText.value!,
    );
    final characterRepository = ref.read(characterRepositoryProvider);
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
  }
}
