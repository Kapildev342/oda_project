// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:oda/local_database/pick_list_box/pick_list.dart';

TripListTimeLineApiModel tripListTimeLineApiModelFromJson(String str) => TripListTimeLineApiModel.fromJson(json.decode(str));

String tripListTimeLineApiModelToJson(TripListTimeLineApiModel data) => json.encode(data.toJson());

class TripListTimeLineApiModel {
  String status;
  TimelineInfoResponse response;

  TripListTimeLineApiModel({
    required this.status,
    required this.response,
  });

  factory TripListTimeLineApiModel.fromJson(Map<String, dynamic> json) => TripListTimeLineApiModel(
    status: json["status"],
    response: TimelineInfoResponse.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": response.toJson(),
  };
}

class TimelineInfoResponse {
  List<TimelineInfo> timelineInfo;

  TimelineInfoResponse({
    required this.timelineInfo,
  });

  factory TimelineInfoResponse.fromJson(Map<String, dynamic> json) => TimelineInfoResponse(
    timelineInfo: List<TimelineInfo>.from(json["timeline_info"].map((x) => TimelineInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "timeline_info": List<dynamic>.from(timelineInfo.map((x) => x.toJson())),
  };
}
