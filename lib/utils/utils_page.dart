import 'dart:convert';
import 'dart:developer';

import 'package:char_creator/features/5e/character/repository/character_classes_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
              debugPrint(context, ref);
            },
          ),
        ],
      ),
    );
  }

  debugPrint(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final characterClasses =
        await ref.read(characterClassesStreamProvider.future);
    characterClasses.forEach(
      (element) {
        final json = jsonEncode(element.toMap());
        log(json);
      },
    );
  }
}
