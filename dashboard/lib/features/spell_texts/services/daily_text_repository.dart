import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/daily_text.dart';

class DailyTextRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('dailyTexts');

  Future<List<DailyText>> fetchAll() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => DailyText.fromJson({
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            }))
        .toList();
  }

  Future<void> add(DailyText text) async {
    await _collection.doc(text.id).set(text.toJson());
  }

  Future<void> update(DailyText text) async {
    await _collection.doc(text.id).update(text.toJson());
  }

  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
