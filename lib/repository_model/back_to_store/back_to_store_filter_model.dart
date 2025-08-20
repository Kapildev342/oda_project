// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:oda/local_database/pick_list_box/pick_list.dart';

BackToStoreFilterModel backToStoreFilterModelFromJson(String str) => BackToStoreFilterModel.fromJson(json.decode(str));

String backToStoreFilterModelToJson(BackToStoreFilterModel data) => json.encode(data.toJson());

class BackToStoreFilterModel {
  final String status;
  final BackToStoreFilterResponse response;

  BackToStoreFilterModel({
    required this.status,
    required this.response,
  });

  factory BackToStoreFilterModel.fromJson(Map<String, dynamic> json) => BackToStoreFilterModel(
        status: json["status"],
        response: BackToStoreFilterResponse.fromJson(json["response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class BackToStoreFilterResponse {
  final List<Filter> filters;

  BackToStoreFilterResponse({
    required this.filters,
  });

  factory BackToStoreFilterResponse.fromJson(Map<String, dynamic> json) => BackToStoreFilterResponse(
        filters: List<Filter>.from((json["filters"] ?? []).map((x) => Filter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "filters": List<dynamic>.from(filters.map((x) => x.toJson())),
      };
}

class Option {
  final String id;
  final String label;
  final String code;

  Option({
    required this.id,
    required this.label,
    required this.code,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"] ?? "",
        label: json["label"] ?? "",
        code: json["code"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "code": code,
      };
}
