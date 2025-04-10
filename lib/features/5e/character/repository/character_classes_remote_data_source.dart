import 'dart:async';

import 'package:char_creator/features/5e/srd_classes/premade_character_classes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/character_5e_class_model_v1.dart';

final characterClassesRemoteDataSourceProvider = Provider(
  (ref) => CharacterClassesRemoteDataSource(),
);

class CharacterClassesRemoteDataSource {
  final StreamController<List<ICharacter5eClassModelV1>> _controller =
      StreamController<List<ICharacter5eClassModelV1>>.broadcast();

  Stream<List<ICharacter5eClassModelV1>> get stream => _controller.stream;

  CharacterClassesRemoteDataSource() {
    _controller.onListen = _refreshStream;
  }

  Future<void> _refreshStream() async {
    final classes = _characterClassJson.map((entry) {
      return Character5eCustomClassModelV1.fromMap(entry);
    }).toList();
    _controller.add(classes);
  }

  void dispose() {
    _controller.close();
  }

  List<Map<String, dynamic>> get _characterClassJson {
    return PremadeCharacterClasses.premadeCharacterClassesMaps;
  }
}
