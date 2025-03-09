import 'package:char_creator/common/interfaces/identifiable.dart';

class Character5eModel implements Identifiable {
  @override
  final String id;
  final String? _name;
  final String? raceId;
  final Set<String> spellIds;
  final Set<String> classIds;

  String get name => _name ?? 'Unnamed Character';

  Character5eModel._({
    required this.id,
    required String? name,
    this.raceId,
    required this.spellIds,
    required this.classIds,
  }) : _name = name;

  Character5eModel.empty({
    required String name,
    this.raceId,
    this.spellIds = const {},
    this.classIds = const {},
  })  : _name = name, id = IdGenerator.generateId(Character5eModel);

  Character5eModel copyWith({
    String? name,
    String? raceId,
    Set<String>? spellIds,
    Set<String>? classIds,
  }) {
    return Character5eModel._(
      id: id,
      name: name ?? _name,
      raceId: raceId ?? this.raceId,
      spellIds: spellIds ?? this.spellIds,
      classIds: classIds ?? this.classIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': _name,
      'raceId': raceId,
      'spellIds': spellIds.toList(),
      'classIds': classIds.toList(),
    };
  }

  factory Character5eModel.fromJson(Map<String, dynamic> json) {
    return Character5eModel._(
      id: json['id'],
      name: json['name'],
      raceId: json['raceId'],
      spellIds: List<String>.from(json['spellIds']).toSet(),
      classIds: List<String>.from(json['classIds']).toSet(),
    );
  }
}
