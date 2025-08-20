// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:hive/hive.dart';
import 'package:oda/local_database/pick_list_box/pick_list.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class UserResponse extends HiveObject {
  @HiveField(0)
  late HeadersLoggedData loggedHeaders;

  @HiveField(1)
  late List<String> bottomItemsList;

  @HiveField(2)
  late List<String> sideItemsList;

  @HiveField(3)
  late UserProfile userProfile;

  @HiveField(4)
  late Uint8List profileNetworkImage;

  @HiveField(5)
  late List<FilterOptionsResponse> filterItemsListOptions;

  @HiveField(6)
  late List<FilterOptionsResponse> filterCustomersOptions;

  @HiveField(7)
  late List<FilterOptionsResponse> usersList;

  @HiveField(8)
  late S3 s3;

  UserResponse({
    required this.loggedHeaders,
    required this.bottomItemsList,
    required this.sideItemsList,
    required this.userProfile,
    required this.profileNetworkImage,
    required this.filterItemsListOptions,
    required this.filterCustomersOptions,
    required this.usersList,
    required this.s3,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        loggedHeaders: HeadersLoggedData.fromJson(json["logged_headers"] ?? {}),
        bottomItemsList: List<String>.from((json["bottom_items_list"] ?? []).map((x) => x)),
        sideItemsList: List<String>.from((json["side_items_list"] ?? []).map((x) => x)),
        userProfile: UserProfile.fromJson(json["user_profile"] ?? {}),
        profileNetworkImage: json["profile_network_image"] ?? Uint8List.fromList([]),
        filterItemsListOptions:
            List<FilterOptionsResponse>.from((json["filter_items_list_options"] ?? []).map((x) => FilterOptionsResponse.fromJson(x))),
        filterCustomersOptions:
            List<FilterOptionsResponse>.from((json["filter_customers_options"] ?? []).map((x) => FilterOptionsResponse.fromJson(x))),
        usersList: List<FilterOptionsResponse>.from((json["users_list"] ?? []).map((x) => FilterOptionsResponse.fromJson(x))),
    s3: S3.fromJson(json["s3"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "logged_headers": loggedHeaders.toJson(),
        "bottom_items_list": bottomItemsList,
        "side_items_list": sideItemsList,
        "user_profile": userProfile,
        "profile_network_image": profileNetworkImage,
        "filter_items_list_options": List<dynamic>.from(filterItemsListOptions.map((x) => x.toJson())),
        "filter_customers_options": List<dynamic>.from(filterCustomersOptions.map((x) => x.toJson())),
        "users_list": List<dynamic>.from(usersList.map((x) => x.toJson())),
    "s3": s3.toJson(),
      };
}

@HiveType(typeId: 1)
class HeadersLoggedData extends HiveObject {
  @HiveField(0)
  late String authorization;

  @HiveField(1)
  late String deviceId;

  @HiveField(2)
  late String deviceType;

  @HiveField(3)
  late String deviceMaker;

  @HiveField(4)
  late String deviceModel;

  @HiveField(5)
  late String firmware;

  @HiveField(6)
  late String appVersion;

  @HiveField(7)
  late String lang;

  @HiveField(8)
  late String pushKey;

  HeadersLoggedData({
    required this.authorization,
    required this.deviceId,
    required this.deviceType,
    required this.deviceMaker,
    required this.deviceModel,
    required this.firmware,
    required this.appVersion,
    required this.lang,
    required this.pushKey,
  });

  factory HeadersLoggedData.fromJson(Map<String, dynamic> json) => HeadersLoggedData(
        authorization: json["Authorization"] ?? "",
        deviceId: json["deviceid"] ?? "",
        deviceType: json["devicetype"] ?? "",
        deviceMaker: json["devicemaker"] ?? "",
        deviceModel: json["devicemodel"] ?? '',
        firmware: json["firmware"] ?? "",
        appVersion: json["appversion"] ?? "",
        lang: json["lang"] ?? "",
        pushKey: json["pushkey"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Authorization": authorization,
        "deviceid": deviceId,
        "devicetype": deviceType,
        "devicemaker": deviceMaker,
        "devicemodel": deviceModel,
        "firmware": firmware,
        "appversion": appVersion,
        "lang": lang,
        "pushkey": pushKey,
      };
}

@HiveType(typeId: 2)
class UserProfile extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String userName;

  @HiveField(2)
  late String employeeType;

  @HiveField(3)
  late String designation;

  @HiveField(4)
  late String langCode;

  @HiveField(5)
  late String image;

  @HiveField(6)
  late String superSalesName;

  @HiveField(7)
  late String superSalesPhone;

  @HiveField(8)
  late String rsmName;

  @HiveField(9)
  late String rsmPhone;

  @HiveField(10)
  late List<Datum> data;

  @HiveField(11)
  late String userCode;

  UserProfile({
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

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
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

@HiveType(typeId: 3)
class Datum extends HiveObject {
  @HiveField(0)
  late String label;

  @HiveField(1)
  late String value;

  @HiveField(2)
  late String icon;

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
}

@HiveType(typeId: 4)
class FilterOptionsResponse extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String label;

  @HiveField(2)
  String code;

  @HiveField(3)
  bool status;

  @HiveField(4)
  String image;

  @HiveField(5)
  List<Room> room;

  FilterOptionsResponse({
    required this.id,
    required this.label,
    required this.code,
    required this.status,
    required this.image,
    required this.room,
  });

  factory FilterOptionsResponse.fromJson(Map<String, dynamic> json) => FilterOptionsResponse(
        id: json["id"] ?? "",
        label: json["label"] ?? json["item_name"] ?? "",
        code: json["code"] ?? json["item_code"] ?? "",
        image: json["image"] ?? "",
        status: json["status"] ?? false,
        room: List<Room>.from((json["room"] ?? []).map((x) => Room.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "code": code,
        "image": image,
        "status": status,
        "room": room,
      };
}

@HiveType(typeId: 5)
class Room extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String label;

  @HiveField(2)
  String type;

  @HiveField(3)
  String selection;

  @HiveField(4)
  bool status;

  @HiveField(5)
  List<Zone> zone;

  Room({
    required this.id,
    required this.label,
    required this.type,
    required this.selection,
    required this.status,
    required this.zone,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["id"] ?? "",
        label: json["label"] ?? "",
        type: json["type"] ?? "",
        selection: json["selection"] ?? "",
        status: json["status"] ?? false,
        zone: List<Zone>.from((json["zone"] ?? []).map((x) => Zone.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "type": type,
        "selection": selection,
        "status": status,
        "zone": zone,
      };
}

@HiveType(typeId: 6)
class Zone extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String label;

  @HiveField(2)
  String type;

  @HiveField(3)
  bool status;

  @HiveField(4)
  String selection;

  Zone({
    required this.id,
    required this.label,
    required this.type,
    required this.status,
    required this.selection,
  });

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
        id: json["id"] ?? "",
        label: json["label"] ?? "",
        type: json["type"] ?? "",
        status: json["status"] ?? false,
        selection: json["selection"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "type": type,
        "status": status,
        "selection": selection,
      };
}
