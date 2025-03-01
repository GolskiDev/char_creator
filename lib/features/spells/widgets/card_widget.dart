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

    return Stack(
      children: [
        if (spellImagePath != null)
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 8,
                sigmaY: 8,
              ),
              child: Image.asset(
                spellImagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 32,
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
                          Image.asset(
                            spellImagePath,
                            fit: BoxFit.cover,
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
