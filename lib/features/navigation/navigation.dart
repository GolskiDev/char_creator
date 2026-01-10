import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spells_and_tools/features/5e/character/character_provider.dart';
import 'package:spells_and_tools/features/5e/spells/edit_spells/edit_spell_page.dart'
    show EditSpellPage;
import 'package:spells_and_tools/features/authentication/auth_controller.dart';
import 'package:spells_and_tools/views/initial_page.dart';
import 'package:spells_and_tools/views/settings_page.dart';

import '../../utils/utils_page.dart';
import '../../views/see_you_soon_page.dart';
import '../5e/character/character_5e_page.dart';
import '../5e/character/edit_character_5e_page.dart';
import '../5e/character/list_of_characters_page.dart';
import '../5e/spells/pages/list_of_spells_page.dart';
import '../5e/spells/pages/spell_card_page.dart';
import '../5e/spells/view_models/spell_view_models_provider.dart';
import '../about_app/about_widget.dart';
import '../app_version/app_version_interactor.dart';
import '../app_version/update_required_page.dart';
import '../authentication/pages/account_page.dart';
import '../authentication/pages/sign_in_anonymously_page.dart';
import '../authentication/pages/sign_in_page.dart';
import '../main_menu/main_menu.dart';
import '../onboarding/pages/consents_page.dart';
import '../onboarding/pages/onboarding_explore_spells_page.dart';
import '../onboarding/pages/onboarding_home_page.dart';
import '../onboarding/pages/update_agreements_dialog.dart';
import 'redirect_manager.dart';

final goRouterProvider = Provider(
  (ref) => Navigation.goRouter(ref),
);

class Navigation {
  static GoRouter goRouter(Ref ref) => GoRouter(
        debugLogDiagnostics: kDebugMode,
        initialLocation: '/',
        redirect: (context, state) {
          if (state.uri.toString().contains('google/link?')) {
            return '/';
          }
          return null;
        },
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
              final redirectPath = RedirectManager.getRedirectPath(
                context: context,
                state: state,
                ref: ref,
              );
              return redirectPath;
            },
            builder: (context, state) => const MainMenuPage(),
            routes: [
              GoRoute(
                path: '/updateAgreements',
                pageBuilder: (context, state) {
                  return UpdateAgreementsDialog.route(
                    context: context,
                  );
                },
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
              GoRoute(
                path: '/spells',
                builder: (context, state) => const ListOfSpellsPage(),
                routes: [
                  GoRoute(
                    path: '/new',
                    builder: (context, state) => Consumer(
                      builder: (context, ref, child) {
                        return EditSpellPage();
                      },
                    ),
                  ),
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
                    routes: [
                      GoRoute(
                        path: '/edit',
                        builder: (context, state) {
                          final spellId = state.pathParameters['id']!;
                          return EditSpellPage(
                            spellId: spellId,
                          );
                        },
                      )
                    ],
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
                    path: '/:characterId',
                    builder: (context, state) {
                      final characterId = state.pathParameters['characterId']!;
                      return SelectedCharacterIdProvider(
                        selectedCharacterId: characterId,
                        child: Character5ePage(
                          characterId: characterId,
                        ),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: '/edit',
                        builder: (context, state) {
                          final characterId =
                              state.pathParameters['characterId']!;
                          return EditCharacter5ePage(
                            characterId: characterId,
                          );
                        },
                      ),
                      GoRoute(
                        path: '/addSpells',
                        builder: (context, state) {
                          final characterId =
                              state.pathParameters['characterId']!;
                          return ListOfSpellsPage(
                            targetCharacterId: characterId,
                          );
                        },
                      ),
                      GoRoute(
                        path: '/spells',
                        builder: (context, state) {
                          /// TODO: add scroll to spells functionality
                          final characterId =
                              state.pathParameters['characterId']!;
                          return SelectedCharacterIdProvider(
                            selectedCharacterId: characterId,
                            child: Character5ePage(
                              characterId: characterId,
                            ),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: '/:spellId',
                            builder: (context, state) {
                              final spellId = state.pathParameters['spellId']!;
                              final characterId =
                                  state.pathParameters['characterId'];
                              return SelectedCharacterIdProvider(
                                selectedCharacterId: characterId,
                                child: SpellCardPage(
                                  id: spellId,
                                  spellsFuture:
                                      ref.read(spellViewModelsProvider.future),
                                ),
                              );
                            },
                          ),
                        ],
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
            builder: (context, state) {
              return ConsentsPage(
                onAccepted: (context, ref) {
                  context.push('/onboarding/start');
                },
              );
            },
            routes: [
              GoRoute(
                path: '/start',
                builder: (context, state) => const OnboardingHomePage(),
              ),
              GoRoute(
                path: '/signIn',
                builder: (context, state) => SignInPage.signIn(
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
                    context.go('/onboarding/exploreSpells');
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
                path: '/register',
                builder: (context, state) => SignInPage.register(
                  onAuthenticated: (context) {
                    context.go('/onboarding/exploreSpells');
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

              /// Currently not used
              GoRoute(
                path: '/exploreSpells',
                builder: (context, state) => OnboardingExploreSpellsPage(
                  onContinue: (context) {
                    context.go('/onboarding/consents');
                  },
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/updateRequired',
            redirect: (context, state) async {
              final isUpdateRequired =
                  await ref.read(isUpdateRequiredProvider.future);
              if (!isUpdateRequired) {
                return '/';
              }
              return null;
            },
            builder: (context, state) => const UpdateRequiredPage(),
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
            path: '/about',
            pageBuilder: (context, state) => AboutAppDialog.route(
              context: context,
            ),
          ),
          GoRoute(
            path: '/licenses',
            builder: (context, state) => const LicensePage(),
          ),
        ],
      );
}
