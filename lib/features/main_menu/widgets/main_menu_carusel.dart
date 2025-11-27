import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app_version/app_version_interactor.dart';
import '../../app_version/update_available_widget.dart';
import '../../daily_messages/daily_messages_spells/daily_messages_spells.dart';
import '../../daily_messages/daily_messages_spells/daily_messages_spells_widget.dart';

class MainMenuCaruselWidgetEntry<T> {
  final AsyncValue<T> asyncValue;
  final Widget? Function(AsyncValue<T>, BuildContext) builder;

  MainMenuCaruselWidgetEntry({
    required this.asyncValue,
    required this.builder,
  });

  Widget? build(BuildContext context) {
    return builder(asyncValue, context);
  }
}

final mainMenuCaruselWidgetsProvider =
    Provider<List<MainMenuCaruselWidgetEntry>>(
  (ref) {
    final isUpdateAvailable = ref.watch(isUpdateAvailableProvider);
    final dailyMessageSpellViewModel =
        ref.watch(dailyMessageSpellViewModelProvider);

    return [
      MainMenuCaruselWidgetEntry<bool>(
        asyncValue: isUpdateAvailable,
        builder: (asyncValue, context) {
          return asyncValue.whenOrNull(
            data: (isAvailable) => isAvailable ? UpdateAvailableWidget() : null,
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
      MainMenuCaruselWidgetEntry<DailyMessageSpellViewModel>(
        asyncValue: dailyMessageSpellViewModel,
        builder: (asyncValue, context) {
          return asyncValue.whenOrNull(
            data: (viewModel) => DailyMessagesSpellsWidget(
              viewModel: viewModel,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    ];
  },
);

class MainMenuCarusel extends HookConsumerWidget {
  const MainMenuCarusel({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = usePageController(viewportFraction: 0.8);
    final mainMenuCaruselWidgets = ref.watch(
      mainMenuCaruselWidgetsProvider,
    );

    final mainMenuCarusleWidgetsLoaded = mainMenuCaruselWidgets
        .map(
          (entry) => entry.build(context),
        )
        .nonNulls
        .toList();

    /// Checking if the first widget is still loading to show a loader
    /// The first widget on PageView must be loaded to avoid blank space
    /// the other widgets can load later
    final isFirstNotEmptyLoaded = () {
      for (final entry in mainMenuCaruselWidgets) {
        if (entry.asyncValue.isLoading) {
          return false;
        }
      }
      return true;
    }();

    cardBuilder(Widget child) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: child,
          ),
        );

    return PageView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      children: isFirstNotEmptyLoaded
          ? mainMenuCarusleWidgetsLoaded.map(cardBuilder).toList()
          : [
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
    );
  }
}
