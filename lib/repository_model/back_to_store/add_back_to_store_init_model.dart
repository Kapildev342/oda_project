// Dart imports:
import 'dart:convert';

AddBackToStoreInitModel addBackToStoreInitModelFromJson(String str) => AddBackToStoreInitModel.fromJson(json.decode(str));

String addBackToStoreInitModelToJson(AddBackToStoreInitModel data) => json.encode(data.toJson());

class AddBackToStoreInitModel {
  String status;
  AddBackToStoreInitResponse response;

  AddBackToStoreInitModel({
    required this.status,
    required this.response,
  });

  factory AddBackToStoreInitModel.fromJson(Map<String, dynamic> json) => AddBackToStoreInitModel(
    status: json["status"]??"",
    response: AddBackToStoreInitResponse.fromJson(json["response"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": response.toJson(),
  };
}

class AddBackToStoreInitResponse {
  List<AddBackToStoreInitReason> reasons;
  List<AddBackToStoreInitLocation> locations;
  List<AddBackToStoreInitItem> items;

  AddBackToStoreInitResponse({
    required this.reasons,
    required this.locations,
    required this.items,
  });

  factory AddBackToStoreInitResponse.fromJson(Map<String, dynamic> json) => AddBackToStoreInitResponse(
    reasons: List<AddBackToStoreInitReason>.from((json["reasons"]??[]).map((x) => AddBackToStoreInitReason.fromJson(x))),
    locations: List<AddBackToStoreInitLocation>.from((json["locations"]??[]).map((x) => AddBackToStoreInitLocation.fromJson(x))),
    items: List<AddBackToStoreInitItem>.from((json["items"]??[]).map((x) => AddBackToStoreInitItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "reasons": List<dynamic>.from(reasons.map((x) => x.toJson())),
    "locations": List<dynamic>.from(locations.map((x) => x.toJson())),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class AddBackToStoreInitItem {
  String id;
  String itemName;
  String itemCode;

  AddBackToStoreInitItem({
    required this.id,
    required this.itemName,
    required this.itemCode,
  });

  factory AddBackToStoreInitItem.fromJson(Map<String, dynamic> json) => AddBackToStoreInitItem(
    id: json["id"]??"",
    itemName: json["item_name"]??"",
    itemCode: json["item_code"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "item_name": itemName,
    "item_code": itemCode,
  };
}

class AddBackToStoreInitLocation {
  String id;
  String label;
  String type;

  AddBackToStoreInitLocation({
    required this.id,
    required this.label,
    required this.type,
  });

  factory AddBackToStoreInitLocation.fromJson(Map<String, dynamic> json) => AddBackToStoreInitLocation(
    id: json["id"]??"",
    label: json["label"]??"",
    type: json["type"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "type": type,
  };
}

class AddBackToStoreInitReason {
  String id;
  String label;
  String code;

  AddBackToStoreInitReason({
    required this.id,
    required this.label,
    required this.code,
  });

  factory AddBackToStoreInitReason.fromJson(Map<String, dynamic> json) => AddBackToStoreInitReason(
    id: json["id"]??"",
    label: json["label"]??"",
    code: json["code"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "code": code,
  };
}
