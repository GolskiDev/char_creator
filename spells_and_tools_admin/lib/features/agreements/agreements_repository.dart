import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'agreement_model.dart';

// Provider for AgreementsRepository
final agreementsRepositoryProvider = Provider<AgreementsRepository>((ref) {
  return AgreementsRepository();
});

// StreamProvider.family for agreements by type
final agreementsProvider =
    StreamProvider.family<List<AgreementModel>, AgreementType>((ref, type) {
      final repo = ref.watch(agreementsRepositoryProvider);
      return repo.streamAll(type);
    });

extension AgreementsRepositoryStream on AgreementsRepository {
  Stream<List<AgreementModel>> streamAll(AgreementType type) {
    return _collection(type).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => AgreementModel.fromFirestore(doc))
          .toList(),
    );
  }
}

class AgreementsRepository {
  final FirebaseFirestore _firestore;

  AgreementsRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(AgreementType type) {
    return _firestore.collection(type.collectionName);
  }

  Future<List<AgreementModel>> getAll(AgreementType type) async {
    final querySnapshot = await _collection(type).get();
    return querySnapshot.docs
        .map((doc) => AgreementModel.fromFirestore(doc))
        .toList();
  }

  Future<AgreementModel?> getByVersion(
    AgreementType type,
    String version,
  ) async {
    final query = await _collection(
      type,
    ).where('version', isEqualTo: version).limit(1).get();
    if (query.docs.isEmpty) return null;
    return AgreementModel.fromFirestore(query.docs.first);
  }

  Future<void> addAgreement(AgreementModel agreement) async {
    await _collection(
      agreement.type,
    ).doc(agreement.version.replaceAll(".", "-")).set(agreement.toFirestore());
  }

  Future<void> updateAgreement(String docId, AgreementModel agreement) async {
    await _collection(
      agreement.type,
    ).doc(docId).update(agreement.toFirestore());
  }

  Future<void> deleteAgreement(AgreementType type, String version) async {
    await _collection(type).doc(version.replaceAll(".", "-")).delete();
  }
}
