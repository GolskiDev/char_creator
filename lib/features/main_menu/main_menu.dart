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

    final settingsButton = IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        context.go('/settings');
      },
    );

    final blurSigma = 12.0;

    return Scaffold(
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -2 * blurSigma,
            bottom: -2 * blurSigma,
            left: -2 * blurSigma,
            right: -2 * blurSigma,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: blurSigma,
                sigmaY: blurSigma,
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
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: SafeArea(
              child: settingsButton,
            ),
          ),
        ],
      ),
    );
  }
}
