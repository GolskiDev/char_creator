import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'character/character.dart';
import 'character/character_providers.dart';
import 'character/widgets/character_page.dart';
import 'character/widgets/list_of_characters_page.dart';
import 'default_async_id_page_builder.dart';
import 'views/chat_page.dart';

class Navigation {
  static final goRouter = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const ListOfCharactersPage(),
        routes: [
          GoRoute(
            path: "/characters/:id",
            redirect: (context, state) {
              final id = state.pathParameters['id'];
              if (id == null) {
                return "/characters";
              }
              return null;
            },
            builder: (context, state) {
              final String id = state.pathParameters['id']!;
              return Consumer(
                builder: (context, ref, child) =>
                    DefaultAsyncIdPageBuilder<Character>(
                  asyncValue: ref.watch(
                    characterByIdProvider(id),
                  ),
                  pageBuilder: (context, value) => CharacterPage(
                    character: value,
                  ),
                ),
              );
            },
            routes: [
              GoRoute(
                path: "chat",
                builder: (context, state) {
                  final String id = state.pathParameters['id']!;
                  return Consumer(
                    builder: (context, ref, child) =>
                        DefaultAsyncIdPageBuilder<Character>(
                      asyncValue: ref.watch(
                        characterByIdProvider(id),
                      ),
                      pageBuilder: (context, value) => ChatPage(
                        character: value,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      )
    ],
  );
}
