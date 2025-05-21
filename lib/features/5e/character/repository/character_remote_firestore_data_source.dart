import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/character_5e_model_v1.dart';

class CharacterRemoteFirestoreDataSource {
  final FirebaseFirestore firestore;
  final String collectionPath;

  CharacterRemoteFirestoreDataSource({
    FirebaseFirestore? firestore,
    this.collectionPath = 'characters',
  }) : firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveCharacter(Character5eModelV1 character) async {
    await firestore
        .collection(collectionPath)
        .doc(character.id)
        .set(character.toMap());
  }

  Future<List<Character5eModelV1>> getAllCharacters() async {
    final snapshot = await firestore.collection(collectionPath).get();
    return snapshot.docs
        .map((doc) => Character5eModelV1.fromMap(doc.data()))
        .toList();
  }

  Future<void> updateCharacter(Character5eModelV1 updatedCharacter) async {
    await firestore
        .collection(collectionPath)
        .doc(updatedCharacter.id)
        .update(updatedCharacter.toMap());
  }

  Future<void> deleteCharacter(String characterId) async {
    await firestore.collection(collectionPath).doc(characterId).delete();
  }
}
