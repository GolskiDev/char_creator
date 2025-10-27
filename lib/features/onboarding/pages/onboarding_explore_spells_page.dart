import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnboardingExploreSpellsPage extends HookConsumerWidget {
  final Function(BuildContext context)? onContinue;
  const OnboardingExploreSpellsPage({
    this.onContinue,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final someSpells = [
      'assets/images/spells/acid_arrow.webp',
      'assets/images/spells/aid.webp',
      'assets/images/spells/animal_friendship.webp',
      'assets/images/spells/banishment.webp',
    ];

    final pageController = usePageController(
      initialPage: 0,
    );

    final animation = useAnimationController(duration: Durations.long1);

    final opacity = animation.drive(
      Tween<double>(begin: 0, end: 1).chain(
        CurveTween(curve: Curves.easeIn),
      ),
    );

    useEffect(
      () {
        animation.forward();
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            pageController.animateToPage(
              30,
              duration: const Duration(seconds: 60),
              curve: Curves.linear,
            );
          },
        );
        return null;
      },
      [pageController],
    );

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 3 / 4,
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    return Opacity(
                      opacity: opacity.value,
                      child: child,
                    );
                  },
                  child: PageView.builder(
                    controller: pageController,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            someSpells[index % someSpells.length],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Text(
                'Explore spells with visuals',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          if (onContinue != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                    onPressed: () {
                      onContinue?.call(context);
                    },
                    child: const Text('Continue'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
