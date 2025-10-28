import 'package:spells_and_tools/common/interfaces/identifiable.dart';
import 'package:collection/collection.dart';

abstract interface class ICharacter5eClassModelV1 implements Identifiable {
  @override
  final String id;
  String? get className => null;
  final Set<String> availableSpells;

  const ICharacter5eClassModelV1._({
    required this.id,
    this.availableSpells = const {},
  });

  ICharacter5eClassModelV1.empty({
    required String id,
    Set<String>? availableSpells,
  }) : this._(
          id: IdGenerator.generateId(ICharacter5eClassModelV1),
          availableSpells: availableSpells ?? const {},
        );

  ICharacter5eClassModelV1 copyWith({
    String? className,
    Set<String>? availableSpells,
  });

  Map<String, dynamic> toMap();
}

class Character5eCustomClassModelV1 implements ICharacter5eClassModelV1 {
  @override
  final String id;
  final String? _className;
  @override
  String? get className => _className ?? "New Class";
  @override
  final Set<String> availableSpells;

  const Character5eCustomClassModelV1._({
    required this.id,
    String? className,
    this.availableSpells = const {},
  }) : _className = className;

  Character5eCustomClassModelV1.empty({
    required String id,
    String? className,
    Set<String>? availableSpells,
  }) : this._(
          id: IdGenerator.generateId(Character5eCustomClassModelV1),
          className: className,
          availableSpells: availableSpells ?? const {},
        );

  @override
  Character5eCustomClassModelV1 copyWith({
    String? className,
    Set<String>? availableSpells,
  }) {
    return Character5eCustomClassModelV1._(
      id: id,
      className: className ?? _className,
      availableSpells: availableSpells ?? this.availableSpells,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'className': className,
      'availableSpells': availableSpells.toList(),
    };
  }

  factory Character5eCustomClassModelV1.fromMap(Map<String, dynamic> json) {
    return Character5eCustomClassModelV1._(
      id: json['id'],
      className: json['className'],
      availableSpells: Set<String>.from(json['availableSpells']),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Character5eCustomClassModelV1 &&
        other.id == id &&
        other._className == _className &&
        SetEquality().equals(other.availableSpells, availableSpells);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        _className.hashCode ^
        SetEquality().hash(availableSpells);
  }
}
