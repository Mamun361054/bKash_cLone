import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:thrift/providers/bkash_provider.dart';
import 'package:thrift/utils/global_state.dart';
import '../../utils/app_consts.dart';

class ApiService {
  static Dio? _dio;

  static Dio? getDio() {
    final phone = globalState.get(userMap)['phoneNumber'];
    final beneficiaryId = globalState.get(userMap)['beneficiaryId'];

    BaseOptions options = BaseOptions(
        baseUrl: AppConst.baseUrlApi,
        headers: {'phone': phone, 'BeneficiaryId': beneficiaryId});

    if (_dio == null) {
      _dio = Dio();
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

    _dio?.options = options;

    return _dio;
  }
}
