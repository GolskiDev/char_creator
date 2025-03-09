import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class MainMenuPage extends HookConsumerWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconSize = 64.0;
    final pages = <({
      String path,
      String title,
      Widget icon,
    })>[
      (
        path: '/spells',
        title: 'Spells',
        icon: Icon(
          Symbols.book_4_spark,
          size: iconSize,
        ),
      ),
      (
        path: '/characters',
        title: 'Characters',
        icon: Icon(
          Icons.person,
          size: iconSize,
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/settings');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: GridView.extent(
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: EdgeInsets.all(8),
          childAspectRatio: 2 / 3,
          maxCrossAxisExtent: 300,
          children: List.generate(
            pages.length,
            (index) {
              final page = pages[index];
              return Card.outlined(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    context.go(page.path);
                  },
                  child: Column(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      page.icon,
                      Text(
                        page.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
