import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeeYouSoonPage extends ConsumerWidget {
  final Function? onGoBack;
  const SeeYouSoonPage({
    this.onGoBack,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Thank you for using our app!\n We hope to see you again soon!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            if (onGoBack != null)
              ElevatedButton(
                onPressed: () {
                  onGoBack?.call();
                },
                child: const Text('Go Back'),
              ),
          ],
        ),
      ),
    );
  }
}
