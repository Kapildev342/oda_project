// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:oda/repository_model/catch_weight/catch_weight_filter_model.dart';

PickListFilterModel pickListFilterModelFromJson(String str) => PickListFilterModel.fromJson(json.decode(str));

String pickListFilterModelToJson(PickListFilterModel data) => json.encode(data.toJson());

class PickListFilterModel {
  final String status;
  final FilterResponse response;

  PickListFilterModel({
    required this.status,
    required this.response,
  });

  factory PickListFilterModel.fromJson(Map<String, dynamic> json) => PickListFilterModel(
        status: json["status"] ?? "",
        response: FilterResponse.fromJson(json["response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}
