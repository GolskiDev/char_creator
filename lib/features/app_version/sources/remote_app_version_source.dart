import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spells_and_tools/features/app_version/models/app_version_representation.dart';

import '../../../services/firestore.dart';

enum PlatformType {
  android,
  ios;

  static PlatformType get current {
    if (Platform.isAndroid) {
      return PlatformType.android;
    } else if (Platform.isIOS) {
      return PlatformType.ios;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}

abstract interface class RemoteAppVersionSource {
  Stream<AppVersionRepresentation?> get remoteLatestVersionStream;
  Stream<AppVersionRepresentation?> get remoteRequiredVersionStream;
}

final remoteAppVersionSourceProvider = Provider<RemoteAppVersionSource>(
  (ref) {
    final firestore = ref.watch(firestoreProvider);
    return FirebaseRemoteAppVersionSource(firestore: firestore);
  },
);

class FirebaseRemoteAppVersionSource implements RemoteAppVersionSource {
  final FirebaseFirestore firestore;
  static const String documentPath = 'appVersions';

  FirebaseRemoteAppVersionSource({required this.firestore});

  Stream<AppVersionRepresentation?> get remoteLatestVersionStream {
    return firestore
        .collection(documentPath)
        .doc('latest_version')
        .snapshots()
        .map(
      (snapshot) {
        final data = snapshot.data();
        if (data == null) {
          throw StateError('No data found for latest version');
        }
        final version = data[PlatformType.current.name] as String?;
        if (version == null) {
          return null;
        }
        return AppVersionRepresentation.parse(version);
      },
    );
  }

  Stream<AppVersionRepresentation?> get remoteRequiredVersionStream {
    return firestore
        .collection(documentPath)
        .doc('required_version')
        .snapshots()
        .map(
      (snapshot) {
        final data = snapshot.data();
        if (data == null) {
          throw StateError('No data found for required version');
        }
        final version = data[PlatformType.current.name] as String?;
        if (version == null) {
          return null;
        }
        return AppVersionRepresentation.parse(version);
      },
    );
  }
}
