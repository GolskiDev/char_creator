import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spells_and_tools/features/lucky_roll/lucky_roll_interactor.dart';
import 'package:spells_and_tools/features/lucky_roll/lucky_roll_repository.dart';

import 'lucky_roll_model.dart';
import 'next_roll_countdown_widget.dart';

class LuckyRollWidget extends HookConsumerWidget {
  const LuckyRollWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastRolledNumberAsync = ref.watch(luckyRollProvider);

    cardBuilder(
      GestureTapCallback? onTap,
      Widget child,
    ) =>
        Card(
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 100,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.casino,
                      size: 48.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Flexible(
                      child: child,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

    if (lastRolledNumberAsync.isLoading) {
      return cardBuilder(
        null,
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final numberOfItems = 200;
    final randomD20List = useState(
      List<int>.generate(numberOfItems, (index) => (index % 20) + 1)..shuffle(),
    );
    final randomIndex = 100;
    final scrollController = useFixedExtentScrollController(
      initialItem: 10,
    );

    final rollingState = useState<Future?>(null);

    final textStyle = Theme.of(context).textTheme.titleLarge;

    final dailyRollReadyTexts = [
      'Your daily roll is ready!',
      'Feeling lucky?',
      'It\'s time for your daily d20 roll!',
      'Will you be lucky today?',
      'Give it a spin!',
    ]..shuffle();
    final dailyRollReadyText = dailyRollReadyTexts.first;

    rollerBuilder() => IgnorePointer(
          child: SizedBox(
            width: 50,
            child: CupertinoPicker.builder(
              itemExtent: 32.0,
              onSelectedItemChanged: (_) {},
              childCount: randomD20List.value.length,
              scrollController: scrollController,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    randomD20List.value[index % randomD20List.value.length]
                        .toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              },
            ),
          ),
        );

    bodyBuilder() {
      final roller = rollerBuilder();
      bool canRollNewOne(LuckyRollModel model) {
        final now = DateTime.now();
        return now.isAfter(model.nextAvailableRollDate);
      }

      final children = <Widget>[
        ...switch ((lastRolledNumberAsync, rollingState.value)) {
          (
            AsyncValue(value: null),
            null,
          ) =>
            [
              Flexible(
                child: Text(
                  textAlign: TextAlign.right,
                  dailyRollReadyText,
                  style: textStyle,
                ),
              ),
              Visibility(
                visible: false,
                maintainAnimation: true,
                maintainState: true,
                child: roller,
              ),
            ],
          (
            AsyncValue(value: final LuckyRollModel lastLuckyRoll),
            null,
          ) =>
            [
              if (canRollNewOne(lastLuckyRoll)) ...[
                Text(
                  'Tap to roll your daily d20!',
                  style: textStyle,
                ),
                Visibility(
                  visible: false,
                  maintainAnimation: true,
                  maintainState: true,
                  child: roller,
                ),
              ] else ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Last rolled: ${lastLuckyRoll.lastRolledNumber}',
                      style: textStyle,
                    ),
                    NextRollCountdownWidget(
                      lastLuckyRoll,
                    ),
                  ],
                ),
              ]
            ],
          (_, Future _) => [
              roller,
            ],
        },
      ];
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 8,
        children: children,
      );
    }

    roll() async {
      final lastLuckyRoll = await ref.read(luckyRollProvider.future);
      final canRoll = lastLuckyRoll == null ||
          DateTime.now().isAfter(lastLuckyRoll.nextAvailableRollDate);
      if (!canRoll || rollingState.value != null) {
        return;
      }
      final completer = Completer<void>();
      rollingState.value = completer.future;
      await Future.delayed(const Duration(milliseconds: 100));
      await scrollController.animateToItem(
        randomIndex,
        duration: const Duration(seconds: 2),
        curve: Curves.decelerate,
      );
      completer.complete();
      final rolledNumber = randomD20List.value[randomIndex];
      LuckyRollInteractor().onRoll(
        // ignore: use_build_context_synchronously
        context: context,
        ref: ref,
        rolledNumber: rolledNumber,
      );
      final repository = await ref.read(luckyRollRepositoryProvider.future);
      await repository.saveLuckyRollModel(
        LuckyRollModel(
          lastRolledNumber: rolledNumber,
          lastLuckyRollDate: DateTime.now(),
        ),
      );

      await Future.delayed(
        const Duration(milliseconds: 500),
      );
      ref.invalidate(luckyRollProvider);
    }

    return cardBuilder(
      () => roll(),
      bodyBuilder(),
    );
  }
}
