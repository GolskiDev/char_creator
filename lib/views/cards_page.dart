import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CardsPage extends HookConsumerWidget {
  const CardsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState<int>(0);

    final pageController = usePageController(
      viewportFraction: 1,
    );

    final animationController = useAnimationController(
      duration: Durations.medium1,
      initialValue: 1,
      lowerBound: 0,
      upperBound: 1,
    );

    useEffect(
      () {
        listener() async {
          if (pageController.page!.round() != currentIndex.value) {
            await animationController.reverse();
            currentIndex.value = pageController.page!.round();
            await animationController.forward();
          }
        }

        pageController.addListener(listener);
        return () {
          pageController.removeListener(listener);
          animationController.dispose();
        };
      },
      const [],
    );

    final imagePaths = [
      'assets/images/cards/acid_splash.png',
      'assets/images/cards/chill_touch.png',
      'assets/images/cards/dancing_lights.png',
      'assets/images/cards/druidcraft.png',
      'assets/images/cards/eldritch_blast.png',
      'assets/images/cards/fire_bolt.png',
    ];

    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceInOut,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FadeTransition(
            opacity: animation,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Image.asset(
                imagePaths[currentIndex.value],
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),
          PageView(
            controller: pageController,
            dragStartBehavior: DragStartBehavior.down,
            children: imagePaths.map(
              (path) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: Card(
                        path: path,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}

class Card extends StatelessWidget {
  const Card({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.asset(
            path,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Card Title',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
