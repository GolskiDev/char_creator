import 'package:go_router/go_router.dart';

import 'character/widgets/character_page.dart';
import 'character/widgets/list_of_characters_page.dart';

class Navigation {
  final goRouter = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const ListOfCharactersPage(),
        routes: [
          GoRoute(
            path: "/characters/:id",
            redirect: (context, state) {
              final id = state.pathParameters['id'];
              if(id == null) {
                return "/characters";
              }
            },
            builder: (context, state) {
              final String id = state.pathParameters['id']!;
              return CharacterPage(characterId: id,);
            }
          ),
        ],
      )
    ],
  );
}
