import 'json_enums.dart';

final characterSizes = JsonEnum(
  id: "size",
  values: {
    JsonEnumValue(
      value: "tiny",
      text: "Tiny",
    ),
    JsonEnumValue(
      value: "small",
      text: "Small",
    ),
    JsonEnumValue(
      value: "medium",
      text: "Medium",
    ),
    JsonEnumValue(
      value: "large",
      text: "Large",
    ),
    JsonEnumValue(
      value: "huge",
      text: "Huge",
    ),
    JsonEnumValue(
      value: "gargantuan",
      text: "Gargantuan",
    ),
  },
);

final alignmentTypes = JsonEnum(
  id: "alignment",
  values: {
    JsonEnumValue(
      value: "lawful_good",
      text: "Lawful Good",
    ),
    JsonEnumValue(
      value: "neutral_good",
      text: "Neutral Good",
    ),
    JsonEnumValue(
      value: "chaotic_good",
      text: "Chaotic Good",
    ),
    JsonEnumValue(
      value: "lawful_neutral",
      text: "Lawful Neutral",
    ),
    JsonEnumValue(
      value: "true_neutral",
      text: "True Neutral",
    ),
    JsonEnumValue(
      value: "chaotic_neutral",
      text: "Chaotic Neutral",
    ),
    JsonEnumValue(
      value: "lawful_evil",
      text: "Lawful Evil",
    ),
    JsonEnumValue(
      value: "neutral_evil",
      text: "Neutral Evil",
    ),
    JsonEnumValue(
      value: "chaotic_evil",
      text: "Chaotic Evil",
    ),
  },
);

final languages = JsonEnum(
  id: "language",
  values: {
    JsonEnumValue(
      value: "common",
      text: "Common",
    ),
    JsonEnumValue(
      value: "dwarvish",
      text: "Dwarvish",
    ),
    JsonEnumValue(
      value: "elvish",
      text: "Elvish",
    ),
    JsonEnumValue(
      value: "giant",
      text: "Giant",
    ),
    JsonEnumValue(
      value: "goblin",
      text: "Goblin",
    ),
    JsonEnumValue(
      value: "orc",
      text: "Orc",
    ),
  },
);
