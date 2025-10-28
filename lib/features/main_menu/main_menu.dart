import 'dart:ui';

import 'package:char_creator/common/widgets/loading_indicator.dart';
import 'package:char_creator/features/5e/game_system_view_model.dart';
import 'package:char_creator/features/main_menu/widgets/main_menu_default_card_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../daily_messages/daily_messages_spells/daily_messages_spells.dart';
import '../daily_messages/daily_messages_spells/daily_messages_spells_widget.dart';

class MainMenuPage extends HookConsumerWidget {
  const MainMenuPage({super.key});

  static final double iconSize = 48.0;

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

    final dailyMessageSpellViewModelAsync =
        ref.watch(dailyMessageSpellViewModelProvider);

    final backgroundPhotoUrl = dailyMessageSpellViewModelAsync.maybeWhen(
      data: (viewModel) => viewModel.imageUrl,
      orElse: () => null,
    );

    mainWidget() => SafeArea(
          bottom: false,
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: dailyMessageSpellViewModelAsync.when(
              data: (viewModel) => DailyMessagesSpellsWidget(
                viewModel: viewModel,
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Text('Error: $error'),
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

    background() => Positioned(
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
                    Theme.of(context).colorScheme.surface.withAlpha(64),
                  Brightness.light => Colors.transparent,
                },
                BlendMode.srcOver,
              ),
              child: backgroundPhotoUrl != null
                  ? Image.asset(
                      backgroundPhotoUrl,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
          ),
        );

    return Scaffold(
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          background(),
          CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Column(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Center(
                          child: mainWidget(),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Center(
                          child: Column(
                            spacing: 8,
                            mainAxisSize: MainAxisSize.min,
                            children: widgets.mapIndexed(
                              (index, element) {
                                if (index == widgets.length - 1) {
                                  return SafeArea(
                                    top: false,
                                    child: element,
                                  );
                                }
                                return element;
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: SafeArea(
              child: settingsButton,
            ),
          ),
          LoadingIndicatorWidget(
            isVisible: !dailyMessageSpellViewModelAsync.hasValue,
          ),
        ],
      ),
    );
  }
}
