class Conditions5e {
  final bool? blinded;
  final bool? charmed;
  final bool? deafened;
  final bool? frightened;
  final bool? grappled;
  final bool? incapacitated;
  final bool? invisible;
  final bool? paralyzed;
  final bool? petrified;
  final bool? poisoned;
  final bool? prone;
  final bool? restrained;
  final bool? stunned;
  final bool? unconscious;
  final int? exhaustionLevel;

  Conditions5e({
    required this.blinded,
    required this.charmed,
    required this.deafened,
    required this.frightened,
    required this.grappled,
    required this.incapacitated,
    required this.invisible,
    required this.paralyzed,
    required this.petrified,
    required this.poisoned,
    required this.prone,
    required this.restrained,
    required this.stunned,
    required this.unconscious,
    required this.exhaustionLevel,
  });

  Conditions5e copyWith({
    bool? blinded,
    bool? charmed,
    bool? deafened,
    bool? frightened,
    bool? grappled,
    bool? incapacitated,
    bool? invisible,
    bool? paralyzed,
    bool? petrified,
    bool? poisoned,
    bool? prone,
    bool? restrained,
    bool? stunned,
    bool? unconscious,
    int? exhaustionLevel,
  }) {
    return Conditions5e(
      blinded: blinded ?? this.blinded,
      charmed: charmed ?? this.charmed,
      deafened: deafened ?? this.deafened,
      frightened: frightened ?? this.frightened,
      grappled: grappled ?? this.grappled,
      incapacitated: incapacitated ?? this.incapacitated,
      invisible: invisible ?? this.invisible,
      paralyzed: paralyzed ?? this.paralyzed,
      petrified: petrified ?? this.petrified,
      poisoned: poisoned ?? this.poisoned,
      prone: prone ?? this.prone,
      restrained: restrained ?? this.restrained,
      stunned: stunned ?? this.stunned,
      unconscious: unconscious ?? this.unconscious,
      exhaustionLevel: exhaustionLevel ?? this.exhaustionLevel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "blinded": blinded,
      "charmed": charmed,
      "deafened": deafened,
      "frightened": frightened,
      "grappled": grappled,
      "incapacitated": incapacitated,
      "invisible": invisible,
      "paralyzed": paralyzed,
      "petrified": petrified,
      "poisoned": poisoned,
      "prone": prone,
      "restrained": restrained,
      "stunned": stunned,
      "unconscious": unconscious,
      "exhaustionLevel": exhaustionLevel,
    };
  }

  factory Conditions5e.fromMap(Map<String, dynamic> map) {
    return Conditions5e(
      blinded: map["blinded"] as bool?,
      charmed: map["charmed"] as bool?,
      deafened: map["deafened"] as bool?,
      frightened: map["frightened"] as bool?,
      grappled: map["grappled"] as bool?,
      incapacitated: map["incapacitated"] as bool?,
      invisible: map["invisible"] as bool?,
      paralyzed: map["paralyzed"] as bool?,
      petrified: map["petrified"] as bool?,
      poisoned: map["poisoned"] as bool?,
      prone: map["prone"] as bool?,
      restrained: map["restrained"] as bool?,
      stunned: map["stunned"] as bool?,
      unconscious: map["unconscious"] as bool?,
      exhaustionLevel: map["exhaustionLevel"] as int?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Conditions5e &&
        other.blinded == blinded &&
        other.charmed == charmed &&
        other.deafened == deafened &&
        other.frightened == frightened &&
        other.grappled == grappled &&
        other.incapacitated == incapacitated &&
        other.invisible == invisible &&
        other.paralyzed == paralyzed &&
        other.petrified == petrified &&
        other.poisoned == poisoned &&
        other.prone == prone &&
        other.restrained == restrained &&
        other.stunned == stunned &&
        other.unconscious == unconscious &&
        other.exhaustionLevel == exhaustionLevel;
  }

  @override
  int get hashCode {
    return Object.hash(
      blinded,
      charmed,
      deafened,
      frightened,
      grappled,
      incapacitated,
      invisible,
      paralyzed,
      petrified,
      poisoned,
      prone,
      restrained,
      stunned,
      unconscious,
      exhaustionLevel,
    );
  }
}
