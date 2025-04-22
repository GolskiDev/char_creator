import 'package:flutter/material.dart';

import '../../../game_system_view_model.dart';

class Open5eMonsterModel {
  final String name;
  final String slug;
  final String size;
  final String type;
  final String subtype;
  final String? group;
  final String alignment;
  final String armorClass;
  final String armorDescription;
  final String hitPoints;
  final String hitDice;
  final Map<String, dynamic> speed;
  final String strength;
  final String dexterity;
  final String constitution;
  final String intelligence;
  final String wisdom;
  final String charisma;
  final String strengthSave;
  final String dexteritySave;
  final String constitutionSave;
  final String intelligenceSave;
  final String wisdomSave;
  final String charismaSave;

  final String perception;

  final Map<String, dynamic> skills;
  final String damageVulnerabilities;
  final String damageResistances;
  final String damageImmunities;
  final String conditionImmunities;
  final String senses;
  final String languages;
  final double cr;
  final Map<String, dynamic>? actions;
  final Map<String, dynamic>? legendaryActions;
  final Map<String, dynamic>? reactions;
  final String? legendaryDescription;
  final Map<String, dynamic>? legendaryActionsDescription;
  final Map<String, dynamic>? specialAbilities;

  /// links
  final List<String> spellList;
  final List<String> environments;

  Open5eMonsterModel({
    required this.name,
    required this.slug,
    required this.size,
    required this.type,
    required this.subtype,
    required this.group,
    required this.alignment,
    required this.armorClass,
    required this.armorDescription,
    required this.hitPoints,
    required this.hitDice,
    required this.speed,
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
    required this.strengthSave,
    required this.dexteritySave,
    required this.constitutionSave,
    required this.intelligenceSave,
    required this.wisdomSave,
    required this.charismaSave,
    required this.perception,
    required this.skills,
    required this.damageVulnerabilities,
    required this.damageResistances,
    required this.damageImmunities,
    required this.conditionImmunities,
    required this.senses,
    required this.languages,
    required this.cr,
    required this.actions,
    required this.legendaryActions,
    required this.reactions,
    required this.legendaryDescription,
    required this.legendaryActionsDescription,
    required this.specialAbilities,
    required this.spellList,
    required this.environments,
  });

