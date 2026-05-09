import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';

final firebaseAuthProvider = FutureProvider<FirebaseAuth>((ref) async {
  await ref.watch(firebaseInitProvider.future);
  return FirebaseAuth.instance;
});

final authStateProvider = StreamProvider<User?>((ref) async* {
  final firebaseAuth = ref.watch(firebaseAuthProvider).asData?.value;
  if (firebaseAuth == null) {
    yield* Stream<User?>.empty();
    return;
  }
  yield* firebaseAuth.authStateChanges();
});

/// Synchronous provider to check if user is authenticated.
final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
  final user = await ref.watch(authStateProvider.future);
  return user != null;
});
