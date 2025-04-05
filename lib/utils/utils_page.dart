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
  ) async {}
}
