import 'package:char_creator/work_in_progress/note.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../identifiable.dart';
import 'character_trait_page.dart';

final selectedNotesProvider = StateProvider<List<Note>>(
  (ref) => [],
);

final class ListOfCharacterTraitsWidget extends HookConsumerWidget {
  const ListOfCharacterTraitsWidget({
    super.key,
    this.onTraitPressed,
    required this.traits,
  });
  final List<Identifiable> traits;
  final Function(Identifiable pressedIdentifiable)? onTraitPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      itemBuilder: (context, index) => _characterTrait(
        context,
        ref,
        traits.whereType<Note>().toList()[index],
      ),
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemCount: traits.length,
    );
  }

  _characterTrait(
    BuildContext context,
    WidgetRef ref,
    Note note,
  ) {
    final isTraitSelected = ref.watch(selectedNotesProvider).contains(note);
    return Card(
      color: isTraitSelected ? Colors.blue : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CharacterTraitPage(trait: note),
            ),
          );
        },
        onLongPress: () {
          final selectedTraits = ref.read(selectedNotesProvider);
          if (selectedTraits.contains(note)) {
            ref.read(selectedNotesProvider.notifier).state = [
              ...selectedTraits.where((trait) => trait != note)
            ];
          } else {
            ref.read(selectedNotesProvider.notifier).state = [
              ...selectedTraits,
              note
            ];
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(note.id),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(note.value),
            ),
          ],
        ),
      ),
    );
  }
}
