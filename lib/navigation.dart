import 'package:char_creator/views/document_page.dart';
import 'package:go_router/go_router.dart';

import 'features/spells/cards_page.dart';
import 'features/spells/list_of_spells_page.dart';
import 'views/chat_page.dart';
import 'views/list_of_documents_page.dart';

class Navigation {
  static final goRouter = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/spells',
      ),
      GoRoute(
        path: '/spells',
        builder: (context, state) => const ListOfSpellsPage(),
        routes: [
          GoRoute(
            path: '/:id',
            builder: (context, state) => CardPage(
              slug: state.pathParameters['id']!,
            ),
          ),
        ]
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
  );
}
