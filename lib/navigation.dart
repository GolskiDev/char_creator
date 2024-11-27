import 'package:go_router/go_router.dart';

import 'views/character_page.dart';
import 'views/list_of_documents_page.dart';

class Navigation {
  static final goRouter = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/documents',
      ),
      GoRoute(
        path: '/documents',
        builder: (context, state) => const ListOfDocumentsPage(),
        routes: [
          GoRoute(
            path: '/:id',
            builder: (context, state) => CharacterPage(
              documentId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
    ],
  );
}
