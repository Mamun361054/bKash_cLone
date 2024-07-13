import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../utils/app_consts.dart';

class ApiService {
  static Dio? _dio;
  @pragma('vm:entry-point')
  static Dio? getDio() {
    if (_dio == null) {
      BaseOptions options = BaseOptions(baseUrl: AppConst.baseUrlApi);

      _dio = Dio(options);
      _dio!.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        if (kDebugMode) {
          print('Base Url : ${options.baseUrl}');
          print('End Point : ${options.path}');
          print('Method : ${options.method}');
          print('Data : ${options.data}');
          print('headers : ${options.headers}');
        }

        return handler.next(options);
      }, onResponse: (response, handler) {
        if (kDebugMode) {
          print('response data : ${response.data}');
        }
        return handler.next(response);
      }, onError: (DioError e, handler) {
        if (kDebugMode) {
          print('Error Response : ${e.response}');
          print('Error message : ${e.message}');
          print('Error type : ${e.type.name}');
        }
        return handler.next(e);
      }));
    }

    return _dio;
  }
}
