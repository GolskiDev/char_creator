import 'package:char_creator/work_in_progress/identifiable.dart';

class Tag implements Identifiable {
  @override
  final String id;
  final String name;

  Tag({
    required this.name,
  }) : id = IdGenerator.generateId(Tag);

  Tag copyWith({String? name}) {
    return Tag(
      name: name ?? this.name,
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
