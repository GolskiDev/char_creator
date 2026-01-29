import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../edit_property_page_builder.dart';
import '../example_character_data.dart';
import '../json_enums/enum_field_multiple_choice.dart';
import '../json_enums/enum_field_single_choice.dart';
import '../json_enums/enums_examples.dart';
import '../json_enums/json_enums.dart';
import '../widgets/character_widgets.dart';
import '../widgets/enum_multiple_choice_editor.dart';
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
    Widget othersBuilder() {
      return Column(
        children: [
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Other Properties'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: listTileThemeWrapper(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // All the property trait builders
                  // Age
                  (() {
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
                              int? age = character.others?.age;
                              return EditPropertyPageBuilder(
                                propertyId: 'character.age',
                                editorWidgetBuilder: (context) {
                                  return IntEditor(
                                    value: character.others?.age,
                                    label: 'Age',
                                    icon: Icons.cake,
                                    onChanged: (val) {
                                      age = val;
                                    },
                                  );
                                },
                                onSaved: () {
                                  Navigator.of(context).pop(age);
                                },
                              );
                            },
                          ),
                        );
                        if (result != null) {
                          characterState.value = character.copyWith(
                            others:
                                character.others?.copyWith(age: () => result) ??
                                    character.others,
                          );
                        }
                      },
                    );
                  })(),
                  // Max HP
                  (() {
                    final maxHP = character.others?.maxHP;
                    return TraitBuilder(
                      tag: 'character.maxHP',
                      icon: Icons.favorite,
                      title: maxHP?.toString() ?? '-',
                      subtitle: 'Max HP',
                      onTap: () async {
                        final result = await Navigator.push<int>(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              int? tempValue = maxHP;
                              return EditPropertyPageBuilder(
                                propertyId: 'character.maxHP',
                                editorWidgetBuilder: (context) {
                                  return IntEditor(
                                    value: tempValue,
                                    label: 'Max HP',
                                    icon: Icons.favorite,
                                    onChanged: (val) {
                                      tempValue = val;
                                    },
                                  );
                                },
                                onSaved: () {
                                  Navigator.of(context).pop(tempValue);
                                },
                              );
                            },
                          ),
                        );
                        if (result != null) {
                          characterState.value = character.copyWith(
                            others: character.others
                                    ?.copyWith(maxHP: () => result) ??
                                character.others,
                          );
                        }
                      },
                    );
                  })(),
                  // Temporary HP
                  (() {
                    final temporaryHP = character.others?.temporaryHP;
                    return TraitBuilder(
                      tag: 'character.temporaryHP',
                      icon: Icons.healing,
                      title: temporaryHP?.toString() ?? '-',
                      subtitle: 'Temporary HP',
                      onTap: () async {
                        final result = await Navigator.push<int>(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              int? tempValue = temporaryHP;
                              return EditPropertyPageBuilder(
                                propertyId: 'character.temporaryHP',
                                editorWidgetBuilder: (context) {
                                  return IntEditor(
                                    value: tempValue,
                                    label: 'Temporary HP',
                                    icon: Icons.healing,
                                    onChanged: (val) {
                                      tempValue = val;
                                    },
                                  );
                                },
                                onSaved: () {
                                  Navigator.of(context).pop(tempValue);
                                },
                              );
                            },
                          ),
                        );
                        if (result != null) {
                          characterState.value = character.copyWith(
                            others: character.others
                                    ?.copyWith(temporaryHP: () => result) ??
                                character.others,
                          );
                        }
                      },
                    );
                  })(),
                  // Current HP
                  (() {
                    final currentHP = character.others?.currentHP;
                    return TraitBuilder(
                      tag: 'character.currentHP',
                      icon: Icons.bloodtype,
                      title: currentHP?.toString() ?? '-',
                      subtitle: 'Current HP',
                      onTap: () async {
                        final result = await Navigator.push<int>(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              int? tempValue = currentHP;
                              return EditPropertyPageBuilder(
                                propertyId: 'character.currentHP',
                                editorWidgetBuilder: (context) {
                                  return IntEditor(
                                    value: tempValue,
                                    label: 'Current HP',
                                    icon: Icons.bloodtype,
                                    onChanged: (val) {
                                      tempValue = val;
                                    },
                                  );
                                },
                                onSaved: () {
                                  Navigator.of(context).pop(tempValue);
                                },
                              );
                            },
                          ),
                        );
                        if (result != null) {
                          characterState.value = character.copyWith(
                            others: character.others
                                    ?.copyWith(currentHP: () => result) ??
                                character.others,
                          );
                        }
                      },
                    );
                  })(),
                  // AC
                  (() {
                    final ac = character.others?.ac;
                    return TraitBuilder(
                      tag: 'character.ac',
                      icon: Icons.shield,
                      title: ac?.toString() ?? '-',
                      subtitle: 'Armor Class (AC)',
                      onTap: () async {
                        final result = await Navigator.push<int>(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              int? tempValue = ac;
                              return EditPropertyPageBuilder(
                                propertyId: 'character.ac',
                                editorWidgetBuilder: (context) {
                                  return IntEditor(
                                    value: tempValue,
                                    label: 'Armor Class (AC)',
                                    icon: Icons.shield,
                                    onChanged: (val) {
                                      tempValue = val;
                                    },
                                  );
                                },
                                onSaved: () {
                                  Navigator.of(context).pop(tempValue);
                                },
                              );
                            },
                          ),
                        );
                        if (result != null) {
                          characterState.value = character.copyWith(
                            others:
                                character.others?.copyWith(ac: () => result) ??
                                    character.others,
                          );
                        }
                      },
                    );
                  })(),
                  // Current Speed
                  (() {
                    final currentSpeed = character.others?.currentSpeed;
                    return TraitBuilder(
                      tag: 'character.currentSpeed',
                      icon: Icons.directions_run,
                      title: currentSpeed?.toString() ?? '-',
                      subtitle: 'Current Speed',
                      onTap: () async {
                        final result = await Navigator.push<int>(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              int? tempValue = currentSpeed;
                              return EditPropertyPageBuilder(
                                propertyId: 'character.currentSpeed',
                                editorWidgetBuilder: (context) {
                                  return IntEditor(
                                    value: tempValue,
                                    label: 'Current Speed',
                                    icon: Icons.directions_run,
                                    onChanged: (val) {
                                      tempValue = val;
                                    },
                                  );
                                },
                                onSaved: () {
                                  Navigator.of(context).pop(tempValue);
                                },
                              );
                            },
                          ),
                        );
                        if (result != null) {
                          characterState.value = character.copyWith(
                            others: character.others
                                    ?.copyWith(currentSpeed: () => result) ??
                                character.others,
                          );
                        }
                      },
                    );
                  })(),
                  // Initiative
                  (() {
                    final initiative = character.others?.initiative;
                    return TraitBuilder(
                      tag: 'character.initiative',
                      icon: Icons.flash_on,
                      title: initiative?.toString() ?? '-',
                      subtitle: 'Initiative',
                      onTap: () async {
                        final result = await Navigator.push<int>(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              int? tempValue = initiative;
                              return EditPropertyPageBuilder(
                                propertyId: 'character.initiative',
                                editorWidgetBuilder: (context) {
                                  return IntEditor(
                                    value: tempValue,
                                    label: 'Initiative',
                                    icon: Icons.flash_on,
                                    onChanged: (val) {
                                      tempValue = val;
                                    },
                                  );
                                },
                                onSaved: () {
                                  Navigator.of(context).pop(tempValue);
                                },
                              );
                            },
                          ),
                        );
                        if (result != null) {
                          characterState.value = character.copyWith(
                            others: character.others
                                    ?.copyWith(initiative: () => result) ??
                                character.others,
                          );
                        }
                      },
                    );
                  })(),
                  // Alignment, Size, Speed, Vision, Proficiencies, Languages
                  (() {
                    final selectedAlignment =
                        character.characterEnums.singleChoiceFields
                            .firstWhere(
                              (field) => field.options.id == 'alignment',
                              orElse: () => EnumFieldSingleChoice(
                                  options: alignmentTypes, selectedValue: null),
                            )
                            .selectedValue;
                    return TraitBuilder(
                      tag: 'character.alignment',
                      icon: Icons.balance,
                      title: selectedAlignment?.text ?? '-',
                      subtitle: 'Alignment',
                      onTap: () async {
                        final result = await Navigator.push<JsonEnumValue?>(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              JsonEnumValue? tempValue = selectedAlignment;
                              return EditPropertyPageBuilder(
                                propertyId: 'character.alignment',
                                editorWidgetBuilder: (context) {
                                  return EnumSingleChoiceEditor(
                                    enumData: alignmentTypes,
                                    initialValue: tempValue,
                                    label: 'Alignment',
                                    icon: Icons.balance,
                                    onChanged: (val) {
                                      tempValue = val;
                                    },
                                  );
                                },
                                onSaved: () {
                                  Navigator.of(context).pop(tempValue);
                                },
                              );
                            },
                          ),
                        );
                        if (result != null) {
                          final newField = EnumFieldSingleChoice(
                              options: alignmentTypes, selectedValue: result);
                          final newFields = {
                            ...character.characterEnums.singleChoiceFields
                                .where((f) => f.options.id != 'alignment'),
                            newField,
                          };
                          characterState.value = character.copyWith(
                            characterEnums: character.characterEnums
                                .copyWith(singleChoiceFields: newFields),
                          );
                        }
                      },
                    );
                  })(),
                  (() {
                    final selectedSize =
                        character.characterEnums.singleChoiceFields
                            .firstWhere(
                              (field) => field.options.id == 'size',
                              orElse: () => EnumFieldSingleChoice(
                                  options: characterSizes, selectedValue: null),
                            )
                            .selectedValue;
                    return TraitBuilder(
                      tag: 'character.size',
                      icon: Icons.height,
                      title: selectedSize?.text ?? '-',
                      subtitle: 'Size',
                      onTap: () async {
                        final result = await Navigator.push<JsonEnumValue?>(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              JsonEnumValue? tempValue = selectedSize;
                              return EditPropertyPageBuilder(
                                propertyId: 'character.size',
                                editorWidgetBuilder: (context) {
                                  return EnumSingleChoiceEditor(
                                    enumData: characterSizes,
                                    initialValue: tempValue,
                                    label: 'Size',
                                    icon: Icons.height,
                                    onChanged: (val) {
                                      tempValue = val;
                                    },
                                  );
                                },
                                onSaved: () {
                                  Navigator.of(context).pop(tempValue);
                                },
                              );
                            },
                          ),
                        );
                        if (result != null) {
                          final newField = EnumFieldSingleChoice(
                              options: characterSizes, selectedValue: result);
                          final newFields = {
                            ...character.characterEnums.singleChoiceFields
                                .where((f) => f.options.id != 'size'),
                            newField,
                          };
                          characterState.value = character.copyWith(
                            characterEnums: character.characterEnums
                                .copyWith(singleChoiceFields: newFields),
                          );
                        }
                      },
                    );
                  })(),

                  traitBuilder(
                    tag: 'character.vision',
                    icon: Icons.remove_red_eye,
                    title: 'Darkvision 60 ft.',
                    subtitle: 'Vision',
                  ),
                  traitBuilder(
                    tag: 'character.proficiencies',
                    icon: Icons.build,
                    title: 'Proficiencies',
                    subtitle: 'Various Proficiencies',
                  ),
                  (() {
                    // Use the languages enum from enums_examples.dart
                    final availableLanguages = languages;

                    // Find the selected languages from character.characterEnums.multipleChoiceFields
                    final selectedLanguagesField = character
                        .characterEnums.multipleChoiceFields
                        .firstWhere(
                      (field) => field.options.id == 'language',
                      orElse: () => EnumFieldMultipleChoice(
                          options: availableLanguages, selectedValues: {}),
                    );
                    final selectedLanguages =
                        selectedLanguagesField.selectedValues;

                    return TraitBuilder(
                      tag: 'character.languages',
                      icon: Icons.language,
                      title: selectedLanguages.isEmpty
                          ? 'No languages selected'
                          : selectedLanguages.map((e) => e.text).join(', '),
                      subtitle: 'Known Languages',
                      onTap: () async {
                        final result = await Navigator.push<Set<JsonEnumValue>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              Set<JsonEnumValue> tempValues =
                                  Set<JsonEnumValue>.from(selectedLanguages);
                              return EditPropertyPageBuilder(
                                propertyId: 'character.languages',
                                editorWidgetBuilder: (context) {
                                  return EnumMultipleChoiceEditor(
                                    enumData: availableLanguages,
                                    initialValues: tempValues,
                                    label: 'Languages',
                                    icon: Icons.language,
                                    onChanged: (vals) {
                                      tempValues = vals;
                                    },
                                  );
                                },
                                onSaved: () {
                                  Navigator.of(context).pop(tempValues);
                                },
                              );
                            },
                          ),
                        );
                        if (result != null) {
                          final newField = EnumFieldMultipleChoice(
                            options: availableLanguages,
                            selectedValues: result,
                          );
                          final newFields = {
                            ...character.characterEnums.multipleChoiceFields
                                .where((f) => f.options.id != 'language'),
                            newField,
                          };
                          characterState.value = character.copyWith(
                            characterEnums: character.characterEnums.copyWith(
                              multipleChoiceFields: newFields,
                            ),
                          );
                        }
                      },
                    );
                  })(),
                ]
                    .map(
                      (e) => Card(
                        clipBehavior: Clip.antiAlias,
                        child: e,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      );
    }

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
                JsonEnumValue? tempValue = selectedRace;
                return EditPropertyPageBuilder(
                  propertyId: 'character.race',
                  editorWidgetBuilder: (context) {
                    return EnumSingleChoiceEditor(
                      enumData: availableRaces,
                      initialValue: tempValue,
                      label: 'Race',
                      icon: Icons.groups,
                      description: 'Race defines some character traits.',
                      onChanged: (val) {
                        tempValue = val;
                      },
                    );
                  },
                  onSaved: () {
                    Navigator.of(context).pop(tempValue);
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
                  child: TraitBuilder(
                    tag: 'character.abilityScores.${entry.key.name}',
                    icon: Icons.fitness_center,
                    title: (entry.value.value ?? '-').toString(),
                    subtitle: entry.key.name.substring(0, 3).toUpperCase(),
                    onTap: () async {
                      final currentValue = entry.value.value;
                      final result = await Navigator.push<int?>(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            int? tempValue = currentValue;
                            return EditPropertyPageBuilder(
                              propertyId:
                                  'character.abilityScores.${entry.key.name}',
                              editorWidgetBuilder: (context) {
                                return IntEditor(
                                  value: currentValue,
                                  label: entry.key.name,
                                  icon: Icons.fitness_center,
                                  onChanged: (val) {
                                    tempValue = val;
                                  },
                                );
                              },
                              onSaved: () {
                                Navigator.of(context).pop(tempValue);
                              },
                            );
                          },
                        ),
                      );
                      if (result != null) {
                        // Update the ability score in the character state
                        final updatedScores =
                            Map.of(abilityScores!.abilityScores);
                        updatedScores[entry.key] =
                            entry.value.copyWith(value: () => result);
                        characterState.value = character.copyWith(
                          abilityScores: abilityScores.copyWith(
                              abilityScores: updatedScores),
                        );
                      }
                    },
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
