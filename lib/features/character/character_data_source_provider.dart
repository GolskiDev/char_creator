//InheritedWidget CharacterProvider
import 'package:char_creator/features/character/character.dart';
import 'package:flutter/material.dart';

import 'character_temp_data_source.dart';

class CharacterDataSourceProvider extends InheritedWidget {
  final CharacterTempDataSource characterTempDataSource;

  CharacterDataSourceProvider({
    super.key,
    required super.child,
    required this.characterTempDataSource,
  }) {
    characterTempDataSource.addCharacter(Character(id: '1', name: 'Test'));
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static CharacterDataSourceProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CharacterDataSourceProvider>();
  }
}
