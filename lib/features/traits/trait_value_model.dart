import 'trait_value.dart';

class TraitValueModel {
  final String traitKey;
  final TraitValue traitValue;
  final bool isSelected;

  TraitValueModel({
    required this.traitKey,
    required this.traitValue,
    required this.isSelected,
  });

  TraitValueModel copyWith({
    String? traitKey,
    TraitValue? value,
    bool? isSelected,
  }) {
    return TraitValueModel(
      traitKey: traitKey ?? this.traitKey,
      traitValue: value ?? this.traitValue,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'traitKey': traitKey,
      'value': traitValue.toJson(),
      'isSelected': isSelected,
    };
  }

  //fromJson
  factory TraitValueModel.fromJson(Map<String, dynamic> json) {
    switch (json) {
      case {
        'traitKey': final String traitKey,
        'value': final Map<String, dynamic> value,
        'isSelected': final bool isSelected,
      }:
        return TraitValueModel(
          traitKey: traitKey,
          traitValue: TraitValue.fromJson(value),
          isSelected: isSelected,
        );
      default:
        throw Exception('Invalid json');
    }
  }
}
