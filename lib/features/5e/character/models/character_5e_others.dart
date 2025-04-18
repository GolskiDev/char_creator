class Character5eOtherProps {
  final int? maxHP;
  final int? temporaryHP;
  final int? currentHP;
  final int? ac;
  final int? currentSpeed;
  final int? initiative;

  Character5eOtherProps({
    required this.maxHP,
    required this.temporaryHP,
    required this.currentHP,
    required this.ac,
    required this.currentSpeed,
    required this.initiative,
  });

  Character5eOtherProps.empty()
      : maxHP = null,
        temporaryHP = null,
        currentHP = null,
        ac = null,
        currentSpeed = null,
        initiative = null;

  Character5eOtherProps copyWith({
    int? Function()? maxHP,
    int? Function()? temporaryHP,
    int? Function()? currentHP,
    int? Function()? ac,
    int? Function()? currentSpeed,
    int? Function()? initiative,
  }) {
    return Character5eOtherProps(
      maxHP: maxHP != null ? maxHP() : this.maxHP,
      temporaryHP: temporaryHP != null ? temporaryHP() : this.temporaryHP,
      currentHP: currentHP != null ? currentHP() : this.currentHP,
      ac: ac != null ? ac() : this.ac,
      currentSpeed: currentSpeed != null ? currentSpeed() : this.currentSpeed,
      initiative: initiative != null ? initiative() : this.initiative,
    );
  }

  factory Character5eOtherProps.fromMap(Map<String, dynamic> map) {
    return Character5eOtherProps(
      maxHP: map['maxHP'] as int?,
      temporaryHP: map['temporaryHP'] as int?,
      currentHP: map['currentHP'] as int?,
      ac: map['ac'] as int?,
      currentSpeed: map['currentSpeed'] as int?,
      initiative: map['initiative'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'maxHP': maxHP,
      'temporaryHP': temporaryHP,
      'currentHP': currentHP,
      'ac': ac,
      'currentSpeed': currentSpeed,
      'initiative': initiative,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character5eOtherProps &&
        other.maxHP == maxHP &&
        other.temporaryHP == temporaryHP &&
        other.currentHP == currentHP &&
        other.ac == ac &&
        other.currentSpeed == currentSpeed &&
        other.initiative == initiative;
  }

  @override
  int get hashCode {
    return maxHP.hashCode ^
        temporaryHP.hashCode ^
        currentHP.hashCode ^
        ac.hashCode ^
        currentSpeed.hashCode ^
        initiative.hashCode;
  }
}
