// Dart imports:
import 'dart:convert';

import 'package:oda/local_database/pick_list_box/pick_list.dart';

PickListMainModel pickListMainModelFromJson(String str) => PickListMainModel.fromJson(json.decode(str));

String pickListMainModelToJson(PickListMainModel data) => json.encode(data.toJson());

class PickListMainModel {
  final String status;
  final PickListMainResponse response;

  PickListMainModel({
    required this.status,
    required this.response,
  });

  factory PickListMainModel.fromJson(Map<String, dynamic> json) => PickListMainModel(
        status: json["status"] ?? "",
        response: PickListMainResponse.fromJson(json["response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

/*class PickListMainResponse {
  List<PicklistItem> picklist;

  PickListMainResponse({
    required this.picklist,
  });

  factory PickListMainResponse.fromJson(Map<String, dynamic> json) => PickListMainResponse(
        picklist: List<PicklistItem>.from((json["picklist"] ?? []).map((x) => PicklistItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "picklist": List<dynamic>.from(picklist.map((x) => x.toJson())),
      };
}

class PicklistItem {
  String id;
  String picklistNumber;
  String route;
  String status;
  String deliveryArea;
  String orderType;
  bool inProgress;
  String statusColor;
  String statusBGColor;
  String created;
  String createdDate;
  String createdTime;
  String completed;
  String completedDate;
  String completedTime;
  String quantity;
  String pickedQty;
  List<HandledByPickList> handledBy;
  bool disputeStatus;
  String itemsType;
  String itemsColor;

  PicklistItem({
    required this.id,
    required this.picklistNumber,
    required this.route,
    required this.status,
    required this.deliveryArea,
    required this.orderType,
    required this.inProgress,
    required this.statusColor,
    required this.statusBGColor,
    required this.created,
    required this.createdDate,
    required this.createdTime,
    required this.completed,
    required this.completedDate,
    required this.completedTime,
    required this.quantity,
    required this.pickedQty,
    required this.handledBy,
    required this.disputeStatus,
    required this.itemsType,
    required this.itemsColor,
  });

  factory PicklistItem.fromJson(Map<String, dynamic> json) => PicklistItem(
      id: json["id"] ?? json["picklist_id"] ?? "0",
      picklistNumber: json["picklist_num"] ?? "123456789000",
      route: json["route"] ?? "Colombia",
      status: json["status"] ?? json["picklist_status"] ?? "Pending",
      deliveryArea: json["delivery_area"] ?? "",
      orderType: json["picklist_priority"] ?? "",
      inProgress: json["in_progress"] ?? false,
      statusColor: "0XFF${json["status_color"] ??json["picklist_status_color"]?? "FFFFFF"}",
      statusBGColor: "0XFF${json["status_bg_color"] ?? json["picklist_status_bg_color"] ?? "FFFFFF"}",
      created: json["created"] ?? json["picklist_created"]?? "26/11/2024, 04:21 PM",
      createdDate: json["created_date"] ?? (json["created"] == null || json["created"] == "" ? "26/11/2024, 04:21 PM" : json["created"]).toString().split(",")[0].trim(),
      createdTime: json["created_time"] ?? (json["created"] == null || json["created"] == "" ? "26/11/2024, 04:21 PM" : json["created"]).toString().split(",")[1].trim(),
      completed: json["completed"] ?? "26/11/2024, 04:21 PM",
      completedDate: json["completed"] == null || json["completed"] == "" ? "" : (json["completed"]).toString().split(",")[0].trim(),
      completedTime: json["completed"] == null || json["completed"] == "" ? "" : (json["completed"]).toString().split(",")[1].trim(),
      quantity: json["total_items"] ?? json["total_picklist_items"]?? "200",
      pickedQty: json["picked_items"] ?? json["total_picklist_picked_items"]??"120",
      handledBy: List<HandledByPickList>.from((json["handled_by"] ?? []).map((x) => HandledByPickList.fromJson(x))),
      disputeStatus: json["dispute_status"] ?? json["picklist_dispute_status"]?? false,
      itemsType: json["items_type"] ?? json["picklist_item_type"]?? "D",
      itemsColor: "0XFF${json["items_color"] ?? json["picklist_item_color"]?? "B25000"}");

  Map<String, dynamic> toJson() => {
        "id": id,
        "picklist_num": picklistNumber,
        "route": route,
        "status": status,
        "delivery_area": deliveryArea,
        "picklist_priority": orderType,
        "in_progress": inProgress,
        "status_color": statusColor,
        "status_bg_color": statusBGColor,
        "created": created,
        "created_date": createdDate,
        "created_time": createdTime,
        "completed": completed,
        "total_items": quantity,
        "picked_items": pickedQty,
        "handled_by": List<dynamic>.from(handledBy.map((x) => x.toJson())),
        "dispute_status": disputeStatus,
        "items_type": itemsType,
        "items_color": itemsColor,
      };
}

class HandledByPickList {
  final String id;
  final String code;
  final String name;
  final String image;
  final String pickedItems;

  HandledByPickList({
    required this.id,
    required this.code,
    required this.name,
    required this.image,
    required this.pickedItems,
  });

  factory HandledByPickList.fromJson(Map<String, dynamic> json) => HandledByPickList(
        id: json["id"] ?? "",
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        image: json["image"] ?? "",
        pickedItems: (json['picked_items'] ?? "0").toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "image": image,
        "picked_qty": pickedItems,
      };
}*/
