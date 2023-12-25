import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'network/interceptors/error_interceptor.dart';

class MapClient {
  static String baseUrl = 'https://nominatim.openstreetmap.org';

  // static const productUrl='http://air-water-api-1398273181.ap-southeast-1.elb.amazonaws.com:8080';
  Dio dio = createDio(baseUrl);
  final tokenDio = Dio(BaseOptions(baseUrl: baseUrl));

  factory MapClient() => _singleton;

  MapClient._internal();

  static final _singleton = MapClient._internal();

  void reInit({String? url}) {
    dio = createDio(url ?? baseUrl);
  }

  static Dio createDio(String domain) {
    baseUrl = domain;
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveTimeout: 30000,
        connectTimeout: 30000,
        sendTimeout: 30000,
        headers:{

        }
      ),
    );

    //add interceptors
    dio.interceptors.addAll({
      //logging interceptor
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: true,
        maxWidth: 120,
      ),
      // TokenInterceptor(),
      //error interceptor
      ErrorInterceptors(),
    });

    //fix HandshakeException: Handshake error in client
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };

    return dio;
  }
}
