import 'package:char_creator/views/document_page.dart';
import 'package:go_router/go_router.dart';

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
          ),
        ],
      ),
    ],
  );
}
