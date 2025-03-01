import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'open5e/open_5e_spells_repository.dart';

class ListOfSpellsPage extends HookConsumerWidget {
  const ListOfSpellsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCantrips = ref.watch(allSRDCantripsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spells'),
      ),
      body: allCantrips.when(
        data: (cantrips) {
          return ListView.separated(
            itemCount: cantrips.length,
            itemBuilder: (context, index) {
              final cantrip = cantrips[index];
              return ListTile(
                title: Text(cantrip.name),
                subtitle: Text(cantrip.description),
                onTap: () {
                  context.go('/spells/${cantrip.name}');
                },
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) {
          return Center(
            child: Text('Error: $error'),
          );
        },
      ),
    );
  }
}
