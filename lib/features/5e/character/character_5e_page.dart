import 'package:char_creator/features/5e/spells/open5e/open_5e_spell_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../spells/open5e/open_5e_spells_repository.dart';
import '../spells/spell_images/spell_images_repository.dart';
import 'models/character_5e_model.dart';
import 'repository/character_repository.dart';

class Character5ePage extends HookConsumerWidget {
  final String characterId;

  const Character5ePage({
    required this.characterId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(charactersStreamProvider);
    final spellsAsync = ref.watch(allSRDCantripsProvider);

    final List<Open5eSpellModelV1> spellsOpen5e;
    switch (spellsAsync) {
      case AsyncValue(value: final List<Open5eSpellModelV1> value):
        spellsOpen5e = value;
        break;
      default:
        spellsOpen5e = [];
    }

    final Character5eModel? character;
    switch (charactersAsync) {
      case AsyncValue(value: final List<Character5eModel> characters):
        character = characters
            .firstWhereOrNull((character) => character.id == characterId);
        if (character == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Character'),
            ),
            body: Center(
              child: Text('Character not found'),
            ),
          );
        }
      default:
        return Scaffold(
          appBar: AppBar(
            title: Text('Character'),
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
    }

    final characterSpells = spellsOpen5e
        .where((spell) => character!.spellIds.contains(spell.toSpellModel().id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: GridView.extent(
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 4,
        children: characterSpells.map(
          (spell) {
            final spellImagePath =
                ref.watch(spellImagePathProvider(spell.slug)).asData?.value;
            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  context.push('/spells/${spell.toSpellModel().id}');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (spellImagePath != null)
                      Flexible(
                        child: Hero(
                          tag: spellImagePath,
                          child: Image.asset(
                            spellImagePath,
                            fit: BoxFit.fitWidth,
                            frameBuilder: (context, child, frame,
                                wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded) {
                                return child;
                              }
                              return AnimatedOpacity(
                                duration: Durations.long1,
                                curve: Curves.easeIn,
                                opacity: frame == null ? 0 : 1,
                                child: child,
                              );
                            },
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Flexible(
                        child: Text(
                          spell.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
