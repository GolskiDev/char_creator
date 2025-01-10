import 'package:uuid/uuid.dart';

abstract class Identifiable {
  String get id;

  const Identifiable();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Identifiable && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class IdGenerator {
  static String generateId(Type type) {
    return '${type.toString()}_${const Uuid().v4()}';
  }
}
