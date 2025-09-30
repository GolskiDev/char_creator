import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_accepted_agreements_data_source.dart';

extension UserAcceptedAgreementFirestore on UserAcceptedAgreement {
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'version': version,
      'acceptedAt': Timestamp.fromDate(acceptedAt),
      'type': type.name,
    };
  }

  static UserAcceptedAgreement fromFirestore(Map<String, dynamic> map) {
    return UserAcceptedAgreement(
      uid: map['uid'] as String,
      version: map['version'] as String,
      acceptedAt: (map['acceptedAt'] as Timestamp).toDate(),
      type: AgreementType.fromString(map['type'] as String),
    );
  }
}

class FirebaseUserAcceptedAgreementsDataSource
    implements UserAcceptedAgreementsDataSource {
  FirebaseUserAcceptedAgreementsDataSource({
    required this.uid,
    required this.firestore,
  });

  final FirebaseFirestore firestore;
  final String uid;

  static String userAcceptedAgreementsCollectionPath = 'userAcceptedAgreements';

  @override
  Future<void> acceptAgreement({
    required String version,
    required AgreementType type,
  }) {
    final collection =
        firestore.collection(userAcceptedAgreementsCollectionPath);
    final doc = collection.doc();
    final userAcceptedAgreement = UserAcceptedAgreement(
      uid: uid,
      version: version,
      acceptedAt: DateTime.now(),
      type: type,
    );
    return doc.set(userAcceptedAgreement.toFirestore());
  }

  @override
  Stream<UserAcceptedAgreement?> lastAcceptedAgreementStream(
    AgreementType type,
  ) {
    final collection =
        firestore.collection(userAcceptedAgreementsCollectionPath);
    final query = collection
        .where('uid', isEqualTo: uid)
        .where('type', isEqualTo: type.name)
        .orderBy('acceptedAt', descending: true)
        .limit(1);
    return query.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      final doc = snapshot.docs.first;
      final data = doc.data();
      return UserAcceptedAgreementFirestore.fromFirestore(data);
    });
  }
}
