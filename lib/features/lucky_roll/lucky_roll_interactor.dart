import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spells_and_tools/features/daily_messages/daily_messages_spells/daily_messages_spells.dart';

class LuckyRollInteractor {
  Future<void> onRoll({
    required BuildContext context,
    required WidgetRef ref,
    required int rolledNumber,
  }) async {
    if (rolledNumber >= 10) {
      onSuccessfulRoll(
        context: context,
        ref: ref,
        rolledNumber: rolledNumber,
      );
    } else {
      onFailedRoll(
        context: context,
        ref: ref,
        rolledNumber: rolledNumber,
      );
    }
  }

  onSuccessfulRoll({
    required BuildContext context,
    required WidgetRef ref,
    required int rolledNumber,
  }) async {
    final defaultMessages = [
      'Lucky you! Daily message refreshed!',
      'Great roll! You get Daily message refresh!',
      'Congratulations! Daily message refreshed!',
      'Hope you will roll like that at the table! Daily message refreshed!',
    ];
    final messages = switch (rolledNumber) {
      20 => [
          'Congrats! We both know it will be the last one you rolled today!',
          'Critical success! But can you do it again tomorrow?',
          'You rolled a natural 20! Don\'t get used to it!',
        ],
      _ => defaultMessages,
    };

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            messages.first,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    DailyMessagesSpellsInteractor.forceLoadNewDailyMessage(ref: ref);
  }

  onFailedRoll({
    required BuildContext context,
    required WidgetRef ref,
    required int rolledNumber,
  }) {
    final messages = switch (rolledNumber) {
      2 => ['Maybe GM should have this dice...'],
      9 => ['Almost had it! Try again!'],
      1 => [
          'Your GM sends their regards.',
          'Perfect day for a session, right?',
        ],
      _ => [
          'Better luck next time!',
          'Keep trying!',
          'Not quite lucky enough this time.',
          'Roll again to try for a daily message refresh!',
        ]
    };
    messages.shuffle();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            messages.first,
          ),
        ),
      );
    }
  }
}
