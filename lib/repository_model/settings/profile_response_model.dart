// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:oda/local_database/user_box/user.dart';

ProfileResponseModel profileResponseModelFromJson(String str) => ProfileResponseModel.fromJson(json.decode(str));

String profileResponseModelToJson(ProfileResponseModel data) => json.encode(data.toJson());

class ProfileResponseModel {
  final String status;
  final ProfileResponse response;

  ProfileResponseModel({
    required this.status,
    required this.response,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) => ProfileResponseModel(
        status: json["status"] ?? '',
        response: ProfileResponse.fromJson(json["response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class ProfileResponse {
  final String message;
  final UserProfile profile;

  ProfileResponse({
    required this.message,
    required this.profile,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
        message: json["message"] ?? "",
        profile: UserProfile.fromJson(json["profile"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "profile": profile.toJson(),
      };
}

/*class ProfileProfile {
  final String id;
  final String userName;
  final String employeeType;
  final String designation;
  final String langCode;
  final String image;
  final String superSalesName;
  final String superSalesPhone;
  final String rsmName;
  final String rsmPhone;
  final List<Datum> data;
  final String userCode;

  ProfileProfile({
    required this.id,
    required this.userName,
    required this.employeeType,
    required this.designation,
    required this.langCode,
    required this.image,
    required this.superSalesName,
    required this.superSalesPhone,
    required this.rsmName,
    required this.rsmPhone,
    required this.data,
    required this.userCode,
  });

  factory ProfileProfile.fromJson(Map<String, dynamic> json) => ProfileProfile(
        id: json["id"] ?? "",
        userName: json["user_name"] ?? "",
        employeeType: json["employee_type"] ?? "",
        designation: json["designation"] ?? "",
        langCode: json["lang_code"] ?? "",
        image: json["image"] ?? "",
        superSalesName: json["supersales_name"] ?? "",
        superSalesPhone: json["supersales_phone"] ?? "",
        rsmName: json["rsm_name"] ?? "",
        rsmPhone: json["rsm_phone"] ?? "",
        userCode: json["user_code"] ?? "",
        data: List<Datum>.from((json["data"] ?? []).map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "employee_type": employeeType,
        "designation": designation,
        "lang_code": langCode,
        "image": image,
        "supersales_name": superSalesName,
        "supersales_phone": superSalesPhone,
        "rsm_name": rsmName,
        "rsm_phone": rsmPhone,
        "user_code": userCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  final String label;
  final String value;
  final String icon;

  Datum({
    required this.label,
    required this.value,
    required this.icon,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        label: json["label"] ?? "",
        value: json["value"] ?? "",
        icon: json["icon"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "icon": icon,
      };
}*/
