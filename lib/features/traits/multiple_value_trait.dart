import 'dart:developer';

import 'trait.dart';
import 'trait_value.dart';

class MultipleValueTrait extends Trait {
  final Set<TraitValue> _selectedValues;
  final Set<TraitValue> _options;

  const MultipleValueTrait({
    Set<TraitValue> selectedValues = const {},
    Set<TraitValue> options = const {},
    required super.traitKey,
  })  : _selectedValues = selectedValues,
        _options = options;

  _copyWith({
    Set<TraitValue>? Function()? selectedValues,
    Set<TraitValue>? options,
  }) {
    return MultipleValueTrait(
      selectedValues: selectedValues?.call() ?? _selectedValues,
      options: options ?? _options,
      traitKey: traitKey,
    );
  }

  @override
  addTraitValue(TraitValue value) {
    try {
      if (_options.contains(value)) {
        throw Exception('You can\'t add the same TraitValue twice');
      }
      return _copyWith(options: {..._options, value});
    } catch (e) {
      log(e.toString());
      return this;
    }
  }

  @override
  deleteTraitValue(TraitValue value) {
    try {
      if (!_options.contains(value)) {
        throw Exception(
            'You can\'t delete a TraitValue that is not in the list');
      }
      return _copyWith(options: _options..remove(value));
    } catch (e) {
      log(e.toString());
      return this;
    }
  }

  @override
  selectTraitValue(TraitValue value) {
    try {
      if (!_options.contains(value)) {
        throw Exception(
            'You can\'t select a TraitValue that is not in the list');
      }
      return _copyWith(selectedValues: () {
        if (_selectedValues.contains(value)) {
          throw Exception('You can\'t select the same TraitValue twice');
        }
        return {..._selectedValues, value};
      });
    } catch (e) {
      log(e.toString());
      return this;
    }
  }

  @override
  unselectTraitValue(TraitValue value) {
    try {
      if (!_selectedValues.contains(value)) {
        throw Exception(
            'You can\'t unselect a TraitValue that is not selected');
      }
      return _copyWith(selectedValues: () => _selectedValues..remove(value));
    } catch (e) {
      log(e.toString());
      return this;
    }
  }
}
