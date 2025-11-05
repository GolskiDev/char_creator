import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spells_and_tools/features/authentication/auth_controller.dart';

import '../../../../services/firestore.dart';
import '../models/base_spell_model.dart';
import '../view_models/spell_view_model.dart';
import 'user_spell_model_v1.dart';

final userSpellViewModelsProvider = FutureProvider<List<SpellViewModel>>(
  (ref) async {
    final userSpells = await ref.watch(userSpellsProvider.future);
    final spellViewModels = userSpells
        .map(
          (userSpell) => userSpell.toSpellViewModel(),
        )
        .toList();
    return spellViewModels;
  },
);

final userSpellsProvider = StreamProvider<List<UserSpellModelV1>>(
  (ref) {
    final userSpellsRepository =
        ref.watch(userSpellsRepositoryProvider).asData?.value;
    if (userSpellsRepository == null) {
      return Stream.value([]);
    }
    return userSpellsRepository.stream;
  },
);

final userSpellsRepositoryProvider = FutureProvider<UserSpellsRepository?>(
  (ref) async {
    final firestore = ref.watch(firestoreProvider);
    final user = await ref.watch(currentUserProvider.future);
    final userId = user?.uid;
    if (userId == null) {
      return null;
    }
    return UserSpellsRepository(
      firestore: firestore,
      userId: userId,
    );
  },
);

class UserSpellsRepository {
  final FirebaseFirestore _firestore;
  static const String collectionPath = 'userSpells';
  final String userId;

  UserSpellsRepository({
    required FirebaseFirestore firestore,
    required this.userId,
  }) : _firestore = firestore;

  CollectionReference get _userSpellsCollection =>
      _firestore.collection(collectionPath);

  Stream<List<UserSpellModelV1>> get stream {
    return _userSpellsCollection
        .where(
          'ownerId',
          isEqualTo: userId,
        )
        .snapshots()
        .asyncMap(
      (snapshot) {
        return snapshot.docs
            .map(
              (doc) {
                try {
                  final data = doc.data() as Map<String, dynamic>;
                  return UserSpellModelV1.fromMap(data);
                } catch (e) {
                  return null;
                }
              },
            )
            .nonNulls
            .toList();
      },
    );
  }

  Future<void> addSpell(BaseSpellModel spell) async {
    final userSpell = UserSpellModelV1.newSpell(ownerId: userId, spell: spell);
    final docRef = _userSpellsCollection.doc(userSpell.id);
    await docRef.set(userSpell.toMap());
  }

  Future<void> deleteSpell(String spellId) async {
    final docRef = _userSpellsCollection.doc(spellId);
    await docRef.delete();
  }

  Future<void> updateSpell(UserSpellModelV1 spell) async {
    final docRef = _userSpellsCollection.doc(spell.id);
    await docRef.update(spell.toMap());
  }
}
