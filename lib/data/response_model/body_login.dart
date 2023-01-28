import 'dart:convert';

class BodyLogin {
  BodyLogin({
    this.phone,
    this.beneficiaryId,
  });

  String? phone;
  String? beneficiaryId;

  factory BodyLogin.fromJson(Map<String, dynamic> json) => BodyLogin(
    phone: json["mob"],
    beneficiaryId: json["beneficiaryId"],
  );

  Map<String, dynamic> toJson() => {
    "mob": phone,
    "beneficiaryId": beneficiaryId,
  };
}

ResponseLogin responseLoginFromJson(String str) => ResponseLogin.fromJson(json.decode(str));

String responseLoginToJson(ResponseLogin data) => json.encode(data.toJson());


class ResponseLogin {
  ResponseLogin({
    this.message,
  });

  String? message;

  factory ResponseLogin.fromJson(Map<String, dynamic> json) => ResponseLogin(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}