import 'package:char_creator/features/spells/filters/spell_model_filters_state.dart';
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

    final spellFilters = useState(
      SpellModelFiltersState(),
    );

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

    final searchController = useTextEditingController(
      text: spellFilters.value.searchText,
    );
    final searchFocusNode = useFocusNode(
      canRequestFocus: true,
    );

    final isSearchVisible =
        searchFocusNode.hasFocus || searchController.text.isNotEmpty;

    final appBarTitle = Builder(
      builder: (context) {
        return Stack(
          fit: StackFit.passthrough,
          children: [
            Visibility(
              visible: !isSearchVisible,
              maintainSize: true,
              maintainAnimation: true,
              maintainInteractivity: true,
              maintainState: true,
              maintainSemantics: true,
              child: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text(
                    'Spells',
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                ),
                onTap: () {
                  searchFocusNode.requestFocus();
                },
              ),
            ),
            Visibility(
              visible: isSearchVisible,
              maintainSize: true,
              maintainAnimation: true,
              maintainInteractivity: true,
              maintainState: true,
              maintainSemantics: true,
              child: TextField(
                focusNode: searchFocusNode,
                canRequestFocus: true,
                controller: searchController,
                onTapOutside: (_) {
                  searchFocusNode.unfocus();
                },
                onChanged: (value) {
                  spellFilters.value = spellFilters.value.copyWith(
                    searchText: () {
                      return value;
                    },
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      spellFilters.value = spellFilters.value.copyWith(
                        searchText: () => null,
                      );
                      searchController.clear();
                      searchFocusNode.unfocus();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
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
      floatingActionButton: isSearchVisible
          ? null
          : FloatingActionButton(
              onPressed: () {
                searchFocusNode.requestFocus();
                FocusScope.of(context).requestFocus(searchFocusNode);
              },
              child: const Icon(Icons.search),
            ),
      body: allCantrips.when(
        data: (cantrips) {
          final filteredCantrips = spellFilters.value
              .filterSpells(cantrips.map((e) => e.toSpellModel()).toList());
          return SafeArea(
            child: Stack(
              children: [
                ListView.separated(
                  itemCount: filteredCantrips.length,
                  itemBuilder: (context, index) {
                    final cantrip = filteredCantrips[index];
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
