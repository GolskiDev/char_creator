import 'package:spells_and_tools/features/show_under/json_enums/enums_examples.dart';

import 'enum_field_single_choice.dart';

/// Currently all character ENUMS that can be added to a character built in.
class AllCharacterTraits {
  get allTraits => [
        EnumFieldSingleChoice(
          options: characterSizes,
        ),
        EnumFieldSingleChoice(
          options: alignmentTypes,
        ),
        EnumFieldSingleChoice(
          options: languages,
        ),
      ];
}
