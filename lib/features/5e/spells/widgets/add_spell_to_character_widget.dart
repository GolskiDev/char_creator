import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../character/character_provider.dart';
import '../../character/models/character_5e_model_v1.dart';
import '../../character/repository/character_repository.dart';
import '../view_models/spell_view_model.dart';

class AddSpellToCharacterWidget extends ConsumerWidget {
  const AddSpellToCharacterWidget({
    required this.spellViewModel,
    super.key,
  });
  final SpellViewModel spellViewModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCharacterId = SelectedCharacterIdProvider.maybeOf(context);
    final spell = spellViewModel;

    final charactersAsync =
        ref.watch(charactersStreamProvider).asData?.value ?? [];

    final selectedCharacter = charactersAsync.firstWhereOrNull(
      (char) => char.id == selectedCharacterId,
    );

    final singleCharacter =
        charactersAsync.length == 1 ? charactersAsync.first : null;

    final character = selectedCharacter ?? singleCharacter;

    final isSpellAdded =
        character != null && character.knownSpells.contains(spellViewModel.id);

    if (character == null && charactersAsync.isNotEmpty) {
      final charactersWithoutSpell = charactersAsync
          .where((char) => !char.knownSpells.contains(spell.id))
          .toList();
      if (charactersWithoutSpell.isEmpty) {
        return const SizedBox.shrink();
      }
      return IconButton.outlined(
        icon: const Icon(Symbols.add),
        onPressed: () async {
          final selectedCharacter = await showDialog<Character5eModelV1?>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Select Character'),
                content: SingleChildScrollView(
                  child: Column(
                    spacing: 8.0,
                    children: charactersWithoutSpell.map(
                      (char) {
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            leading: const Icon(Symbols.add),
                            title: Text(char.name),
                            onTap: () {
                              Navigator.of(context).pop(char);
                            },
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              );
            },
          );
          if (selectedCharacter == null) {
            return;
          }
          final updatedCharacter = selectedCharacter.addSpellForCharacter(
            spellId: spell.id,
          );
          final repository = await ref.read(characterRepositoryProvider.future);
          await repository?.updateCharacter(updatedCharacter);
        },
      );
    }

    if (character == null) {
      return const SizedBox.shrink();
    }

    return IconButton.outlined(
      icon: isSpellAdded
          ? const Icon(Symbols.person_check)
          : const Icon(Symbols.add),
      onPressed: () async {
        Character5eModelV1 updatedCharacter;
        if (isSpellAdded) {
          updatedCharacter = character.removeSpellForCharacter(
            spellId: spell.id,
            onlyUnprepare: false,
          );
        } else {
          try {
            updatedCharacter = character.addSpellForCharacter(
              spellId: spell.id,
            );
          } on MultipleClassesWithSpellFoundException catch (_) {
            final selectedClassId = await showDialog<String?>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Select Class'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: character.classesStates.map(
                        (classState) {
                          final classModel = classState.classModel;
                          return RadioListTile<String>(
                            title: Text(classModel.className ?? ''),
                            value: classModel.id,
                            groupValue: character.id,
                            onChanged: (value) {
                              Navigator.of(context).pop(value);
                            },
                          );
                        },
                      ).toList(),
                    ),
                  ),
                );
              },
            );
            if (selectedClassId == null) {
              return;
            }
            updatedCharacter = character.addSpellForCharacter(
              spellId: spell.id,
              classId: selectedClassId,
            );
          }
        }
        final repository = await ref.read(characterRepositoryProvider.future);
        await repository?.updateCharacter(updatedCharacter);
      },
    );
  }
}
