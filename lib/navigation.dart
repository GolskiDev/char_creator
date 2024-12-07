import 'package:char_creator/views/document_page.dart';
import 'package:go_router/go_router.dart';

import 'views/chat_page.dart';
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
