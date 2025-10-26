import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'daily_messages_spells.dart';

class DailyMessagesSpellsWidget extends HookConsumerWidget {
  final DailyMessageSpellViewModel viewModel;
  const DailyMessagesSpellsWidget({
    required this.viewModel,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Stack(
            fit: StackFit.expand,
            children: [
              Card(
                child: Image.asset(
                  viewModel.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Card.filled(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        viewModel.subtitle,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                        textAlign: TextAlign.center,
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
                context.push('/spells/${viewModel.spellId}');
              },
            ),
          ),
        ],
      ),
    );
  }
}
