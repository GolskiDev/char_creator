import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spells_and_tools/features/daily_messages/daily_messages_spells/daily_messages_spells.dart';
import 'package:spells_and_tools/services/firestore.dart';

final dailyMessagesSpellsRemoteRepositoryProvider =
    Provider<DailyMessagesSpellsRemoteRepository>(
  (ref) {
    final firestore = ref.watch(firestoreProvider);
    return DailyMessagesSpellsRemoteRepository(
      firestore: firestore,
    );
  },
);

class DailyMessagesSpellsRemoteRepository {
  final FirebaseFirestore firestore;

  DailyMessagesSpellsRemoteRepository({required this.firestore});

  Future<List<DailyMessageSpellModel>> fetchRemoteDailyMessages() async {
    final snapshot = await firestore.collection('dailyTexts').get();
    return snapshot.docs.map(
      (doc) {
        final data = doc.data();
        return DailyMessageSpellModel(
          id: doc.id,
          spellId: data['spellId'] as String,
          subtitle: data['subtitle'] as String,
        );
      },
    ).toList();
  }
}
