import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth_controller.dart';

class SignInAnonymouslyPage extends HookConsumerWidget {
  final Function(BuildContext context)? onSignedIn;
  final Function(BuildContext context)? onError;

  const SignInAnonymouslyPage({
    this.onSignedIn,
    this.onError,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    signIn() async {
      final auth = ref.read(authControllerProvider);
      await auth.signInAnonymously(
        onSignIn: () => onSignedIn?.call(context),
        onError: () => onError?.call(context),
      );
    }

    final currentAction = useState<Future?>(null);

    final snapshot = useFuture(
      currentAction.value,
    );

    final isLoading = snapshot.connectionState == ConnectionState.waiting;

    return Scaffold(
      body: AbsorbPointer(
        absorbing: isLoading,
        child: Column(
          children: [
            Flexible(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sign In Anonymously',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'This will create a temporary account for you. '
                        'You can later link it to a permanent account.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isLoading
                    ? CircularProgressIndicator()
                    : FilledButton(
                        onPressed: () {
                          currentAction.value = signIn();
                        },
                        child: Text(
                          'Sign In Anonymously',
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
