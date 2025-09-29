import 'package:char_creator/features/5e/spells/view_models/spell_view_model.dart';
import 'package:char_creator/features/authentication/auth_controller.dart';
import 'package:char_creator/views/initial_page.dart';
import 'package:char_creator/views/settings_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/utils_page.dart';
import '../../views/see_you_soon_page.dart';
import '../5e/character/character_5e_page.dart';
import '../5e/character/edit_character_5e_page.dart';
import '../5e/character/list_of_characters_page.dart';
import '../5e/spells/list_of_spells_page.dart';
import '../5e/spells/spell_card_page.dart';
import '../authentication/pages/account_page.dart';
import '../authentication/pages/sign_in_anonymously_page.dart';
import '../authentication/pages/sign_in_page.dart';
import '../main_menu/main_menu.dart';
import '../onboarding/pages/consents_page.dart';
import '../onboarding/pages/onboarding_explore_spells_page.dart';
import '../onboarding/pages/onboarding_home_page.dart';

final goRouterProvider = Provider(
  (ref) => Navigation.goRouter(ref),
);

class Navigation {
  static goRouter(Ref ref) => GoRouter(
        debugLogDiagnostics: kDebugMode,
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/initialPage',
            pageBuilder: (context, state) {
              return MaterialPage(
                key: state.pageKey,
                child: const InitialPage(),
              );
            },
          ),
          GoRoute(
            path: '/',
            redirect: (context, state) async {
              final isUserSignedIn = await ref.read(
                isUserSignedInProvider.future,
              );
              if (!isUserSignedIn) {
                return '/onboarding';
              }
              return null;
            },
            builder: (context, state) => const MainMenuPage(),
            routes: [
              GoRoute(
                path: '/spells',
                builder: (context, state) => const ListOfSpellsPage(),
                routes: [
                  GoRoute(
                    path: '/:id',
                    builder: (context, state) => Consumer(
                      builder: (context, ref, child) {
                        final spellsFuture =
                            ref.read(spellViewModelsProvider.future);
                        return SpellCardPage(
                          id: state.pathParameters['id']!,
                          spellsFuture: spellsFuture,
                        );
                      },
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
                routes: [
                  GoRoute(
                    path: 'account',
                    builder: (context, state) => const AccountPage(),
                  ),
                ],
              ),
              GoRoute(
                path: '/characters',
                builder: (context, state) => const ListOfCharactersPage(),
                routes: [
                  GoRoute(
                    path: '/new',
                    builder: (context, state) => EditCharacter5ePage(),
                  ),
                  GoRoute(
                    path: '/:id',
                    builder: (context, state) {
                      final characterId = state.pathParameters['id']!;
                      return Character5ePage(
                        characterId: characterId,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: '/edit',
                        builder: (context, state) {
                          final characterId = state.pathParameters['id']!;
                          return EditCharacter5ePage(
                            characterId: characterId,
                          );
                        },
                      ),
                      GoRoute(
                        path: '/addSpells',
                        builder: (context, state) {
                          final characterId = state.pathParameters['id']!;
                          return ListOfSpellsPage(
                            targetCharacterId: characterId,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/onboarding',
            redirect: (context, state) async {
              final isUserSignedIn = await ref.read(
                isUserSignedInProvider.future,
              );
              if (isUserSignedIn) {
                return '/';
              }
              return null;
            },
            builder: (context, state) => const OnboardingHomePage(),
            routes: [
              GoRoute(
                path: '/exploreSpells',
                builder: (context, state) => OnboardingExploreSpellsPage(
                  onContinue: (context) {
                    context.go('/onboarding/consents');
                  },
                ),
              ),
              GoRoute(
                path: '/signInAnonymously',
                builder: (context, state) => SignInAnonymouslyPage(
                  onSignedIn: (context) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Signed in anonymously.'),
                      ),
                    );
                    context.go('/');
                  },
                  onError: (context) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error signing in anonymously.'),
                      ),
                    );
                  },
                ),
              ),
              GoRoute(
                path: '/signIn',
                builder: (context, state) {
                  return SignInPage.signIn(
                    onSignedIn: (context) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Signed in successfully.'),
                        ),
                      );
                      context.go('/');
                    },
                    onError: (context) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error signing in.'),
                        ),
                      );
                    },
                  );
                },
              ),
              GoRoute(
                path: '/register',
                builder: (context, state) => SignInPage.register(
                  onAuthenticated: (context) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Registered and signed in successfully.'),
                      ),
                    );
                    context.go('/');
                  },
                  onError: (context) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error registering.'),
                      ),
                    );
                  },
                  onSkipped: (context) =>
                      context.go('/onboarding/signInAnonymously'),
                ),
              ),
              GoRoute(
                path: '/consents',
                builder: (context, state) => ConsentsPage(
                  consents: {
                    'privacy':
                        'I agree to the <a href="https://example.com/privacy">Privacy Policy</a>.',
                    'terms':
                        'I accept the <a href="https://example.com/terms">Terms of Service</a>.',
                  },
                  onContinue: (consents) {
                    context.go('/onboarding/signIn');
                  },
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/seeYouSoon',
            builder: (context, state) => SeeYouSoonPage(
              onGoBack: () {
                context.go('/');
              },
            ),
          ),
          GoRoute(
            redirect: (context, state) {
              if (!kDebugMode) {
                return '/';
              }
              return null;
            },
            path: '/utils',
            builder: (context, state) => const UtilsPage(),
          ),
        ],
      );
}
