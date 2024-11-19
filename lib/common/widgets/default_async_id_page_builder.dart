import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/for_portfolio/character_repository_rest/rest_errors.dart';

class DefaultAsyncIdPageBuilder<T> extends HookConsumerWidget {
  const DefaultAsyncIdPageBuilder({
    required this.asyncValue,
    this.onError,
    this.onNull,
    this.pageBuilder,
    super.key,
  });
  final AsyncValue<T?> asyncValue;
  final Widget? onError;
  final Widget? onNull;
  final Widget Function(BuildContext context, T value)? pageBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (asyncValue) {
      case AsyncValue(value: final T data):
        if (pageBuilder != null) {
          return pageBuilder!(context, data);
        }
      case AsyncValue(
          value: null,
          isLoading: false,
          hasError: false,
        ):
        if (onNull != null) {
          return onNull!;
        }
        return Scaffold(
          appBar: AppBar(),
          body: notFoundErrorBuilder(),
        );
      case AsyncValue(isLoading: true):
        return Scaffold(
          appBar: AppBar(),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      case AsyncError(
          error: final Object error,
          stackTrace: final StackTrace? stackTrace
        ):
        return Scaffold(
          appBar: AppBar(),
          body: defaultErrorBuilder(error, stackTrace),
        );
    }
    return Scaffold(
      appBar: AppBar(),
      body: defaultErrorBuilder(null, null),
    );
  }

  Widget defaultErrorBuilder(Object? error, StackTrace? stackTrace) {
    return switch (error) {
      RestError _ => _restErrorBuilder(error),
      _ => onError ?? unexpectedErrorBuilder(),
    };
  }

  Widget _restErrorBuilder(RestError error) {
    return switch (error) {
      NotFoundError _ => notFoundErrorBuilder(),
      BadRequestError _ => unexpectedErrorBuilder(),
      ServerError _ => serverErrorBuilder(),
      UnexpectedError _ => unexpectedErrorBuilder(),
    };
  }

  Widget unexpectedErrorBuilder() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error),
          SizedBox(height: 8),
          Text('Something unexpected happened. Please try again later.'),
        ],
      ),
    );
  }

  Widget notFoundErrorBuilder() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off),
          SizedBox(height: 8),
          Text('We couldn\'t find the data you are looking for.'),
        ],
      ),
    );
  }

  Widget serverErrorBuilder() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error),
          SizedBox(height: 8),
          Text('Something went wrong on our side. Please try again later.'),
        ],
      ),
    );
  }
}
