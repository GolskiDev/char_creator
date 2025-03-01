import 'package:char_creator/features/spells/open5e/open_5e_spells_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'open5e/open_5e_spell_model.dart';
import 'widgets/card_widget.dart';

class CardPage extends HookConsumerWidget {
  final String slug;

  const CardPage({
    super.key,
    required this.slug,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spellsAsync = ref.watch(allSRDCantripsProvider);

    final List<Open5eSpellModel> spells;

    switch (spellsAsync) {
      case AsyncValue(value: List<Open5eSpellModel> loadedSpells):
        spells = loadedSpells;
        break;
      case AsyncValue(error: final error, hasError: true):
        return Scaffold(
          body: Center(
            child: Text('Error: $error'),
          ),
        );
      default:
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
    }

    final spell = spells.firstWhereOrNull(
      (element) => element.name == slug,
    );

    if (spell == null) {
      return Scaffold(
        body: Center(
          child: Text('Spell not found'),
        ),
      );
    }

    final currentIndex = useState<int>(spells.indexOf(spell));

    final pageController = usePageController(
      viewportFraction: 1,
      initialPage: currentIndex.value,
    );

    return Scaffold(
      body: PageView(
        controller: pageController,
        dragStartBehavior: DragStartBehavior.down,
        children: spells.map(
          (spell) {
            return SpellCardWidget(
              spell: spell,
            );
          },
        ).toList(),
      ),
    );
  }
}