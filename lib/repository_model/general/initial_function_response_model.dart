// Dart imports:
import 'dart:convert';

import 'package:oda/local_database/pick_list_box/pick_list.dart';

InitialFunctionResponseModel initialFunctionResponseModelFromJson(String str) => InitialFunctionResponseModel.fromJson(json.decode(str));

String initialFunctionResponseModelToJson(InitialFunctionResponseModel data) => json.encode(data.toJson());

class InitialFunctionResponseModel {
  final String status;
  final InitialFunctionResponse response;

  InitialFunctionResponseModel({
    required this.status,
    required this.response,
  });

  factory InitialFunctionResponseModel.fromJson(Map<String, dynamic> json) => InitialFunctionResponseModel(
        status: json["status"] ?? "",
        response: InitialFunctionResponse.fromJson(json["response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class InitialFunctionResponse {
  String supportEmail;
  String supportNumber;
  String appMode;
  String infoTitle;
  String infoMsg;
  String infoButton;
  bool dismissInfo;
  bool needAppUpdate;
  String lang;
  String employeeType;
  String androidVersion;
  List<String> sideNav;
  List<String> bottomNav;
  S3 s3;

  InitialFunctionResponse({
    required this.supportEmail,
    required this.supportNumber,
    required this.appMode,
    required this.infoTitle,
    required this.infoMsg,
    required this.infoButton,
    required this.dismissInfo,
    required this.needAppUpdate,
    required this.lang,
    required this.employeeType,
    required this.androidVersion,
    required this.sideNav,
    required this.bottomNav,
    required this.s3,
  });

  factory InitialFunctionResponse.fromJson(Map<String, dynamic> json) => InitialFunctionResponse(
        supportEmail: json["support_email"] ?? "",
        supportNumber: json["support_number"] ?? "",
        appMode: json["app_mode"] ?? "",
        infoTitle: json["info_title"] ?? "",
        infoMsg: json["info_msg"] ?? "",
        infoButton: json["info_button"] ?? "",
        dismissInfo: json["dismiss_info"] ?? false,
        needAppUpdate: json["need_app_update"] ?? false,
        lang: json["lang"] ?? "",
        employeeType: json["employee_type"] ?? "",
        androidVersion: json["andriod_version"] ?? "",
        sideNav: List<String>.from((json["side_nav"] ?? []).map((x) => x)),
        bottomNav: List<String>.from((json["bottom_nav"] ?? []).map((x) => x)),
        s3: S3.fromJson(json["s3"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "support_email": supportEmail,
        "support_number": supportNumber,
        "app_mode": appMode,
        "info_title": infoTitle,
        "info_msg": infoMsg,
        "info_button": infoButton,
        "dismiss_info": dismissInfo,
        "need_app_update": needAppUpdate,
        "lang": lang,
        "employee_type": employeeType,
        "andriod_version": androidVersion,
        "side_nav": List<dynamic>.from(sideNav.map((x) => x)),
        "bottom_nav": List<dynamic>.from(bottomNav.map((x) => x)),
        "s3": s3.toJson(),
      };
}
