class Character5eOthers {
  final int? maxHP;
  final int? temporaryHP;
  final int? currentHP;
  final int? ac;
  final int? currentSpeed;

  Character5eOthers({
    required this.maxHP,
    required this.temporaryHP,
    required this.currentHP,
    required this.ac,
    required this.currentSpeed,
  });

  Character5eOthers copyWith({
    int? maxHP,
    int? temporaryHP,
    int? currentHP,
    int? ac,
    int? currentSpeed,
  }) {
    return Character5eOthers(
      maxHP: maxHP ?? this.maxHP,
      temporaryHP: temporaryHP ?? this.temporaryHP,
      currentHP: currentHP ?? this.currentHP,
      ac: ac ?? this.ac,
      currentSpeed: currentSpeed ?? this.currentSpeed,
    );
  }

  factory Character5eOthers.fromMap(Map<String, dynamic> map) {
    return Character5eOthers(
      maxHP: map['maxHP'] as int?,
      temporaryHP: map['temporaryHP'] as int?,
      currentHP: map['currentHP'] as int?,
      ac: map['ac'] as int?,
      currentSpeed: map['currentSpeed'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'maxHP': maxHP,
      'temporaryHP': temporaryHP,
      'currentHP': currentHP,
      'ac': ac,
      'currentSpeed': currentSpeed,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character5eOthers &&
        other.maxHP == maxHP &&
        other.temporaryHP == temporaryHP &&
        other.currentHP == currentHP &&
        other.ac == ac &&
        other.currentSpeed == currentSpeed;
  }

  @override
  int get hashCode {
    return maxHP.hashCode ^
        temporaryHP.hashCode ^
        currentHP.hashCode ^
        ac.hashCode ^
        currentSpeed.hashCode;
  }
}
