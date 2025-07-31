import 'dart:developer' as dev;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

import '../../services/firestore.dart';

final isUserSignedInProvider = FutureProvider<bool>(
  (ref) async {
    final currentUser = await ref.watch(currentUserProvider2.future);
    return currentUser != null;
  },
);

final currentUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(authControllerProvider).authStateChanges,
);

final currentUserProvider2 = StreamProvider<User?>(
  (ref) => ref.watch(authControllerProvider).idTokenChanges,
);

final authControllerProvider = Provider<FirebaseAuthController>(
  (ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    return FirebaseAuthController(firebaseAuth);
  },
);

class FirebaseAuthController {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthController(this.firebaseAuth);

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Stream<User?> get idTokenChanges => firebaseAuth.idTokenChanges();

  Stream<User?> get userChanges => firebaseAuth.userChanges();

  Future<void> signInAnonymously({
    Function? onSignIn,
    Function? onError,
  }) async {
    try {
      await firebaseAuth.signInAnonymously();
    } catch (e) {
      dev.log(
        'Error signing in anonymously: $e',
        name: 'FirebaseAuthController.signInAnonymously',
        error: e,
      );
      onError?.call();
      return;
    }
    onSignIn?.call();
  }
}
