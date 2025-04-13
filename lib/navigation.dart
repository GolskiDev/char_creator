import 'package:char_creator/features/5e/spells/view_models/spell_view_model.dart';
import 'package:char_creator/views/document_page.dart';
import 'package:char_creator/views/settings_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/5e/character/character_5e_page.dart';
import 'features/5e/character/edit_character_5e_page.dart';
import 'features/5e/character/list_of_characters_page.dart';
import 'features/5e/main_menu.dart';
import 'features/5e/spells/list_of_spells_page.dart';
import 'features/5e/spells/spell_card_page.dart';
import 'utils/utils_page.dart';
import 'views/chat_page.dart';
import 'views/list_of_documents_page.dart';

final goRouterProvider = Provider(
  (ref) => Navigation.goRouter(ref),
);

class Navigation {
  static goRouter(Ref ref) => GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const MainMenuPage(),
            routes: [
              GoRoute(
                path: '/utils',
                builder: (context, state) => const UtilsPage(),
              ),
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
              GoRoute(
                path: '/documents',
                builder: (context, state) => const ListOfDocumentsPage(),
                routes: [
                  GoRoute(
                    path: '/:id',
                    builder: (context, state) => DocumentPage(
                      documentId: state.pathParameters['id']!,
                    ),
                    routes: [
                      GoRoute(
                        path: '/chat',
                        builder: (context, state) => ChatPage(
                          documentId: state.pathParameters['id']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: '/chat',
                builder: (context, state) => const ChatPage(),
                routes: [
                  GoRoute(
                    path: '/:id',
                    builder: (context, state) => ChatPage(
                      documentId: state.pathParameters['id']!,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      );
}
