class LuckyRollModel {
  final DateTime lastLuckyRollDate;
  final int lastRolledNumber;

  LuckyRollModel({
    required this.lastLuckyRollDate,
    required this.lastRolledNumber,
  });

  factory LuckyRollModel.fromJson(Map<String, dynamic> json) {
    return LuckyRollModel(
      lastLuckyRollDate:
          DateTime.fromMillisecondsSinceEpoch(json['lastLuckyRollDate']),
      lastRolledNumber: json['lastRolledNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastLuckyRollDate': lastLuckyRollDate.millisecondsSinceEpoch,
      'lastRolledNumber': lastRolledNumber,
    };
  }

  DateTime get nextAvailableRollDate => lastLuckyRollDate.add(
        const Duration(hours: 8),
      );
}
