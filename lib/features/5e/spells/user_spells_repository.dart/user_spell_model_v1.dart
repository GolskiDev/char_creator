import 'package:spells_and_tools/features/5e/spells/models/base_spell_model.dart';

import '../../../../common/interfaces/identifiable.dart';
import '../view_models/spell_view_model.dart';

class UserSpellModelV1 extends Identifiable {
  @override
  final String id;
  final String ownerId;
  final BaseSpellModel spell;

  UserSpellModelV1({
    required this.ownerId,
    required this.id,
    required this.spell,
  });

  UserSpellModelV1 copyWith({
    String? ownerId,
    String? id,
    BaseSpellModel? spell,
  }) {
    return UserSpellModelV1(
      ownerId: ownerId ?? this.ownerId,
      id: id ?? this.id,
      spell: spell ?? this.spell,
    );
  }

  factory UserSpellModelV1.newSpell({
    required String ownerId,
    required BaseSpellModel spell,
  }) {
    return UserSpellModelV1(
      id: IdGenerator.generateId(UserSpellModelV1),
      ownerId: ownerId,
      spell: spell,
    );
  }

  factory UserSpellModelV1.fromMap(Map<String, dynamic> map) {
    return UserSpellModelV1(
      id: map['id'] as String,
      ownerId: map['ownerId'] as String,
      spell: BaseSpellModel.fromMap(map),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      ...spell.toMap(),
    };
  }

  SpellViewModel toSpellViewModel() {
    return SpellViewModel(
      id: id,
      ownerId: ownerId,
      name: spell.name,
      description: spell.description,
      spellLevel: spell.spellLevel,
      school: spell.school,
      castingTime: spell.castingTime,
      range: spell.range,
      duration: spell.duration,
      atHigherLevels: spell.atHigherLevels,
      canBeCastAsRitual: spell.canBeCastAsRitual,
      characterClasses: {},
      imageUrl: spell.imageUrl,
      requiresConcentration: spell.requiresConcentration,
      requiresMaterialComponent: spell.requiresMaterialComponent,
      requiresSomaticComponent: spell.requiresSomaticComponent,
      requiresVerbalComponent: spell.requiresVerbalComponent,
      material: spell.material,
      spellTypes: spell.spellTypes,
    );
  }
}
