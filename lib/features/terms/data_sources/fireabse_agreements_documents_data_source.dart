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

  @override
  Stream<List<AgreementDetails>> getTermsOfUseDetailsStream({
    DateTime? after,
  }) {
    Query<Object?> query =
        _termsOfUseCollection.orderBy('effectiveDate', descending: true);
    if (after != null) {
      final afterTimestmap = Timestamp.fromDate(after);
      query = query.where('effectiveDate', isGreaterThan: afterTimestmap);
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
  Stream<List<AgreementDetails>> getPrivacyPolicyDetailsStream({
    DateTime? after,
  }) {
    Query<Object?> query =
        _privacyPolicyCollection.orderBy('effectiveDate', descending: true);
    if (after != null) {
      final afterTimestmap = Timestamp.fromDate(after);
      query = query.where('effectiveDate', isGreaterThan: afterTimestmap);
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
  Stream<AgreementDetails?> latestEffectivePrivacyPolicyStream() {
    Query<Object?> query = _privacyPolicyCollection
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

  @override
  Stream<AgreementDetails?> latestEffectiveTermsOfUseStream() {
    Query<Object?> query = _termsOfUseCollection
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
