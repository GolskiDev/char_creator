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

    Future<Response> retry() async {
      retries++;
      if (retries <= maxRetries) {
        await Future.delayed(retryInterval);
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
          ),
        );
      } else {
        return err.response!;
      }
    }

    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
  }
}
