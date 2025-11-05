import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'lucky_roll_model.dart';

class NextRollCountdownWidget extends HookConsumerWidget {
  const NextRollCountdownWidget(this.luckyRollModel, {super.key});
  final LuckyRollModel luckyRollModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = useStream(
      Stream<int>.periodic(
        const Duration(seconds: 1),
        (_) {
          final now = DateTime.now();
          final difference =
              luckyRollModel.nextAvailableRollDate.difference(now);
          return difference.inSeconds > 0 ? difference.inSeconds : 0;
        },
      ),
      initialData: luckyRollModel.nextAvailableRollDate.isAfter(DateTime.now())
          ? luckyRollModel.nextAvailableRollDate
              .difference(DateTime.now())
              .inSeconds
          : 0,
    );

    final formattedRemainingTime = () {
      final seconds = stream.data! % 60;
      final minutes = (stream.data! ~/ 60) % 60;
      final hours = (stream.data! ~/ 3600);
      final secondsFormatted = seconds.toString().padLeft(2, '0');
      final minutesFormatted = minutes.toString().padLeft(2, '0');
      if (hours > 0) {
        final hoursFormatted = hours.toString().padLeft(2, '0');
        return '$hoursFormatted:$minutesFormatted:$secondsFormatted';
      } else {
        return '$minutesFormatted:$secondsFormatted';
      }
    }();

    return Text(
      stream.data! > 0
          ? 'Next roll in: $formattedRemainingTime'
          : 'You can roll now!',
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
