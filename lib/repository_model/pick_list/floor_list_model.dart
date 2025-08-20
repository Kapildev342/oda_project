// Dart imports:
import 'dart:convert';

import 'package:oda/local_database/pick_list_box/pick_list.dart';

FloorListModel floorListModelFromJson(String str) => FloorListModel.fromJson(json.decode(str));

String floorListModelToJson(FloorListModel data) => json.encode(data.toJson());

class FloorListModel {
  String status;
  FloorListResponse response;

  FloorListModel({
    required this.status,
    required this.response,
  });

  factory FloorListModel.fromJson(Map<String, dynamic> json) => FloorListModel(
        status: json["status"] ?? "",
        response: FloorListResponse.fromJson(json["response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class FloorListResponse {
  List<FloorLocation> locations;

  FloorListResponse({
    required this.locations,
  });

  factory FloorListResponse.fromJson(Map<String, dynamic> json) => FloorListResponse(
        locations: List<FloorLocation>.from((json["locations"] ?? []).map((x) => FloorLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "locations": List<dynamic>.from(locations.map((x) => x.toJson())),
      };
}
