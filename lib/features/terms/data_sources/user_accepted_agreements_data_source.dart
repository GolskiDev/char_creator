import 'package:riverpod/riverpod.dart';

class UserAcceptedAgreement {
  final String uid;
  final String version;
  final DateTime acceptedAt;
  final AgreementType type;

  UserAcceptedAgreement({
    required this.uid,
    required this.version,
    required this.acceptedAt,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'version': version,
      'acceptedAt': acceptedAt,
      'type': type.name,
    };
  }

  factory UserAcceptedAgreement.fromMap(Map<String, dynamic> map) {
    return UserAcceptedAgreement(
      uid: map['uid'] as String,
      version: map['version'] as String,
      acceptedAt: map['acceptedAt'] as DateTime,
      type: AgreementType.fromString(map['type'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserAcceptedAgreement &&
        other.uid == uid &&
        other.version == version &&
        other.acceptedAt == acceptedAt &&
        other.type == type;
  }

  @override
  int get hashCode =>
      uid.hashCode ^ version.hashCode ^ acceptedAt.hashCode ^ type.hashCode;
}

enum AgreementType {
  termsOfUse,
  privacyPolicy;

  static AgreementType fromString(String value) {
    return AgreementType.values.firstWhere(
      (e) => e.name == value,
      orElse: () {
        throw ArgumentError('Unknown AgreementType: $value');
      },
    );
  }

  @override
  String toString() => name;
}

final userAcceptedAgreementsDataSourceProvider =
    Provider<UserAcceptedAgreementsDataSource>(
  (ref) {
    throw UnimplementedError();
  },
);

abstract class UserAcceptedAgreementsDataSource {
  /// Stream of the last accepted agreement for the user, or null if none.
  Stream<UserAcceptedAgreement?> lastAcceptedAgreementStream(
    AgreementType type,
  );

  Future<void> acceptAgreement({
    required String version,
    required AgreementType type,
  });
}
