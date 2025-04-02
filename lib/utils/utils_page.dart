import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/5e/spells/view_models/spell_view_model.dart';

class UtilsPage extends HookConsumerWidget {
  const UtilsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Print all slugs'),
            onTap: () {
              printAllSlugs(context, ref);
            },
          ),
        ],
      ),
    );
  }

  printAllSlugs(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final spells = await ref.read(spellViewModelsProvider.future);
    final slugs = spells
        .where(
          (element) => element.spellLevel < 5,
        )
        .map((spell) => spell.id)
        .toList();
    final json = jsonEncode(slugs);
    log(json);
  }
}
