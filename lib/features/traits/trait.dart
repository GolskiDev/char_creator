import 'trait_value.dart';
import 'dart:developer';
import 'package:collection/collection.dart';

import 'trait_value_model.dart';

part 'single_value_trait.dart';
part 'multiple_value_trait.dart';

sealed class Trait {
  final String traitKey;

  const Trait({required this.traitKey});

  Trait.fromTraitValueModels(this.traitKey, List<TraitValue> traitValues);

  selectTraitValue(TraitValue value);
  unselectTraitValue(TraitValue value);
  deleteTraitValue(TraitValue value);
  addTraitValue(TraitValue value);
}
