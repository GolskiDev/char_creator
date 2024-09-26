import 'package:uuid/uuid.dart';

abstract interface class Identifiable {
  String get id;
}

class IdGenerator {
  static String generateId(Type type) {
    return '${type.toString()}_${const Uuid().v4()}';
  }
}
