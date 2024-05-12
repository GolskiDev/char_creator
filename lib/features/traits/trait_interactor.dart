import 'trait_value_model.dart';

class TraitInteractor {
  List<TraitValueModel> getTraitValueModels(
    List<String>? traitKeys,
    bool? isSelected,
  ) {
    final allTraitValues = <TraitValueModel>[];
    Iterable<TraitValueModel> result = allTraitValues;
    if (traitKeys != null) {
      result = result.where(
          (traitValueModel) => _filterByTraitKeys(traitKeys, traitValueModel));
    }
    if (isSelected != null) {
      result = result.where((traitValueModel) =>
          _filterByIsSelected(isSelected, traitValueModel));
    }
    return result.toList();
  }

  bool _filterByTraitKeys(
    List<String> traitKeys,
    TraitValueModel traitValueModel,
  ) {
    if (traitKeys.isEmpty) {
      return true;
    }
    return traitKeys.contains(traitValueModel.traitKey);
  }

  bool _filterByIsSelected(
    bool isSelected,
    TraitValueModel traitValueModel,
  ) {
    return isSelected == traitValueModel.isSelected;
  }
}
