// Dart imports:
import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  final String status;
  final Response response;

  LoginResponseModel({
    required this.status,
    required this.response,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        status: json["status"] ?? "",
        response: Response.fromJson(json["response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class Response {
  final String message;
  final String token;
  final String role;

  Response({
    required this.message,
    required this.token,
    required this.role,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        message: json["message"] ?? "",
        token: json["token"] ?? "",
        role: json["role"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
        "role": role,
      };
}
