import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/5e/spells/open5e/open_5e_spells_repository.dart';

class UtilsPage extends HookConsumerWidget {
  const UtilsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ListTile(
            title: const Text('print'),
            onTap: () {
              print(context, ref);
            },
          ),
        ],
      ),
    );
  }

  print(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final spells = await ref.read(allSRDSpellsProvider.future);
    final durations = spells.map((e) => e.range).toSet();
    final json = jsonEncode(durations.toList());
    log(json);
  }
}
