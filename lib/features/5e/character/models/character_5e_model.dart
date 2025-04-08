import 'package:char_creator/common/interfaces/identifiable.dart';
import 'package:collection/collection.dart';

class Character5eModel implements Identifiable {
  @override
  final String id;
  final String? _name;
  final Set<String> spellIds;

  String get name => _name ?? 'Unnamed Character';

  Character5eModel._({
    required this.id,
    required String? name,
    required this.spellIds,
  }) : _name = name;

  Character5eModel.empty({
    required String name,
    this.spellIds = const {},
  })  : _name = name,
        id = IdGenerator.generateId(Character5eModel);

  Character5eModel copyWith({
    String? name,
    String? raceId,
    Set<String>? spellIds,
  }) {
    return Character5eModel._(
      id: id,
      name: name ?? _name,
      spellIds: spellIds ?? this.spellIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': _name,
      'spellIds': spellIds.toList(),
    };
  }

  factory Character5eModel.fromJson(Map<String, dynamic> json) {
    return Character5eModel._(
      id: json['id'],
      name: json['name'],
      spellIds: List<String>.from(json['spellIds']).toSet(),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Character5eModel &&
        other.id == id &&
        other._name == _name &&
        const DeepCollectionEquality().equals(other.spellIds, spellIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        _name.hashCode ^
        const DeepCollectionEquality().hash(spellIds);
  }
}
