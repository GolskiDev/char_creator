import 'dart:ui';

import 'package:char_creator/features/5e/game_system_view_model.dart';
import 'package:char_creator/features/main_menu/widgets/main_menu_default_card_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainMenuPage extends HookConsumerWidget {
  const MainMenuPage({super.key});

  static final double iconSize = 64.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgets = [
      MainMenuDefaultCardWidget(
        icon: GameSystemViewModel.spells.icon,
        title: "Disover Spells",
        path: "/spells",
      ),
      MainMenuDefaultCardWidget(
        icon: GameSystemViewModel.character.icon,
        title: "Create Characters",
        path: "/characters",
      ),
      if (kDebugMode)
        MainMenuDefaultCardWidget(
          icon: Icons.extension,
          title: "Utils",
          path: "/utils",
        ),
    ];

    final backgroundPhotoUrl = "assets/images/spells/illusory_script.png";

    final mainWidget = SafeArea(
      bottom: false,
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Stack(
                fit: StackFit.expand,
                children: [
                  Card(
                    child: Image.asset(
                      backgroundPhotoUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Start your journey!",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.go('/characters');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/settings');
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 12.0,
              sigmaY: 12.0,
            ),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                switch (Theme.of(context).brightness) {
                  Brightness.dark =>
                    Theme.of(context).colorScheme.surface.withAlpha(192),
                  Brightness.light => Colors.transparent,
                },
                BlendMode.srcOver,
              ),
              child: Image.asset(
                backgroundPhotoUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView.separated(
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              if (index == 0) {
                return mainWidget;
              } else if (index == (widgets.length)) {
                return SafeArea(
                  top: false,
                  child: widgets[index - 1],
                );
              }
              return widgets[index - 1];
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8.0),
            itemCount: widgets.length + 1,
          )
        ],
      ),
    );
  }
}
