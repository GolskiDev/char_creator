import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppVersionsRepository {
  final FirebaseFirestore _firestore;

  AppVersionsRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

      CollectionReference<Map<String, dynamic>> get _collection =>
        _firestore.collection('appVersions');

  Future<Map<String, dynamic>> getVersionDoc(String docId) async {
    final doc = await _collection.doc(docId).get();
    return doc.data() ?? {};
  }

  Future<void> setVersionDoc(String docId, Map<String, dynamic> data) async {
    await _collection.doc(docId).set(data);
  }

  Stream<Map<String, dynamic>> streamVersionDoc(String docId) {
    return _collection.doc(docId).snapshots().map((doc) => doc.data() ?? {});
  }
}

final appVersionsRepositoryProvider = Provider<AppVersionsRepository>((ref) {
  return AppVersionsRepository();
});

final appVersionProvider = StreamProvider.family<Map<String, dynamic>, String>((
  ref,
  docId,
) {
  final repo = ref.watch(appVersionsRepositoryProvider);
  return repo.streamVersionDoc(docId);
});