  factory Open5eMonsterModel.fromMap(Map<String, dynamic> map) {
    return Open5eMonsterModel(
      name: map['name'] ?? '',
      slug: map['slug'] ?? '',
      size: map['size'] ?? '',
      type: map['type'] ?? '',
      subtype: map['subtype'] ?? '',
      group: map['group'] ?? '',
      alignment: map['alignment'] ?? '',
      armorClass: map['armor_class'] ?? '',
      armorDescription: map['armor_description'] ?? '',
      hitPoints: map['hit_points'] ?? '',
      hitDice: map['hit_dice'] ?? '',
      speed: map['speed'] ?? {},
      strength: map['strength']?.toString() ?? '0',
      dexterity: map['dexterity']?.toString() ?? '0',
      constitution: map['constitution']?.toString() ?? '0',
      intelligence: map['intelligence']?.toString() ?? '0',
      wisdom: map['wisdom']?.toString() ?? '0',
      charisma: map['charisma']?.toString() ?? '0',
      strengthSave: map['strength_save']?.toString() ?? '0',
      dexteritySave: map['dexterity_save']?.toString() ?? '0',
      constitutionSave: map['constitution_save']?.toString() ?? '0',
      intelligenceSave: map['intelligence_save']?.toString() ?? '0',
      wisdomSave: map['wisdom_save']?.toString() ?? '0',
      charismaSave: map['charisma_save']?.toString() ?? '0',
      perception:
          (map['perception'] != null) ? (map['perception'].toString()) : '0',
      skills: (map['skills']) != null
          ? Map<String, dynamic>.from(map['skills'])
          : {},
      damageVulnerabilities: (map['damage_vulnerabilities']) != null
          ? (map['damage_vulnerabilities'].toString())
          : '',
      damageResistances: (map['damage_resistances']) != null
          ? (map['damage_resistances'].toString())
          : '',
      damageImmunities: (map['damage_immunities']) != null
          ? (map['damage_immunities'].toString())
          : '',
      conditionImmunities: (map['condition_immunmunities']) != null
          ? (map['condition_immunities'].toString())
          : '',
      senses: (map['senses']) != null ? (map['senses'].toString()) : '',
      languages:
          (map['languages']) != null ? (map['languages'].toString()) : '',
      cr: (map['cr'] != null) ? double.parse(map['cr'].toString()) : 0.0,
      actions: (map['actions']) != null
          ? Map<String, dynamic>.from(map['actions'])
          : {},
      legendaryActions: (map['legendary_actions']) != null
          ? Map<String, dynamic>.from(map['legendary_actions'])
          : {},
      reactions: (map['reactions']) != null
          ? Map<String, dynamic>.from(map['reactions'])
          : {},
      legendaryDescription: (map['legendary_description'] != null)
          ? map['legendary_description']
          : '',
      legendaryActionsDescription:
          (map['legendary_actions_description'] != null)
              ? Map<String, dynamic>.from(map['legendary_actions_description'])
              : {},
      specialAbilities: (map['special_abilities'] != null)
          ? Map<String, dynamic>.from(map['special_abilities'])
          : {},
      spellList: List<String>.from(map['spell_list'] ?? []),
      environments: List<String>.from(map['environments'] ?? []),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'slug': slug,
      'size': size,
      'type': type,
      'subtype': subtype,
      'group': group,
      'alignment': alignment,
      'armor_class': armorClass,
      'armor_description': armorDescription,
      'hit_points': hitPoints,
      'hit_dice': hitDice,
      'speed': speed,
      'strength': strength,
      'dexterity': dexterity,
      'constitution': constitution,
      'intelligence': intelligence,
      'wisdom': wisdom,
      'charisma': charisma,
      'strength_save': strengthSave,
      'dexterity_save': dexteritySave,
      'constitution_save': constitutionSave,
      'intelligence_save': intelligenceSave,
      'wisdom_save': wisdomSave,
      'charisma_save': charismaSave,
      'perception': perception,
      'skills': skills,
      'damage_vulnerabilities': damageVulnerabilities,
      'damage_resistances': damageResistances,
      'damage_immunities': damageImmunities,
      'condition_immunities': conditionImmunities,
      'senses': senses,
      'languages': languages,
      'cr': cr.toString(),
      'actions': actions ?? {},
      'legendary_actions': legendaryActions ?? {},
      'reactions': reactions ?? {},
      'legendary_description': legendaryDescription ?? '',
      'legendary_actions_description': legendaryActionsDescription ?? {},
      'special_abilities': specialAbilities ?? {},
    };
  }
}

class Open5eMonsterWidget extends StatelessWidget {
  final Open5eMonsterModel monster;

  const Open5eMonsterWidget({super.key, required this.monster});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(monster.name, style: Theme.of(context).textTheme.titleLarge),
            ListTile(
              title: Text('Type'),
              subtitle: Text(monster.type),
            ),
            ListTile(
              title: Text('Challenge Rating'),
              subtitle: Text('${monster.cr}'),
            ),
            ListTile(
              leading: Icon(GameSystemViewModel.maxHp.icon),
              title: Text(GameSystemViewModel.maxHp.name),
              subtitle: Text(monster.hitPoints),
            ),
            ListTile(
              leading: Icon(GameSystemViewModel.speed.icon),
              title: Text('Speed'),
              subtitle: Text(monster.speed.toString()),
            ),
            ListTile(
              title: Text('Armor Class'),
              subtitle:
                  Text('${monster.armorClass} (${monster.armorDescription})'),
            ),
            ListTile(
              title: Text('Abilities'),
              subtitle: Text(
                  'STR: ${monster.strength}, DEX: ${monster.dexterity}, CON: ${monster.constitution}, '
                  'INT: ${monster.intelligence}, WIS: ${monster.wisdom}, CHA: ${monster.charisma}'),
            ),
          ],
        ),
      ),
    );
  }
}
