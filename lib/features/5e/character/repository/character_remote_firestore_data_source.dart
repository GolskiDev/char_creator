import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/firestore.dart';
import '../../../authentication/auth_controller.dart';
import '../models/character_5e_model_v1.dart';

final characterRemoteFirestoreDataSourceProvider = FutureProvider(
  (ref) async {
    final firestore = ref.watch(firestoreProvider);
    final userId = await ref.watch(currentUserProvider.future);
    if (userId == null) {
      return null;
    }
    return UserCharactersRemoteFirestoreDataSource(
      userId: userId.uid,
      firestore: firestore,
    );
  },
);

class UserCharactersRemoteFirestoreDataSource {
  final String userId;
  final FirebaseFirestore _firestore;

  static const String collectionPath = 'characters';

  UserCharactersRemoteFirestoreDataSource({
    required this.userId,
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get collection => _firestore.collection(collectionPath);
  Query get query => collection.where('ownerId', isEqualTo: userId);

  Future<void> saveCharacter(Character5eModelV1 character) async {
    await collection.doc(character.id).set(
      {
        ...character.toMap(),
        'ownerId': userId,
      },
    );
  }

  Future<List<Character5eModelV1>> getAllUserCharacters() async {
    final snapshot = await query.get();
    return snapshot.docs
        .map(
          (doc) =>
              Character5eModelV1.fromMap(doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> updateCharacter(Character5eModelV1 updatedCharacter) async {
    await collection.doc(updatedCharacter.id).set(
          updatedCharacter.toMap(),
          SetOptions(merge: true),
        );
  }

  Future<void> deleteCharacter(String characterId) async {
    await collection.doc(characterId).delete();
  }

  Stream<List<Character5eModelV1>> get allUserCharactersStream {
    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Character5eModelV1.fromMap(
                    doc.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }
}
