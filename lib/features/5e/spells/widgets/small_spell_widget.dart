import 'package:char_creator/features/5e/spells/view_models/spell_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SmallSpellWidget extends HookConsumerWidget {
  final SpellViewModel spell;
  final GestureTapCallback? onTap;

  const SmallSpellWidget({
    required this.spell,
    this.onTap,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card.outlined(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (spell.imageUrl != null)
              Hero(
                tag: spell.imageUrl!,
                child: Image.asset(
                  spell.imageUrl!,
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) {
                      return child;
                    }
                    return AnimatedOpacity(
                      duration: Durations.short1,
                      curve: Curves.easeIn,
                      opacity: frame == null ? 0 : 1,
                      child: child,
                    );
                  },
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              widthFactor: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card.outlined(
                  child: ListTile(
                    title: Text(
                      spell.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
