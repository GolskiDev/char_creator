import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spells_and_tools/features/5e/character/repository/character_classes_repository.dart';
import 'package:spells_and_tools/features/terms/data_sources/agreements_documents_data_source.dart';

import '../features/daily_messages/daily_messages_spells/daily_messages_spells.dart';
import '../features/terms/data_sources/user_accepted_agreements_data_source.dart';
import '../features/terms/widgets/terms_and_conditions_widget.dart';

class UtilsPage extends HookConsumerWidget {
  const UtilsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ListTile(
            title: const Text('New Screen'),
            onTap: () {
              showNewScreen(context, ref);
            },
          ),
          ListTile(
            title: const Text('print'),
            onTap: () {
              debugPrint(context, ref);
            },
          ),
          ListTile(
            title: const Text('signIn'),
            onTap: () {
              context.go('/signIn');
            },
          ),
          ListTile(
            title: const Text('go to'),
            onTap: () {
              goTo(context, ref);
            },
          ),
          ListTile(
            title: const Text('Refresh Daily Message'),
            onTap: () {
              DailyMessagesSpellsInteractor.forceLoadNewDailyMessage(ref: ref);
            },
          ),
          ListTile(
            title: const Text('showTosUpdate'),
            onTap: () {
              AgreementsWidget.showTosUpdateDialog(
                goRouter: GoRouter.of(context),
                termsOfUseDetails: AgreementDetails(
                  effectiveDate: DateTime.now().subtract(
                    const Duration(days: 1),
                  ),
                  type: AgreementType.termsOfUse,
                  version: 'v2.0',
                  extra: {"link_en": "https://facebook.com"},
                ),
                privacyPolicyDetails: AgreementDetails(
                  effectiveDate: DateTime.now().subtract(
                    const Duration(days: 1),
                  ),
                  type: AgreementType.privacyPolicy,
                  version: 'v2.0',
                  extra: {"link_en": "https://bing.com"},
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  showNewScreen(
    BuildContext context,
    WidgetRef ref,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewScreen(),
      ),
    );
  }

  debugPrint(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final characterClasses =
        await ref.read(characterClassesStreamProvider.future);
    characterClasses.forEach(
      (element) {
        final json = jsonEncode(element.toMap());
        log(json);
      },
    );
  }

  goTo(
    BuildContext context,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return HookBuilder(
          builder: (context) {
            final TextEditingController controller =
                useTextEditingController(text: '/');
            return AlertDialog(
              title: const Text('Go to'),
              content: TextField(
                controller: controller,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    final path = controller.text;
                    if (path.isNotEmpty) {
                      context.go(path);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Go'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class NewScreen extends HookConsumerWidget {
  const NewScreen({super.key});
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Continue'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
