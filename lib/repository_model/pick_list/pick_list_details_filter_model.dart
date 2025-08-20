// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:oda/local_database/pick_list_box/pick_list.dart';

PickListDetailsFilterModel pickListDetailsFilterModelFromJson(String str) => PickListDetailsFilterModel.fromJson(json.decode(str));

String pickListDetailsFilterModelToJson(PickListDetailsFilterModel data) => json.encode(data.toJson());

class PickListDetailsFilterModel {
  String status;
  Response response;

  PickListDetailsFilterModel({
    required this.status,
    required this.response,
  });

  factory PickListDetailsFilterModel.fromJson(Map<String, dynamic> json) => PickListDetailsFilterModel(
    status: json["status"]??"",
    response: Response.fromJson(json["response"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": response.toJson(),
  };
}

class Response {
  List<Filter> filters;

  Response({
    required this.filters,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    filters: List<Filter>.from((json["filters"]??[]).map((x) => Filter.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "filters": List<dynamic>.from(filters.map((x) => x.toJson())),
  };
}
