import 'package:cloud_firestore/cloud_firestore.dart';

enum AgreementType {
  termsOfUse,
  privacyPolicy;

  String get collectionName {
    switch (this) {
      case AgreementType.termsOfUse:
        return 'termsOfUseDocuments';
      case AgreementType.privacyPolicy:
        return 'privacyPoliciesDocuments';
    }
  }

  @override
  String toString() {
    switch (this) {
      case AgreementType.termsOfUse:
        return 'termsOfUse';
      case AgreementType.privacyPolicy:
        return 'privacyPolicy';
    }
  }

  static AgreementType fromString(String typeStr) {
    switch (typeStr) {
      case 'termsOfUse':
        return AgreementType.termsOfUse;
      case 'privacyPolicy':
        return AgreementType.privacyPolicy;
      default:
        throw ArgumentError('Unknown AgreementType string: $typeStr');
    }
  }
}

class AgreementModel {
  AgreementType type;
  Timestamp effectiveDate;
  String version;
  Map<String, dynamic> extra;

  AgreementModel({
    required this.type,
    required this.effectiveDate,
    required this.version,
    this.extra = const {},
  });

  factory AgreementModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AgreementModel(
      type: AgreementType.fromString(data['type'] as String),
      effectiveDate: data['effectiveDate'] as Timestamp,
      version: data['version'] as String,
      extra: data['extra'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'effectiveDate': effectiveDate,
      'version': version,
      'extra': extra,
      'type': type.toString(),
    };
  }
}
