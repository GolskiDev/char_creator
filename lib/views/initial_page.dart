import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InitialPage extends HookConsumerWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final randomTexts = [
      'Dusting off ancient spellbooks',
      'Casting "wait" spell',
      'Haunting the progress bar',
      'Looking for notes from last session',
      'Teaching old wizards new tricks',
    ];

    final randomTextsForDms = [
      'Hiding Fireball from players',
    ];

    final randomTextForPlayers = [
      'Rolling for initiative',
      'Optimizing character builds',
      'Consulting the GM'
    ];

    final randomLoadingTexts = [
      ...randomTexts,
      ...randomTextForPlayers,
    ];

    final titleStream = useMemoized(
      () {
        return Stream.periodic(
          const Duration(seconds: 3),
          (count) {
            final randomNumber = (DateTime.now().millisecondsSinceEpoch +
                    count * 9973) % // A large prime number for variability
                randomLoadingTexts.length;
            return randomLoadingTexts[randomNumber];
          },
        );
      },
      const [],
    );
    final dotsStream = useMemoized(
      () {
        return Stream.periodic(
          const Duration(milliseconds: 500),
          (count) {
            switch (count % 3) {
              case 0:
                return '.  ';
              case 1:
                return '.. ';
              case 2:
                return '...';
              default:
                return '';
            }
          },
        );
      },
      const [],
    );

    final stream = useStream(
      titleStream,
      initialData: randomLoadingTexts[0],
    );

    final threeLoadingDots = useStream(
      dotsStream,
      initialData: '.',
    );

    final loadingText = stream.data ?? 'Loading';

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 64,
          children: [
            CircularProgressIndicator(),
            Flexible(
              child: Text.rich(
                style: Theme.of(context).textTheme.titleLarge,
                TextSpan(
                  text: loadingText,
                  children: [
                    WidgetSpan(
                      child: Text(
                        threeLoadingDots.data ?? '.',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
