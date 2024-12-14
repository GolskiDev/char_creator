import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'document.dart';
import 'document_repository.dart';

final documentsProvider = StreamProvider<List<Document>>(
  (ref) async* {
    final repository = ref.watch(documentRepositoryProvider);
    yield* repository.stream;
  },
);

final documentRepositoryProvider = Provider<DocumentRepository>(
  (ref) => DocumentRepository(),
);
