

// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:oda/local_database/user_box/user.dart';

FilterOptionsModel filterOptionsModelFromJson(String str) => FilterOptionsModel.fromJson(json.decode(str));

String filterOptionsModelToJson(FilterOptionsModel data) => json.encode(data.toJson());

class FilterOptionsModel {
  final String status;
  final List<FilterOptionsResponse> response;

  FilterOptionsModel({
    required this.status,
    required this.response,
  });

  factory FilterOptionsModel.fromJson(Map<String, dynamic> json) => FilterOptionsModel(
        status: json["status"],
        response: List<FilterOptionsResponse>.from(json["response"].map((x) => FilterOptionsResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class DropItem{
  String id;
  String code;
  String label;

  DropItem({
    required this.id,
    required this.code,
    required this.label,
  });

  factory DropItem.fromJson(Map<String, dynamic> json) => DropItem(
    id: json["id"]??"",
    code: json["code"]??"",
    label: json["label"]??json["description"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "label": label,
  };
}
