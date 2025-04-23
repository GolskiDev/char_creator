import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DefaultPageWrapper<T> extends ConsumerWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;

  const DefaultPageWrapper(
      {super.key, required this.future, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const DefaultPageWrapperLoading();
        } else if (snapshot.hasError) {
          return DefaultPageWrapperError(
            error: snapshot.error.toString(),
          );
        } else if (snapshot.hasData) {
          return builder(context, snapshot.data!);
        }
        return const DefaultPageWrapperLoading();
      },
    );
  }
}

class DefaultPageWrapperError extends StatelessWidget {
  final String error;

  const DefaultPageWrapperError({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class DefaultPageWrapperLoading extends StatelessWidget {
  const DefaultPageWrapperLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
