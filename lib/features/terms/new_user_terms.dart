import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data_sources/agreements_documents_data_source.dart';
import 'data_sources/user_accepted_agreements_data_source.dart';

final latestEffectiveAgreementStreamProvider =
    StreamProvider.family<AgreementDetails?, AgreementType>(
  (ref, type) {
    final agreementsDocumentsDataSource =
        ref.watch(agreementsDocumentsDataSourceProvider);

    return agreementsDocumentsDataSource.latestEffectiveAgreementStream(
      type: type,
    );
  },
);
