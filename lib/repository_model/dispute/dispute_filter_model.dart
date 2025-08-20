// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:oda/local_database/pick_list_box/pick_list.dart';

DisputeFilterModel disputeFilterModelFromJson(String str) => DisputeFilterModel.fromJson(json.decode(str));

String disputeFilterModelToJson(DisputeFilterModel data) => json.encode(data.toJson());

class DisputeFilterModel {
  final String status;
  final DisputeResponse response;

  DisputeFilterModel({
    required this.status,
    required this.response,
  });

  factory DisputeFilterModel.fromJson(Map<String, dynamic> json) => DisputeFilterModel(
    status: json["status"] ?? "",
    response: DisputeResponse.fromJson(json["response"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": response.toJson(),
  };
}

class DisputeResponse {
  final List<Filter> filters;

  DisputeResponse({
    required this.filters,
  });

  factory DisputeResponse.fromJson(Map<String, dynamic> json) => DisputeResponse(
    filters: List<Filter>.from((json["filters"] ?? []).map((x) => Filter.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "filters": List<dynamic>.from(filters.map((x) => x.toJson())),
  };
}
