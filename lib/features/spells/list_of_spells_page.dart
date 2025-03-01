import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'open5e/open_5e_spells_repository.dart';
import 'widgets/spell_filter_drawer.dart';

class ListOfSpellsPage extends HookConsumerWidget {
  const ListOfSpellsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCantrips = ref.watch(allSRDCantripsProvider);

    final menuEntries = [
      MenuItemButton(
        child: const Text('Hello'),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hello'),
            ),
          );
        },
      ),
      MenuItemButton(
        child: const Text('There'),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('There'),
            ),
          );
        },
      ),
    ];

    final searchController = useTextEditingController();
    final searchFocusNode = useFocusNode();

    final appBarTitle = Builder(
      builder: (context) {
        if (searchFocusNode.hasFocus || searchController.text.isNotEmpty) {
          return TextField(
            focusNode: searchFocusNode,
            controller: searchController,
            onTapOutside: (_) {
              searchController.clear();
            },
            decoration: InputDecoration(
              hintText: 'Search',
              //clear
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  searchFocusNode.unfocus();
                },
              ),
            ),
          );
        }

        return const Text('Cantrips');
      },
    );

    return Scaffold(
      endDrawer: const SpellFilterDrawer(),
      appBar: AppBar(
        title: appBarTitle,
        actions: [
          MenuAnchor(
            menuChildren: menuEntries,
            child: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                //Open menu
              },
            ),
            builder: (context, controller, child) {
              return IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  controller.isOpen ? controller.close() : controller.open();
                },
              );
            },
          ),
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(searchFocusNode);
        },
        child: const Icon(Icons.search),
      ),
      body: allCantrips.when(
        data: (cantrips) {
          return SafeArea(
            child: Stack(
              children: [
                ListView.separated(
                  itemCount: cantrips.length,
                  itemBuilder: (context, index) {
                    final cantrip = cantrips[index];
                    return ListTile(
                      title: Text(cantrip.name),
                      onTap: () {
                        context.go('/spells/${cantrip.name}');
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                ),
              ],
            ),
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
