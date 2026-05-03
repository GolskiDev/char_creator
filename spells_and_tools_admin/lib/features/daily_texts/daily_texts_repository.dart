import 'package:cloud_firestore/cloud_firestore.dart';

import 'daily_text_model.dart';

class DailyTextsRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'dailyTexts',
  );

  Future<List<DailyText>> fetchDailyTexts() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map(
          (doc) => DailyText.fromJson({
            ...doc.data() as Map<String, dynamic>,
            'id': doc.id,
          }),
        )
        .toList();
  }

  Future<void> addDailyText(DailyText dailyText) async {
    await _collection.doc(dailyText.id).set(dailyText.toJson());
  }

  Future<void> updateDailyText(DailyText dailyText) async {
    await _collection.doc(dailyText.id).update(dailyText.toJson());
  }
}
