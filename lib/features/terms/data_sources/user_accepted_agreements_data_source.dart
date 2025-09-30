import 'package:riverpod/riverpod.dart';

class UserAcceptedAgreement {
  final String version;
  final DateTime acceptedAt;
  final AgreementType type;

  UserAcceptedAgreement({
    required this.version,
    required this.acceptedAt,
    required this.type,
  });

  //equality

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserAcceptedAgreement &&
        other.version == version &&
        other.acceptedAt == acceptedAt &&
        other.type == type;
  }

  @override
  int get hashCode => version.hashCode ^ acceptedAt.hashCode ^ type.hashCode;
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
