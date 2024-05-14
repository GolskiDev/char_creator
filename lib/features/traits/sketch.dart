import 'trait.dart';

main() {
  final List<Trait> traits = [
    SingleValueTrait(traitKey: 'name'),
    SingleValueTrait(traitKey: 'alignment'),
    SingleValueTrait(traitKey: 'race'),
    SingleValueTrait(traitKey: 'class'),
    SingleValueTrait(traitKey: 'level'),
    MultipleValueTrait(traitKey: 'skills'),
  ];
}
