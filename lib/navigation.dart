import 'package:go_router/go_router.dart';

import 'views/character_page.dart';
import 'views/list_of_characters_page.dart';
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
              return CharacterPage(
                characterId: id,
              );
            },
            routes: [
              GoRoute(
                path: "chat",
                builder: (context, state) {
                  final String id = state.pathParameters['id']!;
                  return ChatPage(
                    characterId: id,
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
