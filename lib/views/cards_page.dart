import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;

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
              imageFilter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
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
                return Center(
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: CardWidget(
                      path: path,
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

class SpellsData extends HookConsumerWidget {
  const SpellsData({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spells = useMemoized(
      () async {
        // https://api.open5e.com/v2/spells/?level=1?limit=2
        final response = await http.get(
          Uri.parse('https://api.open5e.com/v2/spells/?level=1&limit=2'),
        );

        final data = jsonDecode(response.body);

        return data;
      },
    );

    final future = useFuture(spells);

    final Widget body;

    if (future.connectionState == ConnectionState.waiting) {
      body = Center(
        child: CircularProgressIndicator(),
      );
    } else if (future.connectionState == ConnectionState.done) {
      final index = 0;
      final spell = future.data['results'][index];
      final name = spell['name'];
      final desc = spell['desc'];
      body = Column(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: [
              for (final item in spell.keys)
                Text(
                  item.toString(),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
            ],
          ),
          Text(
            desc,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      );
    } else {
      body = Text('Error');
    }

    return Card.outlined(
      child: body,
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          SpellsData(),
        ],
      ),
    );
  }
}
