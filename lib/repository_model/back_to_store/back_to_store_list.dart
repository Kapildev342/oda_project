// Dart imports:
import 'dart:convert';

BackToStoreListModel backToStoreListModelFromJson(String str) => BackToStoreListModel.fromJson(json.decode(str));

String backToStoreListModelToJson(BackToStoreListModel data) => json.encode(data.toJson());

class BackToStoreListModel {
  final String status;
  final BackToStoreResponse response;

  BackToStoreListModel({
    required this.status,
    required this.response,
  });

  factory BackToStoreListModel.fromJson(Map<String, dynamic> json) => BackToStoreListModel(
        status: json["status"],
        response: BackToStoreResponse.fromJson(json["response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class BackToStoreResponse {
  int yetToUpdate;
  int updated;
  int unavailable;
  bool addBtsStatus;
  List<Item> items;
  List<UnavailableBTSReason> unavailableReasons;

  BackToStoreResponse({
    required this.yetToUpdate,
    required this.updated,
    required this.unavailable,
    required this.items,
    required this.addBtsStatus,
    required this.unavailableReasons,
  });

  factory BackToStoreResponse.fromJson(Map<String, dynamic> json) => BackToStoreResponse(
        yetToUpdate: json["yet_to_update"] ?? 0,
        updated: json["updated"] ?? 0,
        unavailable: json["unavailable"] ?? 0,
    addBtsStatus: json["add_bts_status"] ?? false,
        items: List<Item>.from((json["items"] ?? []).map((x) => Item.fromJson(x))),
        unavailableReasons: List<UnavailableBTSReason>.from((json["unavailable_reasons"] ?? []).map((x) => UnavailableBTSReason.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "yet_to_update": yetToUpdate,
        "updated": updated,
        "unavailable": unavailable,
        "add_bts_status": addBtsStatus,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "unavailable_reasons": List<dynamic>.from(unavailableReasons.map((x) => x.toJson())),
      };
}

class Item {
  final String id;
  final String soNumber;
  final String status;
  final String entryTime;
  final String updatedTime;
  final String itemCode;
  final String itemName;
  final String itemImage;
  final String customerName;
  final String customerCode;
  final String quantity;
  final String pickedQty;
  final String btsReason;
  final String unavailReason;
  final String unavailNotes;
  final String updatedBy;
  final dynamic requestedBy;
  final String uom;
  final String btsNotes;
  final String remarks;
  final String itemType;
  final String typeColor;
  final String source;
  final String location;
  final String reason;
  final bool removeBtsStatus;

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
    required this.quantity,
    required this.pickedQty,
    required this.btsReason,
    required this.unavailReason,
    required this.unavailNotes,
    required this.updatedBy,
    required this.requestedBy,
    required this.uom,
    required this.btsNotes,
    required this.remarks,
    required this.itemType,
    required this.typeColor,
    required this.source,
    required this.location,
    required this.reason,
    required this.removeBtsStatus,
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
        quantity: json["quantity"] ?? "",
        pickedQty: json["picked_qty"] ?? "",
        btsReason: json["bts_reason"] ?? "",
        unavailReason: json["unavail_reason"] ?? "",
    unavailNotes: json["unavail_notes"] ?? "Item not available",
        updatedBy: json["updated_by"] ?? "",
        requestedBy: json["requested_by"] ?? "",
        uom: json["uom"] ?? "",
        btsNotes: json["bts_notes"] ?? "",
        remarks: json["remarks"] ?? "",
        itemType: json["item_type"] ?? "",
        typeColor: json["type_color"] ?? "",
        source: json["source"] ?? "",
        location: json["location"] ?? "",
        reason: json["reason"] ?? "",
        removeBtsStatus: json["remove_bts_status"] ?? false,
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
        "quantity": quantity,
        "picked_qty": pickedQty,
        "bts_reason": btsReason,
        "unavail_reason": unavailReason,
        "unavail_notes": unavailNotes,
        "updated_by": updatedBy,
        "requested_by": requestedBy,
        "uom": uom,
        "bts_notes": btsNotes,
        "remarks": remarks,
        "item_type": itemType,
        "type_color": typeColor,
        "source": source,
        "location": location,
        "reason": reason,
        "remove_bts_status": removeBtsStatus,
      };
}

class UnavailableBTSReason {
  final String id;
  final String code;
  final String description;

  UnavailableBTSReason({
    required this.id,
    required this.code,
    required this.description,
  });

  factory UnavailableBTSReason.fromJson(Map<String, dynamic> json) => UnavailableBTSReason(
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
