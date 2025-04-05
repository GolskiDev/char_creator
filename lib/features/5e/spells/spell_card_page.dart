import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'view_models/spell_view_model.dart';
import 'widgets/card_widget.dart';

class SpellCardPage extends HookConsumerWidget {
  final String id;
  final Future<List<SpellViewModel>> spellsFuture;

  const SpellCardPage({
    super.key,
    required this.spellsFuture,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spellsAsync = useFuture(spellsFuture);

    final List<SpellViewModel> spells;

    switch (spellsAsync) {
      case AsyncSnapshot(
          data: final List<SpellViewModel> loadedSpells,
        ):
        spells = loadedSpells;
        break;
      case AsyncError error:
        return Scaffold(
          body: Center(
            child: Text('Error: ${error.error}'),
          ),
        );
      default:
        return Scaffold(
          appBar: AppBar(),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
    }

    final spell = spells.firstWhereOrNull(
      (spellViewModel) => spellViewModel.id == id,
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
