part of 'trait.dart';

class SingleValueTrait extends Trait {
  final TraitValue? selectedValue;
  final Set<TraitValue> options;

  const SingleValueTrait({
    this.selectedValue,
    this.options = const {},
    required super.traitKey,
  });

  factory SingleValueTrait.fromTraitValueModels(
    String traitKey,
    List<TraitValueModel> traitValues,
  ) {
    final myTraitValues = traitValues.where((traitValueModel) {
      return traitValueModel.traitKey == traitKey;
    });
    final selectedValue = myTraitValues.firstWhereOrNull(
      (traitValueModel) => traitValueModel.isSelected,
    )?.traitValue;
    final options = myTraitValues.map((traitValueModel) {
      return traitValueModel.traitValue;
    }).toSet();
    return SingleValueTrait(
      selectedValue: selectedValue,
      options: options,
      traitKey: traitKey,
    );
  }

  SingleValueTrait _copyWith({
    TraitValue? Function()? selectedValue,
    Set<TraitValue>? options,
  }) {
    return SingleValueTrait(
      selectedValue: selectedValue?.call(),
      options: options ?? this.options,
      traitKey: traitKey,
    );
  }

  @override
  SingleValueTrait addTraitValue(TraitValue value) {
    // if it already contains the same value, throw you cant add the same value
    try {
      if (options.contains(value)) {
        throw Exception('You can\'t add the same TraitValue twice');
      }
      return _copyWith(options: {...options, value});
    } catch (e) {
      log(e.toString());
      return this;
    }
  }

  @override
  deleteTraitValue(TraitValue value) {
    try {
      if (!options.contains(value)) {
        throw Exception(
            'You can\'t delete a TraitValue that is not in the list');
      }
      return _copyWith(options: options..remove(value));
    } catch (e) {
      log(e.toString());
      return this;
    }
  }

  @override
  selectTraitValue(TraitValue value) {
    try {
      if (!options.contains(value)) {
        throw Exception(
            'You can\'t select a TraitValue that is not in the list');
      }
      return _copyWith(selectedValue: () => value);
    } catch (e) {
      log(e.toString());
      return this;
    }
  }

  @override
  unselectTraitValue(TraitValue value) {
    try {
      if (selectedValue != value) {
        throw Exception(
            'You can\'t unselect a TraitValue that is not selected');
      }
      return _copyWith(selectedValue: () => null);
    } catch (e) {
      log(e.toString());
      return this;
    }
  }
}
