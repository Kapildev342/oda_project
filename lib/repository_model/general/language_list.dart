// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:oda/local_database/language_box/language.dart';

LanguageListApiModel languageListApiModelFromJson(String str) => LanguageListApiModel.fromJson(json.decode(str));

String languageListApiModelToJson(LanguageListApiModel data) => json.encode(data.toJson());

class LanguageListApiModel {
  final String status;
  final Response response;

  LanguageListApiModel({
    required this.status,
    required this.response,
  });

  factory LanguageListApiModel.fromJson(Map<String, dynamic> json) => LanguageListApiModel(
        status: json["status"] ?? "",
        response: Response.fromJson(json["response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class Response {
  final List<LanguageListModel> languages;

  Response({
    required this.languages,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        languages: List<LanguageListModel>.from((json["languages"] ?? []).map((x) => LanguageListModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "languages": List<dynamic>.from(languages.map((x) => x.toJson())),
      };
}
