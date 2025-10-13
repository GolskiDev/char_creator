import 'package:cloud_firestore/cloud_firestore.dart';

import 'agreements_documents_data_source.dart';
import 'user_accepted_agreements_data_source.dart';

extension AgreementDetailsFirestore on AgreementDetails {
  Map<String, dynamic> toFirestore() {
    return {
      'effectiveDate': Timestamp.fromDate(effectiveDate),
      'version': version,
      'type': type.name,
      'extra': extra,
    };
  }

  static AgreementDetails fromFirestore(Map<String, dynamic> map) {
    return AgreementDetails(
      effectiveDate: (map['effectiveDate'] as Timestamp).toDate(),
      type: AgreementType.fromString(map['type'] as String),
      version: map['version'] as String,
      extra: map['extra'] as Map<String, dynamic>?,
    );
  }
}

class FirebaseAgreementsDocumentsDataSource
    implements AgreementsDocumentsDataSource {
  final FirebaseFirestore firestore;

  FirebaseAgreementsDocumentsDataSource({
    required this.firestore,
  });

  static String privacyPolicyCollectionPath = 'privacyPoliciesDocuments';
  static String termsOfUseCollectionPath = 'termsOfUseDocuments';

  CollectionReference get _privacyPolicyCollection =>
      firestore.collection(privacyPolicyCollectionPath);
  CollectionReference get _termsOfUseCollection =>
      firestore.collection(termsOfUseCollectionPath);

  CollectionReference collectionForType(AgreementType type) {
    switch (type) {
      case AgreementType.termsOfUse:
        return _termsOfUseCollection;
      case AgreementType.privacyPolicy:
        return _privacyPolicyCollection;
    }
  }

  @override
  Stream<List<AgreementDetails>> getAgreementDetailsStream({
    required AgreementType type,
    DateTime? before,
  }) {
    CollectionReference collection = collectionForType(type);

    Query<Object?> query =
        collection.orderBy('effectiveDate', descending: true);
    if (before != null) {
      final afterTimestamp = Timestamp.fromDate(before);
      query = query.where('effectiveDate', isLessThanOrEqualTo: afterTimestamp);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AgreementDetailsFirestore.fromFirestore(
            data as Map<String, dynamic>);
      }).toList();
    });
  }

  @override
  Stream<AgreementDetails?> latestEffectiveAgreementStream({
    required AgreementType type,
  }) {
    CollectionReference collection = collectionForType(type);
    Query<Object?> query = collection
        .orderBy('effectiveDate', descending: true)
        .where('effectiveDate', isLessThanOrEqualTo: Timestamp.now())
        .limit(1);
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AgreementDetailsFirestore.fromFirestore(
            data as Map<String, dynamic>);
      }).firstOrNull;
    });
  }
}
