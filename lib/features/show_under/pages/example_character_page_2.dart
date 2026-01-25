import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../edit_property_page_builder.dart';
import '../example_character_data.dart';
import '../json_enums/enum_field_single_choice.dart';
import '../json_enums/json_enums.dart';
import '../widgets/character_widgets.dart';
import '../widgets/enum_single_choice_editor.dart';
import '../widgets/int_editor.dart';

class ExampleCharacterPage2 extends HookConsumerWidget {
  const ExampleCharacterPage2({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Example usage of the widgets
    final characterState = useState(exampleCharacter5e);
    final character = characterState.value;
    final abilityScores = character.abilityScores;

    Widget listTileThemeWrapper({required Widget child}) =>
        ListTileThemeWrapper(child: child);

    Widget traitBuilder({
      required String tag,
      required IconData icon,
      required String title,
      required String subtitle,
      Function()? onTap,
    }) =>
        TraitBuilder(
          tag: tag,
          icon: icon,
          title: title,
          subtitle: subtitle,
          onTap: onTap,
        );

    Widget groupBuilder({
      IconData? grupIcon,
      required String groupTitle,
      required List<Widget> children,
      double? preferredWidth,
    }) =>
        GroupBuilder(
          grupIcon: grupIcon,
          groupTitle: groupTitle,
          children: children,
          abilityScoresLength: abilityScores?.abilityScores.length ?? 0,
          listTileThemeWrapper: listTileThemeWrapper,
          preferredWidth: preferredWidth,
        );

    Widget othersBuilder() => OthersBuilder(
          ageBuilder: () {
            final age = character.others?.age;
            return TraitBuilder(
              tag: 'character.age',
              icon: Icons.cake,
              title: age?.toString() ?? '-',
              subtitle: 'Age',
              onTap: () async {
                final result = await Navigator.push<int>(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HookBuilder(
                        builder: (context) {
                          final age = useState<int?>(character.others?.age);
                          return EditPropertyPageBuilder(
                            propertyId: 'character.age',
                            editorWidgetBuilder: (context) {
                              return IntEditor(
                                value: age.value,
                                label: 'Age',
                                icon: Icons.cake,
                                onChanged: (val) {
                                  age.value = val;
                                },
                              );
                            },
                            onSaved: () {
                              Navigator.of(context).pop(age.value);
                            },
                          );
                        },
                      );
                    },
                  ),
                );
                if (result != null) {
                  characterState.value = character.copyWith(
                    others: character.others?.copyWith(age: () => result) ??
                        character.others,
                  );
                }
              },
            );
          },
          alignmentBuilder: () => traitBuilder(
            tag: 'character.alignment',
            icon: Icons.balance,
            title: 'Lawful Good',
            subtitle: 'Alignment',
          ),
          sizeBuilder: () => traitBuilder(
            tag: 'character.size',
            icon: Icons.height,
            title: 'Medium',
            subtitle: 'Size',
          ),
          speedBuilder: () => traitBuilder(
            tag: 'character.speed',
            icon: Icons.directions_walk,
            title: '30 ft.',
            subtitle: 'Speed',
          ),
          visionBuilder: () => traitBuilder(
            tag: 'character.vision',
            icon: Icons.remove_red_eye,
            title: 'Darkvision 60 ft.',
            subtitle: 'Vision',
          ),
          proficienciesBuilder: () => traitBuilder(
            tag: 'character.proficiencies',
            icon: Icons.build,
            title: 'Proficiencies',
            subtitle: 'Various Proficiencies',
          ),
          languagesBuilder: () => traitBuilder(
            tag: 'character.languages',
            icon: Icons.language,
            title: 'Languages',
            subtitle: 'Known Languages',
          ),
          listTileThemeWrapper: listTileThemeWrapper,
        );

    Widget raceBuilder() {
      // Example: get available races as a JsonEnum (replace with your real data source)
      final availableRaces = JsonEnum(
        id: 'race',
        title: 'Race',
        values: {
          JsonEnumValue(value: 'human', text: 'Human'),
          JsonEnumValue(value: 'elf', text: 'Elf'),
          JsonEnumValue(value: 'dwarf', text: 'Dwarf'),
        },
      );

      // Find the selected race from character.characterEnums.singleChoiceFields
      final selectedRaceField =
          character.characterEnums.singleChoiceFields.firstWhere(
        (field) => field.options.id == 'race',
        orElse: () =>
            EnumFieldSingleChoice(options: availableRaces, selectedValue: null),
      );
      final selectedRace = selectedRaceField.selectedValue;

      return ListTile(
        leading: const Icon(Icons.groups),
        title: Text(selectedRace?.text ?? 'Click here to add the race'),
        subtitle: Text(selectedRace == null
            ? 'No race selected'
            : 'Selected: ${selectedRace.text}'),
        onTap: () async {
          final result = await Navigator.push<JsonEnumValue?>(
            context,
            MaterialPageRoute(
              builder: (context) {
                return HookBuilder(
                  builder: (context) {
                    final tempValue = useState<JsonEnumValue?>(selectedRace);
                    return EditPropertyPageBuilder(
                      propertyId: 'character.race',
                      editorWidgetBuilder: (context) {
                        return EnumSingleChoiceEditor(
                          enumData: availableRaces,
                          initialValue: tempValue.value,
                          label: 'Race',
                          icon: Icons.groups,
                          description: 'Race defines some character traits.',
                          onChanged: (val) {
                            tempValue.value = val;
                          },
                        );
                      },
                      onSaved: () {
                        Navigator.of(context).pop(tempValue.value);
                      },
                    );
                  },
                );
              },
            ),
          );
          if (result != null) {
            // Remove any previous race field and add the new one
            final newField = EnumFieldSingleChoice(
                options: availableRaces, selectedValue: result);
            final newFields = {
              ...character.characterEnums.singleChoiceFields
                  .where((f) => f.options.id != 'race'),
              newField,
            };
            characterState.value = character.copyWith(
              characterEnums: character.characterEnums
                  .copyWith(singleChoiceFields: newFields),
            );
          }
        },
      );
    }

    final items = [
      raceBuilder(),
      groupBuilder(
        groupTitle: 'Ability Scores',
        grupIcon: Icons.fitness_center,
        children: (abilityScores?.abilityScores.entries ?? const {})
            .map((entry) => Card(
                  clipBehavior: Clip.antiAlias,
                  child: traitBuilder(
                    tag: 'ability_${entry.key.name}',
                    icon: Icons.fitness_center,
                    title: (entry.value.value ?? '-').toString(),
                    subtitle: entry.key.name.substring(0, 3).toUpperCase(),
                  ),
                ))
            .toList(),
        preferredWidth: 100.0,
      ),
      othersBuilder(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Example Character Page 2')),
      body: SafeArea(
        child: ListView.separated(
          itemCount: items.length,
          padding: const EdgeInsets.all(4.0),
          itemBuilder: (context, index) => items[index],
          separatorBuilder: (context, index) => const Divider(),
        ),
      ),
    );
  }
}
