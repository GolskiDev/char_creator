import 'package:collection/collection.dart';

enum Character5eSpellSlotLevel {
  first,
  second,
  third,
  fourth,
  fifth,
  sixth,
  seventh,
  eighth,
  ninth;

  static Character5eSpellSlotLevel fromString(String level) {
    switch (level) {
      case '1':
        return Character5eSpellSlotLevel.first;
      case '2':
        return Character5eSpellSlotLevel.second;
      case '3':
        return Character5eSpellSlotLevel.third;
      case '4':
        return Character5eSpellSlotLevel.fourth;
      case '5':
        return Character5eSpellSlotLevel.fifth;
      case '6':
        return Character5eSpellSlotLevel.sixth;
      case '7':
        return Character5eSpellSlotLevel.seventh;
      case '8':
        return Character5eSpellSlotLevel.eighth;
      case '9':
        return Character5eSpellSlotLevel.ninth;
      default:
        throw Exception('Invalid spell slot level: $level');
    }
  }

  @override
  String toString() {
    switch (this) {
      case Character5eSpellSlotLevel.first:
        return '1';
      case Character5eSpellSlotLevel.second:
        return '2';
      case Character5eSpellSlotLevel.third:
        return '3';
      case Character5eSpellSlotLevel.fourth:
        return '4';
      case Character5eSpellSlotLevel.fifth:
        return '5';
      case Character5eSpellSlotLevel.sixth:
        return '6';
      case Character5eSpellSlotLevel.seventh:
        return '7';
      case Character5eSpellSlotLevel.eighth:
        return '8';
      case Character5eSpellSlotLevel.ninth:
        return '9';
    }
  }
}

extension Character5eSpellSlotLevelExtension on Character5eSpellSlotLevel {
  int get level {
    switch (this) {
      case Character5eSpellSlotLevel.first:
        return 1;
      case Character5eSpellSlotLevel.second:
        return 2;
      case Character5eSpellSlotLevel.third:
        return 3;
      case Character5eSpellSlotLevel.fourth:
        return 4;
      case Character5eSpellSlotLevel.fifth:
        return 5;
      case Character5eSpellSlotLevel.sixth:
        return 6;
      case Character5eSpellSlotLevel.seventh:
        return 7;
      case Character5eSpellSlotLevel.eighth:
        return 8;
      case Character5eSpellSlotLevel.ninth:
        return 9;
    }
  }
}

class Character5eSpellSlots {
  final Map<Character5eSpellSlotLevel, Character5eSpellSlot> spellSlots;

  ///AreSpellSlotsEmpty
  bool get areSpellSlotsEmpty {
    return spellSlots.values.every((spellSlot) => spellSlot.maxSlots == 0);
  }

  Character5eSpellSlots({
    required this.spellSlots,
  });

  factory Character5eSpellSlots.empty() {
    return Character5eSpellSlots(
      spellSlots: {
        for (var level in Character5eSpellSlotLevel.values)
          level: Character5eSpellSlot(
            level: level,
            maxSlots: 0,
            currentSlots: 0,
          ),
      },
    );
  }

  Character5eSpellSlots copyWith({
    Map<Character5eSpellSlotLevel, Character5eSpellSlot>? spellSlots,
  }) {
    return Character5eSpellSlots(
      spellSlots: spellSlots ?? this.spellSlots,
    );
  }

  @override
  factory Character5eSpellSlots.fromMap(Map<String, dynamic> map) {
    return Character5eSpellSlots(
      spellSlots: {
        for (var entry in map.entries)
          Character5eSpellSlotLevel.fromString(entry.key):
              Character5eSpellSlot.fromMap(entry.value),
      },
    );
  }

  Map<String, dynamic> toMap() {
    return {
      for (var entry in spellSlots.entries)
        entry.key.toString(): entry.value.toMap(),
    };
  }

  @override
  bool operator ==(Object other) {
    return other is Character5eSpellSlots &&
        MapEquality().equals(other.spellSlots, spellSlots);
  }

  @override
  int get hashCode {
    return MapEquality().hash(spellSlots);
  }
}

class Character5eSpellSlot {
  final Character5eSpellSlotLevel level;
  final int maxSlots;
  final int currentSlots;

  Character5eSpellSlot({
    required this.level,
    required this.maxSlots,
    required this.currentSlots,
  });

  Character5eSpellSlot copyWith({
    Character5eSpellSlotLevel? level,
    int? Function()? maxSlotsSetter,
    int? Function()? currentSlotsSetter,
  }) {
    return Character5eSpellSlot(
      level: level ?? this.level,
      maxSlots: maxSlotsSetter?.call() ?? this.maxSlots,
      currentSlots: currentSlotsSetter?.call() ?? this.currentSlots,
    );
  }

  @override
  factory Character5eSpellSlot.fromMap(Map<String, dynamic> json) {
    return Character5eSpellSlot(
      level: Character5eSpellSlotLevel.fromString(json['level']),
      maxSlots: json['maxSlots'],
      currentSlots: json['currentSlots'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'level': level.toString(),
      'maxSlots': maxSlots,
      'currentSlots': currentSlots,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character5eSpellSlot &&
        other.level == level &&
        other.maxSlots == maxSlots &&
        other.currentSlots == currentSlots;
  }

  @override
  int get hashCode {
    return level.hashCode ^ maxSlots.hashCode ^ currentSlots.hashCode;
  }
}
