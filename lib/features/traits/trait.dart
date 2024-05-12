import 'trait_value.dart';

abstract class Trait {
  final String traitKey;

  const Trait({required this.traitKey});

  selectTraitValue(TraitValue value);
  unselectTraitValue(TraitValue value);
  deleteTraitValue(TraitValue value);
  addTraitValue(TraitValue value);
}
