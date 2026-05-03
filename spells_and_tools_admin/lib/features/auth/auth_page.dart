import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [
        EmailAuthProvider(),
        // Add other providers if needed
      ],
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          // Use GoRouter for navigation after sign in
          context.go('/main');
        }),
      ],
    );
  }
}
