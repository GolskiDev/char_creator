import 'package:uuid/uuid.dart';

abstract class Identifiable {
  String get id;

  const Identifiable();

  /// These should be added to classes that implements this interface
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Identifiable && other.id == id;
  }

  /// These should be added to classes that implements this interface
  @override
  int get hashCode => id.hashCode;
}

class IdGenerator {
  static String generateId(Type type) {
    return '${type.toString()}_${const Uuid().v4()}';
  }
}
