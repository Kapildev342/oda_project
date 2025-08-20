// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';

CatchWeightListModel catchWeightListModelFromJson(String str) => CatchWeightListModel.fromJson(json.decode(str));

String catchWeightListModelToJson(CatchWeightListModel data) => json.encode(data.toJson());

class CatchWeightListModel {
  final String status;
  final CatchWeightListResponse response;

  CatchWeightListModel({
    required this.status,
    required this.response,
  });

  factory CatchWeightListModel.fromJson(Map<String, dynamic> json) => CatchWeightListModel(
        status: json["status"] ?? "",
        response: CatchWeightListResponse.fromJson(json["response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class CatchWeightListResponse {
  int yetToUpdate;
  int updated;
  int unavailable;
  int completed;
  List<ReasonItem> unavailableReasons;
  List<FilterOptionsResponse> alternativeItems;
  List<Item> items;

  CatchWeightListResponse({
    required this.yetToUpdate,
    required this.updated,
    required this.unavailable,
    required this.completed,
    required this.unavailableReasons,
    required this.alternativeItems,
    required this.items,
  });

  factory CatchWeightListResponse.fromJson(Map<String, dynamic> json) => CatchWeightListResponse(
        yetToUpdate: json["yet_to_update"] ?? 0,
        updated: json["updated"] ?? 0,
        unavailable: json["unavailable"] ?? 0,
        completed: json["completed"] ?? 0,
        unavailableReasons: List<ReasonItem>.from((json["unavailable_reasons"] ?? []).map((x) => ReasonItem.fromJson(x))),
        alternativeItems: List<FilterOptionsResponse>.from((json["altername_items"] ?? []).map((x) => FilterOptionsResponse.fromJson(x))),
        items: List<Item>.from((json["items"] ?? []).map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "yet_to_update": yetToUpdate,
        "updated": updated,
        "unavailable": unavailable,
        "completed": completed,
        "unavailable_reasons": List<dynamic>.from(unavailableReasons.map((x) => x)),
        "altername_items": List<dynamic>.from(alternativeItems.map((x) => x.toJson())),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ReasonItem {
  final String id;
  final String code;
  final String description;

  ReasonItem({
    required this.id,
    required this.code,
    required this.description,
  });

  factory ReasonItem.fromJson(Map<String, dynamic> json) => ReasonItem(
        id: json["id"] ?? "",
        code: json["code"] ?? "",
        description: json["description"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
      };
}

class AlternativeItem {
  final String id;
  final String itemName;
  final String itemCode;

  AlternativeItem({
    required this.id,
    required this.itemName,
    required this.itemCode,
  });

  factory AlternativeItem.fromJson(Map<String, dynamic> json) => AlternativeItem(
        id: json["id"] ?? "",
        itemName: json["item_name"] ?? "",
        itemCode: json["item_code"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "item_name": itemName,
        "item_code": itemCode,
      };
}

class Item {
  String id;
  String soNumber;
  String status;
  String entryTime;
  String updatedTime;
  String itemCode;
  String itemName;
  String itemImage;
  String customerName;
  String customerCode;
  String reqQuantity;
  String availQty;
  List<String> availQtyParticulars;
  String alternativeItemName;
  String alternativeItemCode;
  String reason;
  String updatedBy;
  String requestedBy;
  String shipToCode;
  String weightUnit;
  bool undoStatus;

  Item({
    required this.id,
    required this.soNumber,
    required this.status,
    required this.entryTime,
    required this.updatedTime,
    required this.itemCode,
    required this.itemName,
    required this.itemImage,
    required this.customerName,
    required this.customerCode,
    required this.reqQuantity,
    required this.availQty,
    required this.availQtyParticulars,
    required this.alternativeItemName,
    required this.alternativeItemCode,
    required this.reason,
    required this.updatedBy,
    required this.requestedBy,
    required this.shipToCode,
    required this.weightUnit,
    required this.undoStatus,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"] ?? "",
        soNumber: json["so_number"] ?? "",
        status: json["status"] ?? "",
        entryTime: json["entry_time"] ?? "",
        updatedTime: json["updated_time"] ?? "",
        itemCode: json["item_code"] ?? "",
        itemName: json["item_name"] ?? "",
        itemImage: json["item_image"] ?? "",
        customerName: json["customer_name"] ?? "",
        customerCode: json["customer_code"] ?? "",
        reqQuantity: json["req_quantity"] ?? "",
        availQty: json["avail_qty"] ?? "",
        availQtyParticulars: getIt<Functions>().getStringToList(value: json["avail_qty_particulars"] ?? "25.000,88.222,999.222", quantity: json["avail_qty"] ?? "", weightUnit: json["weight_unit"] ?? ""),
        alternativeItemName: json["alternative_item_name"] ?? "",
        alternativeItemCode: json["alternative_item_code"] ?? "",
        reason: json["reason"] ?? "",
        updatedBy: json["updated_by"] ?? "",
        requestedBy: json["requested_by"] ?? "Store Keeper",
        shipToCode: json["ship_to_code"] ?? "",
        weightUnit: json["weight_unit"] ?? "",
        undoStatus: json["undo_status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "so_number": soNumber,
        "status": status,
        "entry_time": entryTime,
        "updated_time": updatedTime,
        "item_code": itemCode,
        "item_name": itemName,
        "item_image": itemImage,
        "customer_name": customerName,
        "customer_code": customerCode,
        "req_quantity": reqQuantity,
        "avail_qty": availQty,
        "avail_qty_particulars": availQtyParticulars,
        "alternative_item_name": alternativeItemName,
        "alternative_item_code": alternativeItemCode,
        "reason": reason,
        "updated_by": updatedBy,
        "requested_by": requestedBy,
        "ship_to_code": shipToCode,
        "weight_unit": weightUnit,
        "undo_status": undoStatus,
      };
}
