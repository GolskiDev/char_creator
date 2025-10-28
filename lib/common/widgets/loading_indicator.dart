import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoadingIndicatorWidget extends HookConsumerWidget {
  const LoadingIndicatorWidget({
    required this.isVisible,
    super.key,
  });

  final bool isVisible;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IgnorePointer(
      child: AnimatedOpacity(
        duration: Durations.medium2,
        opacity: isVisible ? 1.0 : 0.0,
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 4.0,
            ),
          ),
        ),
      ),
    );
  }
}
