import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../response_model/body_login.dart';
import '../response_structure/api_response.dart';
import 'api_service.dart';

class AuthRepository {
  /// Login API -----------------
  static Future<ApiResponse<ResponseLogin>> getLogin(BodyLogin bodyLogin) async {
    try {
      EasyLoading.show(status: 'loading...');
      var response = await ApiService.getDio()!.post("/get-login2", data: bodyLogin);
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.data);
        }
        var obj = responseLoginFromJson(response.toString());
        return ApiResponse(
            httpCode: response.statusCode,
            data: obj);
      } else {
        var obj = responseLoginFromJson(response.toString());
        return ApiResponse(
            httpCode: response.statusCode,
            data: obj);
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        EasyLoading.dismiss();
        var obj = responseLoginFromJson(e.response.toString());

        return ApiResponse(
          httpCode: e.response!.statusCode,
          success: e.response!.data["result"],
          message: e.response!.data["message"],
          error: obj,
        );
      } else {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(e.message);
        }
        return ApiResponse(httpCode: -1, message: "Connection error ${e.message}");
      }
    }
  }
}