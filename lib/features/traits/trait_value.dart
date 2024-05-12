class TraitValue {
  String? value;
  String? description;

  TraitValue({
    this.value,
    this.description,
  });

  //toJso
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'description': description,
    };
  }

  //fromJson
  factory TraitValue.fromJson(Map<String, dynamic> json) {
    switch (json) {
      case {
          'value': final String? value,
          'description': final String? description,
        }:
        return TraitValue(
          value: value,
          description: description,
        );
      default:
        throw Exception('Invalid json');
    }
  }
}
