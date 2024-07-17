abstract class CharacterTrait {
  final String id;

  CharacterTrait({required this.id});

  //json
  factory CharacterTrait.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('value')) {
      return SingleValueCharacterTrait.fromJson(json);
    } else {
      return MultipleValueCharacterTrait.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();
}

class SingleValueCharacterTrait extends CharacterTrait {
  final String value;

  SingleValueCharacterTrait({
    required super.id,
    required this.value,
  });

  factory SingleValueCharacterTrait.fromJson(Map<String, dynamic> json) {
    return SingleValueCharacterTrait(
      id: json['id'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
    };
  }
}

class MultipleValueCharacterTrait extends CharacterTrait {
  final List<String> values;

  MultipleValueCharacterTrait({
    required super.id,
    required this.values,
  });

  factory MultipleValueCharacterTrait.fromJson(Map<String, dynamic> json) {
    return MultipleValueCharacterTrait(
      id: json['id'],
      values: List<String>.from(json['values']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'values': values,
    };
  }
}
