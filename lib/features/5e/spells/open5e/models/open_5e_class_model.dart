import 'package:char_creator/views/default_page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown/markdown.dart' as md;

import '../../../game_system_view_model.dart';
import '../open_5e_collection_repository.dart';

class Open5eClassModel {
  final String name;
  final String slug;
  final String desc;
  final String hitDice;
  final String hpAt1stLevel;
  final String hpAtHigherLevels;
  final String profArmor;
  final String profWeapons;
  final String profTools;
  final String profSavingThrows;
  final String profSkills;
  final String? startingEquipment;
  final String table;
  final String spellcastingAbility;
  final String subtypesName;

  Open5eClassModel({
    required this.name,
    required this.slug,
    required this.desc,
    required this.hitDice,
    required this.hpAt1stLevel,
    required this.hpAtHigherLevels,
    required this.profArmor,
    required this.profWeapons,
    required this.profTools,
    required this.profSavingThrows,
    required this.profSkills,
    required this.startingEquipment,
    required this.table,
    required this.spellcastingAbility,
    required this.subtypesName,
  });

  Open5eClassModel copyWith({
    String? name,
    String? slug,
    String? desc,
    String? hitDice,
    String? hpAt1stLevel,
    String? hpAtHigherLevels,
    String? profArmor,
    String? profWeapons,
    String? profTools,
    String? profSavingThrows,
    String? profSkills,
    String? startingEquipment,
    String? table,
    String? spellcastingAbility,
    String? subtypesName,
  }) {
    return Open5eClassModel(
      name: name ?? this.name,
      slug: slug ?? this.slug,
      desc: desc ?? this.desc,
      hitDice: hitDice ?? this.hitDice,
      hpAt1stLevel: hpAt1stLevel ?? this.hpAt1stLevel,
      hpAtHigherLevels: hpAtHigherLevels ?? this.hpAtHigherLevels,
      profArmor: profArmor ?? this.profArmor,
      profWeapons: profWeapons ?? this.profWeapons,
      profTools: profTools ?? this.profTools,
      profSavingThrows: profSavingThrows ?? this.profSavingThrows,
      profSkills: profSkills ?? this.profSkills,
      startingEquipment: startingEquipment ?? this.startingEquipment,
      table: table ?? this.table,
      spellcastingAbility: spellcastingAbility ?? this.spellcastingAbility,
      subtypesName: subtypesName ?? this.subtypesName,
    );
  }

  factory Open5eClassModel.fromMap(Map<String, dynamic> map) {
    return Open5eClassModel(
      name: map['name'] as String,
      slug: map['slug'] as String,
      desc: map['desc'] as String,
      hitDice: map['hit_dice'] as String,
      hpAt1stLevel: map['hp_at_1st_level'] as String,
      hpAtHigherLevels: map['hp_at_higher_levels'] as String,
      profArmor: map['prof_armor'] as String,
      profWeapons: map['prof_weapons'] as String,
      profTools: map['prof_tools'] as String,
      profSavingThrows: map['prof_saving_throws'] as String,
      profSkills: map['prof_skills'] as String,
      startingEquipment: map['starting_equipment'] as String?,
      table: map['table'] as String,
      spellcastingAbility: map['spellcasting_ability'] as String,
      subtypesName: map['subtypes_name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'slug': slug,
      'desc': desc,
      'hit_dice': hitDice,
      'hp_at_1st_level': hpAt1stLevel,
      'hp_at_higher_levels': hpAtHigherLevels,
      'prof_armor': profArmor,
      'prof_weapons': profWeapons,
      'prof_tools': profTools,
      'prof_saving_throws': profSavingThrows,
      'prof_skills': profSkills,
      'starting_equipment': startingEquipment,
      'table': table,
      'spellcasting_ability': spellcastingAbility,
      'subtypes_name': subtypesName,
    };
  }
}

class Open5eClassPage extends ConsumerWidget {
  const Open5eClassPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classes = ref.watch(open5eClassesProvider.future);
    return Scaffold(
      appBar: AppBar(
        title: Text("Classes"),
      ),
      body: DefaultPageWrapper(
        future: classes,
        builder: (context, data) => ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: data.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: 4,
          ),
          itemBuilder: (context, index) {
            final classModel = data[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                title: Text(classModel.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text(classModel.name),
                        ),
                        body: SafeArea(
                          child: SingleChildScrollView(
                            child: Open5eClassWidget(
                              classModel: classModel,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class Open5eClassWidget extends StatelessWidget {
  final Open5eClassModel classModel;

  const Open5eClassWidget({super.key, required this.classModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Html(
              extensions: [
                TableHtmlExtension(),
              ],
              data: md.markdownToHtml(
                classModel.desc,
                extensionSet: md.ExtensionSet.gitHubWeb,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              primary: false,
              scrollDirection: Axis.horizontal,
              child: Html(
                data: md.markdownToHtml(
                  classModel.table,
                  extensionSet: md.ExtensionSet.gitHubWeb,
                ),
                extensions: [
                  TableHtmlExtension(),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('Hit Dice'),
            subtitle: Text(classModel.hitDice),
          ),
          ListTile(
            title: Text('HP at 1st Level'),
            subtitle: Text(classModel.hpAt1stLevel),
          ),
          ListTile(
            title: Text('HP at Higher Levels'),
            subtitle: Text(classModel.hpAtHigherLevels),
          ),
          ListTile(
            title: Text('Proficiencies'),
            subtitle: Text(
                'Armor: ${classModel.profArmor}, Weapons: ${classModel.profWeapons}, Tools: ${classModel.profTools}'),
          ),
          ListTile(
            title: Text('Saving Throws'),
            subtitle: Text(classModel.profSavingThrows),
          ),
          ListTile(
            leading: Icon(GameSystemViewModel.skills.icon),
            title: Text('Skills'),
            subtitle: Text(classModel.profSkills),
          ),
          ListTile(
            title: Text('Spellcasting Ability'),
            subtitle: Text(classModel.spellcastingAbility),
          ),
        ],
      ),
    );
  }
}
