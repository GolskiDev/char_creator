import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DefaultAsyncIdPageBuilder<T> extends HookConsumerWidget {
  const DefaultAsyncIdPageBuilder({
    required this.asyncValue,
    this.onError = defaultOnError,
    this.onNull = defaultOnError,
    this.pageBuilder,
    super.key,
  });
  final AsyncValue<T?> asyncValue;
  final Widget onError;
  final Widget onNull;
  final Widget Function(BuildContext context, T value)? pageBuilder;

  static const defaultOnError = Center(
    child: Text("An error occurred"),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return asyncValue.when(
      data: (data) {
        if (data == null) {
          return Scaffold(
            appBar: AppBar(),
            body: onNull,
          );
        }
        if (pageBuilder != null) {
          return pageBuilder!(context, data);
        }
        return Scaffold(
          appBar: AppBar(),
          body: onError,
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(),
        body: onError,
      ),
    );
  }
}
