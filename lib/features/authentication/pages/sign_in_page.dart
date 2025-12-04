import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInPage extends HookConsumerWidget {
  final Function(BuildContext context)? onSignedIn;
  final Function(BuildContext context)? onSkipped;
  final Function(BuildContext context)? onError;
  final bool showSignIn;

  const SignInPage._({
    required this.showSignIn,
    this.onSignedIn,
    this.onError,
    this.onSkipped,
    super.key,
  });

  factory SignInPage.signIn({
    required Function(BuildContext context) onSignedIn,
    Function(BuildContext context)? onError,
    Key? key,
  }) {
    return SignInPage._(
      showSignIn: true,
      onSignedIn: onSignedIn,
      onSkipped: null,
      onError: onError,
      key: key,
    );
  }

  factory SignInPage.register({
    required Function(BuildContext context) onAuthenticated,
    Function(BuildContext context)? onError,
    Function(BuildContext context)? onSkipped,
    Key? key,
  }) {
    return SignInPage._(
      showSignIn: false,
      onSignedIn: onAuthenticated,
      onSkipped: onSkipped,
      onError: onError,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final oAuthButtonVariant = OAuthButtonVariant.icon_and_text;
    final actions = [
      AuthStateChangeAction<SignedIn>(
        (context, state) {
          onSignedIn?.call(context);
        },
      ),
      AuthStateChangeAction<UserCreated>(
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
    ];
    final footerBuilder = onSkipped != null
        ? (context, action) {
            return TextButton(
              onPressed: () {
                onSkipped?.call(context);
              },
              child: const Text('Skip Sign In'),
            );
          }
        : null;
    final body = showSignIn
        ? SignInScreen(
            oauthButtonVariant: oAuthButtonVariant,
            providers: null,
            actions: actions,
            footerBuilder: footerBuilder,
          )
        : RegisterScreen(
            oauthButtonVariant: oAuthButtonVariant,
            providers: null,
            actions: actions,
            footerBuilder: footerBuilder,
          );
    return Scaffold(
      body: body,
    );
  }
}
