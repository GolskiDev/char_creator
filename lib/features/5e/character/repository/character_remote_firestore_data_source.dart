import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/firestore.dart';
import '../models/character_5e_model_v1.dart';

final characterRemoteFirestoreDataSourceProvider = Provider(
  (ref) {
    final firestore = ref.watch(firestoreProvider);
    return CharacterRemoteFirestoreDataSource(
      firestore: firestore,
    );
  },
);

class CharacterRemoteFirestoreDataSource {
  final FirebaseFirestore _firestore;
  static const String collectionPath = 'characters';

  CharacterRemoteFirestoreDataSource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get collection => _firestore.collection(collectionPath);

  Future<void> saveCharacter(Character5eModelV1 character) async {
    await collection.doc(character.id).set(
          character.toMap(),
        );
  }

  Future<List<Character5eModelV1>> getAllCharacters() async {
    final snapshot = await collection.get();
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

  Stream<List<Character5eModelV1>> get stream {
    return collection.snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Character5eModelV1.fromMap(
                    doc.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }
}
