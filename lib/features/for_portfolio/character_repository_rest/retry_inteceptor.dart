import 'dart:math';

import 'package:dio/dio.dart';

class RetryInterceptor implements Interceptor {
  final int maxRetries;
  final Duration retryInterval;
  final Dio dio;

  RetryInterceptor({
    required this.maxRetries,
    required this.retryInterval,
    required this.dio,
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    var retries = 0;
    final options = err.requestOptions;

    sendRequest(RequestOptions options) {
      return dio.request(
        options.path,
        cancelToken: options.cancelToken,
        data: options.data,
        onReceiveProgress: options.onReceiveProgress,
        onSendProgress: options.onSendProgress,
        queryParameters: options.queryParameters,
        options: Options(
          contentType: options.contentType,
          extra: options.extra,
          followRedirects: options.followRedirects,
          headers: options.headers,
          receiveDataWhenStatusError: options.receiveDataWhenStatusError,
          responseType: options.responseType,
          sendTimeout: options.sendTimeout,
          validateStatus: options.validateStatus,
          receiveTimeout: options.receiveTimeout,
          listFormat: options.listFormat,
          maxRedirects: options.maxRedirects,
          method: options.method,
          persistentConnection: options.persistentConnection,
          preserveHeaderCase: options.preserveHeaderCase,
          requestEncoder: options.requestEncoder,
          responseDecoder: options.responseDecoder,
        ),
      );
    }

    while (retries < maxRetries) {
      try {
        final response = await sendRequest(options);
        handler.resolve(response);
        return;
      } catch (e) {
        retries++;
        await Future.delayed(retryInterval);
      }
    }
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
