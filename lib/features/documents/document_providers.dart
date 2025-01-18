import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'document.dart';
import 'document_repository.dart';
import 'static_document_data_source.dart';

final documentsProvider = StreamProvider<List<Document>>(
  (ref) async* {
    final repository = ref.watch(documentRepositoryProvider);
    yield* repository.stream;
  },
);

final documentRepositoryProvider = Provider<DocumentRepository>(
  (ref) => DocumentRepository(
    ref.watch(staticDocumentDataSourceProvider),
  ),
);

final staticDocumentDataSourceProvider = Provider<StaticDocumentDataSource>(
  (ref) => StaticDocumentDataSource(),
);
