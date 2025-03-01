import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../open5e/open_5e_spell_model.dart';
import '../spell_images/spell_images_repository.dart';

class SpellCardWidget extends ConsumerWidget {
  const SpellCardWidget({
    super.key,
    required this.spell,
  });

  final Open5eSpellModel spell;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final spellImagePathAsync = ref.watch(spellImagePathProvider(spell.slug));

    final String? spellImagePath;
    switch (spellImagePathAsync) {
      case AsyncValue(value: final String? path, hasValue: true):
        spellImagePath = path;
        break;
      default:
        return Center(
          child: CircularProgressIndicator(),
        );
    }

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        child: Scrollbar(
          thumbVisibility: false,
          trackVisibility: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (spellImagePath != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      spellImagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spell.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        spell.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
