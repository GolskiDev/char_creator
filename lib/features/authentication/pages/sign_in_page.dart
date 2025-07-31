import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInPage extends HookConsumerWidget {
  final Function(BuildContext context)? onSignedIn;
  final Function(BuildContext context)? onSkipped;
  final Function(BuildContext context)? onError;

  const SignInPage({
    this.onSignedIn,
    this.onError,
    this.onSkipped,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SignInScreen(
        headerBuilder: (context, constraints, _) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Welcome to the App',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
        oauthButtonVariant: OAuthButtonVariant.icon_and_text,
        providers: [
          EmailAuthProvider(),
          GoogleProvider(clientId: 'YOUR_CLIENT_ID'),
        ],
        actions: [
          AuthStateChangeAction<SignedIn>(
            (context, state) {
              onSignedIn?.call(context);
            },
          ),
          AuthStateChangeAction<AuthFailed>(
            (context, state) {
              onError?.call(context);
            },
          ),
          AuthCancelledAction(
            (context) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sign-in cancelled'),
                ),
              );
            },
          ),
        ],
        footerBuilder: onSkipped != null
            ? (context, action) {
                return TextButton(
                  onPressed: () {
                    onSkipped?.call(context);
                  },
                  child: const Text('Skip Sign In'),
                );
              }
            : null,
      ),
    );
  }
}
