import 'package:char_creator/common/widgets/loading_indicator.dart';
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

    spells = spellsAsync.data ?? [];

    final spell = spells.firstWhereOrNull((spell) => spell.id == id);

    Widget? defaultBuilder() {
      if (spell == null) {
        return null;
      }
      final currentIndex = useState<int>(spells.indexOf(spell));
      final pageController = usePageController(
        viewportFraction: 1,
        initialPage: currentIndex.value,
      );
      return PageView(
        controller: pageController,
        dragStartBehavior: DragStartBehavior.down,
        children: spells.map(
          (spell) {
            return SpellCardWidget(
              spell: spell,
            );
          },
        ).toList(),
      );
    }

    spellNotFound() => Center(
          child: Text("I can't remember that spell..."),
        );

    body() => defaultBuilder() ?? spellNotFound();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          body(),
          LoadingIndicatorWidget(
            isVisible: switch (spellsAsync.connectionState) {
              ConnectionState.waiting => false,
              ConnectionState.active => true,
              ConnectionState.done => false,
              ConnectionState.none => false,
            },
          ),
        ],
      ),
    );
  }
}
