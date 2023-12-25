import 'package:booking/session_cache.dart';
import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    //option
    options.headers['Authorization'] = 'Bearer ${SessionCache.token ?? ""}';
    options.headers['Cookie'] = 'jwt_token= ${SessionCache.token ?? ""}';


    return handler.next(options);
  }
}
