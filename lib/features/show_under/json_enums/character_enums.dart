import 'package:collection/collection.dart';

import 'enum_field_multiple_choice.dart';
import 'enum_field_single_choice.dart';

class CharacterEnums {
  final Set<EnumFieldSingleChoice> singleChoiceFields;
  final Set<EnumFieldMultipleChoice> multipleChoiceFields;

  CharacterEnums({
    this.singleChoiceFields = const {},
    this.multipleChoiceFields = const {},
  });

  factory CharacterEnums.fromMap(Map<String, dynamic> map) {
    return CharacterEnums(
      singleChoiceFields: (map['singleChoiceFields'] as Set<dynamic>?)
              ?.map((e) => EnumFieldSingleChoice.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toSet() ??
          {},
      multipleChoiceFields: (map['multipleChoiceFields'] as Set<dynamic>?)
              ?.map((e) => EnumFieldMultipleChoice.fromMap(
                    e as Map<String, dynamic>,
                  ))
              .toSet() ??
          {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'singleChoiceFields': singleChoiceFields.map((e) => e.toJson()).toList(),
      'multipleChoiceFields':
          multipleChoiceFields.map((e) => e.toJson()).toList(),
    };
  }

  CharacterEnums copyWith({
    Set<EnumFieldSingleChoice>? singleChoiceFields,
    Set<EnumFieldMultipleChoice>? multipleChoiceFields,
  }) {
    return CharacterEnums(
      singleChoiceFields: singleChoiceFields ?? this.singleChoiceFields,
      multipleChoiceFields: multipleChoiceFields ?? this.multipleChoiceFields,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterEnums &&
          runtimeType == other.runtimeType &&
          DeepCollectionEquality()
              .equals(singleChoiceFields, other.singleChoiceFields) &&
          DeepCollectionEquality()
              .equals(multipleChoiceFields, other.multipleChoiceFields);

  @override
  int get hashCode =>
      singleChoiceFields.hashCode ^ multipleChoiceFields.hashCode;
}
