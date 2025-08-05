import 'package:char_creator/features/5e/spells/srd/srd_repository.dart';
import 'package:collection/collection.dart';
import 'package:riverpod/riverpod.dart';

import '../../character/models/character_5e_class_model_v1.dart';
import '../../character/repository/character_classes_repository.dart';
import '../../tags.dart';
import '../models/spell_casting_time.dart';
import '../models/spell_duration.dart';
import '../models/spell_range.dart';
import '../spell_images/spell_images_repository.dart';
import '../utils/spell_utils.dart';

final spellViewModelsProvider = FutureProvider<List<SpellViewModel>>(
  (ref) async {
    final open5eSpellModels = await ref.watch(allSRDSpellsProvider.future);
    final characterClasses =
        await ref.watch(characterClassesStreamProvider.future);
    final spellTypes = SpellTags.spellTypes;

    final spellViewModelsFutures = open5eSpellModels.map(
      (srdSpellViewModel) async {
        final spellImageUrl = await ref
            .watch(spellImagePathProvider(srdSpellViewModel.id).future);

        final spellType = spellTypes.entries.firstWhereOrNull(
          (entry) {
            return entry.key == srdSpellViewModel.id;
          },
        )?.value;

        return srdSpellViewModel.copyWith(
          imageUrl: spellImageUrl,
          spellTypes: spellType,
          classes: characterClasses.where(
            (characterClass) {
              return characterClass.availableSpells.contains(
                srdSpellViewModel.id,
              );
            },
          ).toSet(),
        );
      },
    ).toList();

    final spellViewModels = Future.wait(
      spellViewModelsFutures,
    );

    return spellViewModels;
  },
);

class SpellViewModel {
  final String id;
  final String name;
  final String description;

  final int spellLevel;

  final String? school;

  final bool? requiresConcentration;
  final bool? canBeCastAsRitual;
  final bool? requiresVerbalComponent;
  final bool? requiresSomaticComponent;
  final bool? requiresMaterialComponent;
  final String? material;

  final SpellDuration? duration;
  final SpellRange? range;
  final SpellCastingTime? castingTime;

  final String? atHigherLevels;

  final String? imageUrl;

  final Set<SpellType> spellTypes;
  final Set<ICharacter5eClassModelV1> characterClasses;

  SpellViewModel({
    required this.id,
    required this.name,
    required this.description,
    required this.spellLevel,
    this.school,
    this.requiresConcentration,
    this.canBeCastAsRitual,
    this.requiresVerbalComponent,
    this.requiresSomaticComponent,
    this.requiresMaterialComponent,
    this.material,
    this.duration,
    this.range,
    this.castingTime,
    this.atHigherLevels,
    this.imageUrl,
    this.spellTypes = const {},
    this.characterClasses = const {},
  });

  SpellViewModel copyWith({
    String? id,
    String? name,
    String? description,
    int? spellLevel,
    String? school,
    bool? requiresConcentration,
    bool? canBeCastAsRitual,
    bool? requiresVerbalComponent,
    bool? requiresSomaticComponent,
    bool? requiresMaterialComponent,
    String? material,
    SpellDuration? duration,
    SpellRange? range,
    SpellCastingTime? castingTime,
    String? atHigherLevels,
    String? imageUrl,
    Set<SpellType>? spellTypes,
    Set<ICharacter5eClassModelV1>? classes,
  }) {
    return SpellViewModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      spellLevel: spellLevel ?? this.spellLevel,
      school: school ?? this.school,
      requiresConcentration:
          requiresConcentration ?? this.requiresConcentration,
      canBeCastAsRitual: canBeCastAsRitual ?? this.canBeCastAsRitual,
      requiresVerbalComponent:
          requiresVerbalComponent ?? this.requiresVerbalComponent,
      requiresSomaticComponent:
          requiresSomaticComponent ?? this.requiresSomaticComponent,
      requiresMaterialComponent:
          requiresMaterialComponent ?? this.requiresMaterialComponent,
      material: material ?? this.material,
      duration: duration ?? this.duration,
      range: range ?? this.range,
      castingTime: castingTime ?? this.castingTime,
      atHigherLevels: atHigherLevels ?? this.atHigherLevels,
      imageUrl: imageUrl ?? this.imageUrl,
      spellTypes: spellTypes ?? this.spellTypes,
      characterClasses: classes ?? this.characterClasses,
    );
  }
}

extension SpellLevelString on SpellViewModel {
  String get spellLevelString {
    return SpellUtils.spellLevelString(spellLevel);
  }
}
