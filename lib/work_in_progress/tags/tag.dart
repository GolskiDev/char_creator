import 'package:char_creator/work_in_progress/identifiable.dart';

class Tag extends Identifiable {
  final String name;

  Tag._({
    required super.id,
    required this.name,
  });

  factory Tag.create({
    required String name,
  }) {
    return Tag._(
      id: IdGenerator.generateId(Tag),
      name: name,
    );
  }

  Tag copyWith({String? name}) {
    return Tag._(
      id: id,
      name: name ?? this.name,
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag._(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
