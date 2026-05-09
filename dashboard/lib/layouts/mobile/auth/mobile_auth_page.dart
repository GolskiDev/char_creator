import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileAuthPage extends StatelessWidget {
  const MobileAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [EmailAuthProvider()],
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          context.go('/main');
        }),
      ],
    );
  }
}
