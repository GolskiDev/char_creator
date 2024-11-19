import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/for_portfolio/character_repository_rest/remote_repository_errors.dart' as remote_errors;
import '../../features/for_portfolio/character_repository_rest/rest_errors.dart' as rest_errors;

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
      rest_errors.RestError error => _restErrorBuilder(error),
      remote_errors.RemoteRepositoryError error => _remoteRepositoryErrorBuilder(error),
      _ => onError ?? unexpectedErrorBuilder(),
    };
  }

  Widget _restErrorBuilder(rest_errors.RestError error) {
    // Don't add default case to switch statement to ensure all RestError subclasses are handled
    return switch (error) {
      rest_errors.NotFoundError _ => notFoundErrorBuilder(),
      rest_errors.BadRequestError _ => unexpectedErrorBuilder(),
      rest_errors.InternalServerError _ => serverErrorBuilder(),
      rest_errors.RequestTimeoutError _ => serverErrorBuilder(),
      rest_errors.UnexpectedError _ => unexpectedErrorBuilder(),
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

  Widget networkQualityErrorBuilder() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.signal_wifi_bad),
          SizedBox(height: 8),
          Text('We are having connection issues. Things you can try:\n\n1. Check your internet connection.\n2. Try again later.'),
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
  
  _remoteRepositoryErrorBuilder(remote_errors.RemoteRepositoryError error) {
    // Don't add default case to switch statement to ensure all RemoteRepositoryError subclasses are handled
    return switch (error) {
      remote_errors.ConnectionError _ => networkQualityErrorBuilder(),
      remote_errors.RequestTimeoutError _ => networkQualityErrorBuilder(),
      remote_errors.UnknownError _ => unexpectedErrorBuilder(),
      remote_errors.BadCertificateError _ => networkQualityErrorBuilder(),
      remote_errors.BadResponseError _ => serverErrorBuilder(),
      remote_errors.RequestCancelledError _ => unexpectedErrorBuilder(),
      remote_errors.UnexpectedError _ => unexpectedErrorBuilder(),
    };
  }
}
