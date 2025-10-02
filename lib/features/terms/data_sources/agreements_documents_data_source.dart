import 'package:char_creator/features/terms/data_sources/fireabse_agreements_documents_data_source.dart';
import 'package:char_creator/features/terms/data_sources/user_accepted_agreements_data_source.dart';
import 'package:char_creator/services/firestore.dart';
import 'package:riverpod/riverpod.dart';

class AgreementDetails {
  final DateTime effectiveDate;
  final String version;
  final AgreementType type;
  final Map<String, dynamic>? extra;

  const AgreementDetails({
    required this.effectiveDate,
    required this.type,
    required this.version,
    this.extra,
  });

  Map<String, dynamic> toMap() {
    return {
      'effectiveDate': effectiveDate,
      'version': version,
      'type': type,
      'extra': extra,
    };
  }

  factory AgreementDetails.fromMap(Map<String, dynamic> map) {
    return AgreementDetails(
      effectiveDate: map['effectiveDate'] as DateTime,
      type: AgreementType.fromString(map['type'] as String),
      version: map['version'] as String,
      extra: map['extra'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AgreementDetails &&
        other.type == type &&
        other.effectiveDate == effectiveDate &&
        other.version == version;
  }

  @override
  int get hashCode => effectiveDate.hashCode ^ version.hashCode ^ type.hashCode;
}

final agreementsDocumentsDataSourceProvider =
    Provider<AgreementsDocumentsDataSource>(
  (ref) {
    final firestore = ref.watch(firestoreProvider);
    return FirebaseAgreementsDocumentsDataSource(firestore: firestore);
  },
);

abstract class AgreementsDocumentsDataSource {
  /// If [after] is provided, only emit TOS with effectiveDate > [after].
  Stream<List<AgreementDetails>> getTermsOfUseDetailsStream({
    DateTime? after,
  });

  /// If [after] is provided, only emit privacy policies with effectiveDate > [after].
  Stream<List<AgreementDetails>> getPrivacyPolicyDetailsStream({
    DateTime? after,
  });

  Stream<AgreementDetails?> latestEffectiveTermsOfUseStream();
  Stream<AgreementDetails?> latestEffectivePrivacyPolicyStream();
}
