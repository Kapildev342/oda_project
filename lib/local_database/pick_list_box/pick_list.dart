// Package imports:
import 'package:hive/hive.dart';
import 'package:oda/local_database/trip_box/trip_list.dart';
import 'package:oda/local_database/user_box/user.dart';
import 'package:oda/resources/constants.dart';
import 'package:oda/resources/functions.dart';

part 'pick_list.g.dart';

@HiveType(typeId: 18)
class PickListMainResponse extends HiveObject {
  @HiveField(0)
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

@HiveType(typeId: 19)
class PicklistItem extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String picklistNumber;
  @HiveField(2)
  String route;
  @HiveField(3)
  String status;
  @HiveField(4)
  String deliveryArea;
  @HiveField(5)
  String orderType;
  @HiveField(6)
  bool inProgress;
  @HiveField(7)
  String statusColor;
  @HiveField(8)
  String statusBGColor;
  @HiveField(9)
  String created;
  @HiveField(10)
  String createdDate;
  @HiveField(11)
  String createdTime;
  @HiveField(12)
  String completed;
  @HiveField(13)
  String completedDate;
  @HiveField(14)
  String completedTime;
  @HiveField(15)
  String quantity;
  @HiveField(16)
  String pickedQty;
  @HiveField(17)
  List<HandledByPickList> handledBy;
  @HiveField(18)
  bool disputeStatus;
  @HiveField(19)
  String itemsType;
  @HiveField(20)
  String itemsColor;
  @HiveField(21)
  String itemLocation;
  @HiveField(22)
  List<String> soNum;
  @HiveField(23)
  List<String> soType;
  @HiveField(24)
  String businessDate;

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
    required this.itemLocation,
    required this.soNum,
    required this.soType,
    required this.businessDate,
  });

  factory PicklistItem.fromJson(Map<String, dynamic> json) => PicklistItem(
      id: json["id"] ?? json["picklist_id"] ?? "0",
      picklistNumber: json["picklist_num"] ?? "123456789000",
      route: json["route"] ?? "Colombia",
      status: json["status"] ?? json["picklist_status"] ?? "Pending",
      deliveryArea: json["delivery_area"] ?? "",
      orderType: json["picklist_priority"] ?? "",
      inProgress: json["in_progress"] ?? false,
      statusColor: "0XFF${json["status_color"] ?? json["picklist_status_color"] ?? "FFFFFF"}",
      statusBGColor: "0XFF${json["status_bg_color"] ?? json["picklist_status_bg_color"] ?? "FFFFFF"}",
      created: json["created"] ?? json["picklist_created"] ?? "26/11/2024, 04:21 PM",
      createdDate: json["created"] != null
          ? json["created_date"] ??
              (json["created"] == null || json["created"] == "" ? "26/11/2024, 04:21 PM" : json["created"])
                  .toString()
                  .split(",")[0]
                  .trim()
          : json["created_date"] ??
              (json["picklist_created"] == null || json["picklist_created"] == "" ? "26/11/2024, 04:21 PM" : json["picklist_created"])
                  .toString()
                  .split(",")[0]
                  .trim(),
      createdTime: json["created"] != null
          ? json["created_time"] ??
              (json["created"] == null || json["created"] == "" ? "26/11/2024, 04:21 PM" : json["created"])
                  .toString()
                  .split(",")[1]
                  .trim()
          : json["created_time"] ??
              (json["picklist_created"] == null || json["picklist_created"] == "" ? "26/11/2024, 04:21 PM" : json["picklist_created"])
                  .toString()
                  .split(",")[1]
                  .trim(),
      completed: json["completed"] ?? "26/11/2024, 04:21 PM",
      completedDate: json["completed"] == null || json["completed"] == "" ? "" : (json["completed"]).toString().split(",")[0].trim(),
      completedTime: json["completed"] == null || json["completed"] == "" ? "" : (json["completed"]).toString().split(",")[1].trim(),
      quantity: json["total_items"] ?? json["total_picklist_items"] ?? "200",
      pickedQty: json["picked_items"] ?? json["total_picklist_picked_items"] ?? "120",
      handledBy: List<HandledByPickList>.from((json["handled_by"] ?? []).map((x) => HandledByPickList.fromJson(x))),
      disputeStatus: json["dispute_status"] ?? json["picklist_dispute_status"] ?? false,
      itemsType: json["items_type"] ?? json["picklist_item_type"] ?? "D",
      itemLocation: json["floor"] ?? "",
      soNum: List<String>.from((json["so_num_list"] ?? []).map((x) => x)),
      soType: List<String>.from((json["so_type_list"] ?? []).map((x) => x)),
      businessDate: json["business_dt"] ?? "14/04/2025, 12:00 AM",
      itemsColor: "0XFF${json["items_color"] ?? json["picklist_item_color"] ?? "B25000"}");

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
        "floor": itemLocation,
        "items_color": itemsColor,
        "so_num": List<dynamic>.from(soNum.map((x) => x)),
        "so_type": List<dynamic>.from(soType.map((x) => x)),
        "business_dt": businessDate,
      };
}

@HiveType(typeId: 20)
class HandledByPickList extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String code;
  @HiveField(2)
  String name;
  @HiveField(3)
  String image;
  @HiveField(4)
  String pickedItems;

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
        name: json["name"] ?? json["label"] ?? "",
        image: json["image"] ?? "",
        pickedItems: (json['picked_items'] ?? "0").toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "image": image,
        "picked_items": pickedItems,
      };
}

@HiveType(typeId: 21)
class PickListDetailsResponse extends HiveObject {
  @HiveField(0)
  String picklistId;
  @HiveField(1)
  String picklistNum;
  @HiveField(2)
  String route;
  @HiveField(3)
  String picklistStatus;
  @HiveField(4)
  String picklistTime;
  @HiveField(5)
  String totalItems;
  @HiveField(6)
  String pickedItems;
  @HiveField(7)
  bool isReadyToMoveComplete;
  @HiveField(8)
  bool isCompleted;
  @HiveField(9)
  List<HandledByPickList> handledBy;
  @HiveField(10)
  int yetToPick;
  @HiveField(11)
  int picked;
  @HiveField(12)
  int partial;
  @HiveField(13)
  int unavailable;
  @HiveField(14)
  List<PickListDetailsItem> items;
  @HiveField(15)
  List<UnavailableReason> unavailableReasons;
  @HiveField(16)
  List<UnavailableReason> completeReasons;
  @HiveField(17)
  List<FilterOptionsResponse> alternateItems;
  @HiveField(18)
  Filter locationFilter;
  @HiveField(19)
  PickListSessionInfo sessionInfo;
  @HiveField(20)
  List<TimelineInfo> timelineInfo;

  PickListDetailsResponse({
    required this.picklistId,
    required this.picklistNum,
    required this.route,
    required this.picklistStatus,
    required this.picklistTime,
    required this.totalItems,
    required this.pickedItems,
    required this.isReadyToMoveComplete,
    required this.isCompleted,
    required this.handledBy,
    required this.yetToPick,
    required this.picked,
    required this.partial,
    required this.unavailable,
    required this.items,
    required this.unavailableReasons,
    required this.completeReasons,
    required this.alternateItems,
    required this.locationFilter,
    required this.sessionInfo,
    required this.timelineInfo,
  });

  factory PickListDetailsResponse.fromJson(Map<String, dynamic> json) => PickListDetailsResponse(
        picklistId: json["picklist_id"] ?? "",
        picklistNum: json["picklist_num"] ?? "",
        route: json["route"] ?? "",
        picklistStatus: json["picklist_status"] ?? "",
        picklistTime: json["picklist_time"] ?? json["picklist_created"] ?? "",
        totalItems: json["total_items"] ?? json["total_picklist_items"] ?? "",
        pickedItems: json["picked_items"] ?? json["total_picklist_picked_items"] ?? "",
        isReadyToMoveComplete: json["do_complete_action"] ?? false,
        isCompleted: json["is_completed"] ?? false,
        handledBy: List<HandledByPickList>.from((json["handled_by"] ?? []).map((x) => HandledByPickList.fromJson(x))),
        yetToPick: int.parse((json["yet_to_pick"] ?? 0).toString()),
        picked: int.parse((json["picked"] ?? 0).toString()),
        partial: int.parse((json["partial"] ?? 0).toString()),
        unavailable: int.parse((json["unavailable"] ?? 0).toString()),
        items: List<PickListDetailsItem>.from((json["items"] ?? []).map((x) => PickListDetailsItem.fromJson(x))),
        unavailableReasons:
            List<UnavailableReason>.from((json["unavailable_reasons"] ?? []).map((x) => UnavailableReason.fromJson(x))),
        completeReasons: List<UnavailableReason>.from((json["complete_reasons"] ?? []).map((x) => UnavailableReason.fromJson(x))),
        alternateItems:
            List<FilterOptionsResponse>.from((json["alternate_items"] ?? []).map((x) => FilterOptionsResponse.fromJson(x))),
        locationFilter: Filter.fromJson(json["location_filter_options"] ?? {}),
        sessionInfo: PickListSessionInfo.fromJson(json["session_info"] ?? {}),
        timelineInfo: List<TimelineInfo>.from((json["timeline_info"] ?? []).map((x) => TimelineInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "picklist_id": picklistId,
        "picklist_num": picklistNum,
        "route": route,
        "picklist_status": picklistStatus,
        "picklist_time": picklistTime,
        "total_items": totalItems,
        "picked_items": pickedItems,
        "do_complete_action": isReadyToMoveComplete,
        "is_completed": isCompleted,
        "handled_by": List<dynamic>.from(handledBy.map((x) => x.toJson())),
        "yet_to_pick": yetToPick,
        "picked": picked,
        "partial": partial,
        "unavailable": unavailable,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "unavailable_reasons": List<dynamic>.from(unavailableReasons.map((x) => x.toJson())),
        "complete_reasons": List<dynamic>.from(completeReasons.map((x) => x.toJson())),
        "alternate_items": List<dynamic>.from(alternateItems.map((x) => x.toJson())),
        "location_filter_options": locationFilter.toJson(),
        "session_info": sessionInfo.toJson(),
        "timeline_info": List<dynamic>.from(timelineInfo.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 22)
class PickListDetailsItem extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String itemId;
  @HiveField(2)
  String picklistNum;
  @HiveField(3)
  String status;
  @HiveField(4)
  String itemCode;
  @HiveField(5)
  String itemName;
  @HiveField(6)
  String quantity;
  @HiveField(7)
  String pickedQty;
  @HiveField(8)
  String uom;
  @HiveField(9)
  String itemType;
  @HiveField(10)
  String typeColor;
  @HiveField(11)
  String floor;
  @HiveField(12)
  String room;
  @HiveField(13)
  String zone;
  @HiveField(14)
  String stagingArea;
  @HiveField(15)
  bool isProgressStatus;
  @HiveField(16)
  String packageTerms;
  @HiveField(17)
  String catchWeightStatus;
  @HiveField(18)
  List<CatchWeightItem> catchWeightInfo;
  @HiveField(19)
  List<String> catchWeightInfoForList;
  @HiveField(20)
  List<CatchWeightItem> catchWeightInfoPicked;
  @HiveField(21)
  List<HandledByPickList> handledBy;
  @HiveField(22)
  dynamic locationDisputeInfo;
  @HiveField(23)
  String unavailableReason;
  @HiveField(24)
  String alternativeItemName;
  @HiveField(25)
  String alternativeItemCode;
  @HiveField(26)
  List<PickListBatchesList> batchesList;
  @HiveField(27)
  bool allowUndo;
  @HiveField(28)
  String soNum;

  PickListDetailsItem({
    required this.id,
    required this.itemId,
    required this.picklistNum,
    required this.status,
    required this.itemCode,
    required this.itemName,
    required this.quantity,
    required this.pickedQty,
    required this.uom,
    required this.itemType,
    required this.typeColor,
    required this.floor,
    required this.room,
    required this.zone,
    required this.stagingArea,
    required this.isProgressStatus,
    required this.packageTerms,
    required this.catchWeightStatus,
    required this.catchWeightInfo,
    required this.catchWeightInfoForList,
    required this.catchWeightInfoPicked,
    required this.handledBy,
    required this.locationDisputeInfo,
    required this.unavailableReason,
    required this.alternativeItemName,
    required this.alternativeItemCode,
    required this.batchesList,
    required this.allowUndo,
    required this.soNum,
  });

  factory PickListDetailsItem.fromJson(Map<String, dynamic> json) => PickListDetailsItem(
        id: json["id"] ?? json["picklist_item_id"] ?? "",
        itemId: json["item_id"] ?? "",
        picklistNum: json["picklist_num"] ?? "",
        status: json["status"] ?? json["picklist_item_status"] ?? "",
        itemCode: json["item_code"] ?? "",
        itemName: json["item_name"] ?? "",
        quantity: json["quantity"] ?? json["item_quantity"] ?? "",
        pickedQty: json["picked_qty"] ?? json["item_picked_qty"] ?? "",
        uom: json["uom"] ?? "",
        itemType: json["item_type"] ?? "",
        typeColor: "0XFF${json["type_color"] ?? "FFFFFF"}",
        floor: json["floor"] ?? "",
        room: json["room"] ?? "",
        zone: json["zone"] ?? "",
        stagingArea: json["staging_area"] ?? "",
        isProgressStatus: json["progress_status"] ?? false,
        packageTerms: json["package_terms"] ?? "",
        catchWeightStatus: json["catchweight_status"] ?? "",
        catchWeightInfo: json["catchweight_info"] == ""
            ? []
            : getIt<Functions>().getStringToCatchWeight(
                value: json["catchweight_info"] ?? "25.000,88.222,999.222,1,9999,2,0.5,0.0,25.000,88.222,999.222,1,9999,2,0.5,0.0"),
        catchWeightInfoForList: json["picked_catchweight_info"] == ""
            ? []
            : getIt<Functions>().getStringToList(
                value:
                    json["picked_catchweight_info"] ?? "25.000,88.222,999.222,1,9999,2,0.5,0.0,25.000,88.222,999.222,1,9999,2,0.5,0.0",
                quantity: json["picked_qty"] ?? "",
                weightUnit: json["uom"] ?? ""),
        catchWeightInfoPicked: json["picked_catchweight_info"] == ""
            ? []
            : getIt<Functions>().getStringToCatchWeight(value: json["picked_catchweight_info"] ?? "25.000,1"),
        handledBy: List<HandledByPickList>.from((json["handled_by"] ?? []).map((x) => HandledByPickList.fromJson(x))),
        locationDisputeInfo: json["location_dispute_info"] ?? [],
        unavailableReason: json["unavail_reason"] ?? "",
        alternativeItemName: json["alternative_item_name"] ?? "",
        alternativeItemCode: json["alternative_item_code"] ?? "",
        allowUndo: json["allow_undo"] ?? false,
        soNum: json["so_num"] ?? "123456",
        batchesList: List<PickListBatchesList>.from((json["batches_list"] ?? []).map((x) => PickListBatchesList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "item_id": itemId,
        "picklist_num": picklistNum,
        "status": status,
        "item_code": itemCode,
        "item_name": itemName,
        "quantity": quantity,
        "picked_qty": pickedQty,
        "uom": uom,
        "item_type": itemType,
        "type_color": typeColor,
        "floor": floor,
        "room": room,
        "zone": zone,
        "staging_area": stagingArea,
        "progress_status": isProgressStatus,
        "package_terms": packageTerms,
        "catchweight_status": catchWeightStatus,
        "catchweight_info": List<dynamic>.from(catchWeightInfo.map((x) => x.toJson())),
        "picked_catchweight_info": List<dynamic>.from(catchWeightInfoPicked.map((x) => x.toJson())),
        "handled_by": List<dynamic>.from(handledBy.map((x) => x.toJson())),
        "location_dispute_info": locationDisputeInfo,
        "unavail_reason": unavailableReason,
        "alternative_item_name": alternativeItemName,
        "alternative_item_code": alternativeItemCode,
        "allow_undo": allowUndo,
        "so_num": soNum,
        "batches_list": List<dynamic>.from(batchesList.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 23)
class PickListBatchesList extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String itemId;
  @HiveField(2)
  String batchNum;
  @HiveField(3)
  String expiryDate;
  @HiveField(4)
  String stockType;
  @HiveField(5)
  String quantity;
  @HiveField(6)
  String pickedQty;

  PickListBatchesList({
    required this.id,
    required this.itemId,
    required this.batchNum,
    required this.expiryDate,
    required this.stockType,
    required this.quantity,
    required this.pickedQty,
  });

  factory PickListBatchesList.fromJson(Map<String, dynamic> json) => PickListBatchesList(
        id: json["id"] ?? json["batch_id"] ?? '',
        itemId: json["item_id"] ?? '',
        batchNum: json["batch_num"] ?? '',
        expiryDate: (json["expiry_date"] ?? "").toString().substring(0, 10),
        stockType: json["stock_type"] ?? '',
        quantity: json["quantity"] ?? '',
        pickedQty: json["picked_qty"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "item_id": itemId,
        "batch_num": batchNum,
        "expiry_date": expiryDate,
        "stock_type": stockType,
        "quantity": quantity,
        "picked_qty": pickedQty,
      };
}

@HiveType(typeId: 24)
class CatchWeightItem extends HiveObject {
  @HiveField(0)
  String data;
  @HiveField(1)
  bool isSelected;
  @HiveField(2)
  bool isSelectedAlready;

  CatchWeightItem({
    required this.data,
    required this.isSelected,
    required this.isSelectedAlready,
  });

  factory CatchWeightItem.fromJson(Map<String, dynamic> json) => CatchWeightItem(
        data: json["data"] ?? '',
        isSelected: json["is_selected"] ?? false,
        isSelectedAlready: json["is_selected_already"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "data": data,
        "is_selected": isSelected,
        "is_selected_already": isSelectedAlready,
      };
}

@HiveType(typeId: 25)
class LocationDisputeInfo extends HiveObject {
  @HiveField(0)
  String updatedOn;
  @HiveField(1)
  String floor;
  @HiveField(2)
  String room;
  @HiveField(3)
  String zone;

  LocationDisputeInfo({
    required this.updatedOn,
    required this.floor,
    required this.room,
    required this.zone,
  });

  factory LocationDisputeInfo.fromJson(Map<String, dynamic> json) => LocationDisputeInfo(
        updatedOn: json["updated_on"] ?? "",
        floor: json["floor"] ?? "",
        room: json["room"] ?? "",
        zone: json["zone"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "updated_on": updatedOn,
        "floor": floor,
        "room": room,
        "zone": zone,
      };
}

@HiveType(typeId: 26)
class PickListSessionInfo extends HiveObject {
  @HiveField(0)
  bool isOpened;

  @HiveField(1)
  String id;

  @HiveField(2)
  String pending;

  @HiveField(3)
  String picked;

  @HiveField(4)
  String partial;

  @HiveField(5)
  String unavailable;

  @HiveField(6)
  String sessionStartTimestamp;

  @HiveField(7)
  String timeSpendSeconds;

  @HiveField(8)
  List<String> partialIdsList;

  @HiveField(9)
  List<PickListDetailsItem> pendingList;

  @HiveField(10)
  List<PickListDetailsItem> pickedList;

  @HiveField(11)
  List<PickListDetailsItem> partialList;

  @HiveField(12)
  List<PickListDetailsItem> unavailableList;

  PickListSessionInfo({
    required this.isOpened,
    required this.id,
    required this.pending,
    required this.picked,
    required this.partial,
    required this.unavailable,
    required this.sessionStartTimestamp,
    required this.timeSpendSeconds,
    required this.partialIdsList,
    required this.pendingList,
    required this.pickedList,
    required this.partialList,
    required this.unavailableList,
  });

  factory PickListSessionInfo.fromJson(Map<String, dynamic> json) => PickListSessionInfo(
        isOpened: json["is_opened"] ?? false,
        id: json["id"] ?? "",
        pending: json["pending"] ?? "0",
        picked: json["picked"] ?? "0",
        partial: json["partial"] ?? "0",
        unavailable: json["unavailable"] ?? "0",
        sessionStartTimestamp: json["session_start_timestamp"] ?? "",
        timeSpendSeconds: json["time_spend_seconds"] ?? "0",
        partialIdsList: List<String>.from((json["partial_ids_list"] ?? []).map((x) => x)),
        pendingList: List<PickListDetailsItem>.from((json["pending_list"] ?? []).map((x) => PickListDetailsItem.fromJson(x))),
        pickedList: List<PickListDetailsItem>.from((json["picked_list"] ?? []).map((x) => PickListDetailsItem.fromJson(x))),
        partialList: List<PickListDetailsItem>.from((json["partial_list"] ?? []).map((x) => PickListDetailsItem.fromJson(x))),
        unavailableList: List<PickListDetailsItem>.from((json["unavailable_list"] ?? []).map((x) => PickListDetailsItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "is_opened": isOpened,
        "id": id,
        "pending": pending,
        "picked": picked,
        "partial": partial,
        "unavailable": unavailable,
        "session_start_timestamp": sessionStartTimestamp,
        "time_spend_seconds": timeSpendSeconds,
        "partial_ids_list": List<dynamic>.from(partialIdsList.map((x) => x)),
        "pending_list": List<dynamic>.from(pendingList.map((x) => x.toJson())),
        "picked_list": List<dynamic>.from(pickedList.map((x) => x.toJson())),
        "partial_list": List<dynamic>.from(partialList.map((x) => x.toJson())),
        "unavailable_list": List<dynamic>.from(unavailableList.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 27)
class TimelineInfo extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String description;
  @HiveField(2)
  String time;

  TimelineInfo({
    required this.id,
    required this.description,
    required this.time,
  });

  factory TimelineInfo.fromJson(Map<String, dynamic> json) => TimelineInfo(
        id: json["id"] ?? "0",
        description: json["description"] ?? "",
        time: json["time"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "time": time,
      };
}

@HiveType(typeId: 28)
class Filter extends HiveObject {
  @HiveField(0)
  String type;
  @HiveField(1)
  String label;
  @HiveField(2)
  String selection;
  @HiveField(3)
  List<FilterOptionsResponse> options;
  @HiveField(4)
  bool getOptions;
  @HiveField(5)
  bool status;

  Filter({
    required this.type,
    required this.label,
    required this.selection,
    required this.options,
    required this.getOptions,
    required this.status,
  });

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        type: json["type"] ?? '',
        label: json["label"] ?? '',
        selection: json["selection"] ?? '',
        options: List<FilterOptionsResponse>.from((json["options"] ?? []).map((x) => FilterOptionsResponse.fromJson(x))),
        status: json["status"] ?? false,
        getOptions: json["get_options"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "label": label,
        "selection": selection,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
        "get_options": getOptions,
        "status": status,
      };
}

@HiveType(typeId: 29)
class FloorLocation extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String label;
  @HiveField(2)
  String type;

  FloorLocation({
    required this.id,
    required this.label,
    required this.type,
  });

  factory FloorLocation.fromJson(Map<String, dynamic> json) => FloorLocation(
        id: json["id"] ?? "",
        label: json["label"] ?? "",
        type: json["type"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "type": type,
      };
}

@HiveType(typeId: 30)
class StagingLocation extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String label;
  @HiveField(2)
  String type;

  StagingLocation({
    required this.id,
    required this.label,
    required this.type,
  });

  factory StagingLocation.fromJson(Map<String, dynamic> json) => StagingLocation(
        id: json["id"] ?? "",
        label: json["label"] ?? "",
        type: json["type"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "type": type,
      };
}

@HiveType(typeId: 31)
class PartialPickListDetailsItem extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String itemId;
  @HiveField(2)
  String picklistNum;
  @HiveField(3)
  String status;
  @HiveField(4)
  String itemCode;
  @HiveField(5)
  String itemName;
  @HiveField(6)
  String quantity;
  @HiveField(7)
  String pickedQty;
  @HiveField(8)
  String uom;
  @HiveField(9)
  String itemType;
  @HiveField(10)
  String typeColor;
  @HiveField(11)
  String floor;
  @HiveField(12)
  String room;
  @HiveField(13)
  String zone;
  @HiveField(14)
  String stagingArea;
  @HiveField(15)
  bool isProgressStatus;
  @HiveField(16)
  String packageTerms;
  @HiveField(17)
  String catchWeightStatus;
  @HiveField(18)
  List<CatchWeightItem> catchWeightInfo;
  @HiveField(19)
  List<String> catchWeightInfoForList;
  @HiveField(20)
  List<CatchWeightItem> catchWeightInfoPicked;
  @HiveField(21)
  List<HandledByPickList> handledBy;
  @HiveField(22)
  dynamic locationDisputeInfo;
  @HiveField(23)
  String unavailableReason;
  @HiveField(24)
  String alternativeItemName;
  @HiveField(25)
  String alternativeItemCode;
  @HiveField(26)
  List<PickListBatchesList> batchesList;
  @HiveField(27)
  bool allowUndo;

  PartialPickListDetailsItem({
    required this.id,
    required this.itemId,
    required this.picklistNum,
    required this.status,
    required this.itemCode,
    required this.itemName,
    required this.quantity,
    required this.pickedQty,
    required this.uom,
    required this.itemType,
    required this.typeColor,
    required this.floor,
    required this.room,
    required this.zone,
    required this.stagingArea,
    required this.isProgressStatus,
    required this.packageTerms,
    required this.catchWeightStatus,
    required this.catchWeightInfo,
    required this.catchWeightInfoForList,
    required this.catchWeightInfoPicked,
    required this.handledBy,
    required this.locationDisputeInfo,
    required this.unavailableReason,
    required this.alternativeItemName,
    required this.alternativeItemCode,
    required this.batchesList,
    required this.allowUndo,
  });

  factory PartialPickListDetailsItem.fromJson(Map<String, dynamic> json) => PartialPickListDetailsItem(
        id: json["id"] ?? json["picklist_item_id"] ?? "",
        itemId: json["item_id"] ?? "",
        picklistNum: json["picklist_num"] ?? "",
        status: json["status"] ?? json["picklist_item_status"] ?? "",
        itemCode: json["item_code"] ?? "",
        itemName: json["item_name"] ?? "",
        quantity: json["quantity"] ?? json["item_quantity"] ?? "",
        pickedQty: json["picked_qty"] ?? json["item_picked_qty"] ?? "",
        uom: json["uom"] ?? "",
        itemType: json["item_type"] ?? "",
        typeColor: json["type_color"] ?? "0XFFFFFFFF",
        floor: json["floor"] ?? "",
        room: json["room"] ?? "",
        zone: json["zone"] ?? "",
        stagingArea: json["staging_area"] ?? "",
        isProgressStatus: json["progress_status"] ?? false,
        packageTerms: json["package_terms"] ?? "",
        catchWeightStatus: json["catchweight_status"] ?? "",
        catchWeightInfo: json["catchweight_info"] == ""
            ? []
            : getIt<Functions>().getStringToCatchWeight(
                value: json["catchweight_info"] ?? "25.000,88.222,999.222,1,9999,2,0.5,0.0,25.000,88.222,999.222,1,9999,2,0.5,0.0"),
        catchWeightInfoForList: json["picked_catchweight_info"] == ""
            ? []
            : getIt<Functions>().getStringToList(
                value:
                    json["picked_catchweight_info"] ?? "25.000,88.222,999.222,1,9999,2,0.5,0.0,25.000,88.222,999.222,1,9999,2,0.5,0.0",
                quantity: json["picked_qty"] ?? "",
                weightUnit: json["uom"] ?? ""),
        catchWeightInfoPicked: json["picked_catchweight_info"] == ""
            ? []
            : getIt<Functions>().getStringToCatchWeight(value: json["picked_catchweight_info"] ?? "25.000,1"),
        handledBy: List<HandledByPickList>.from((json["handled_by"] ?? []).map((x) => HandledByPickList.fromJson(x))),
        locationDisputeInfo: json["location_dispute_info"] ?? [],
        unavailableReason: json["unavail_reason"] ?? "",
        alternativeItemName: json["alternative_item_name"] ?? "",
        alternativeItemCode: json["alternative_item_code"] ?? "",
        allowUndo: json["allow_undo"] ?? false,
        batchesList: List<PickListBatchesList>.from((json["batches_list"] ?? []).map((x) => PickListBatchesList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "item_id": itemId,
        "picklist_num": picklistNum,
        "status": status,
        "item_code": itemCode,
        "item_name": itemName,
        "quantity": quantity,
        "picked_qty": pickedQty,
        "uom": uom,
        "item_type": itemType,
        "type_color": typeColor,
        "floor": floor,
        "room": room,
        "zone": zone,
        "staging_area": stagingArea,
        "progress_status": isProgressStatus,
        "package_terms": packageTerms,
        "catchweight_status": catchWeightStatus,
        "catchweight_info": List<dynamic>.from(catchWeightInfo.map((x) => x.toJson())),
        "picked_catchweight_info": List<dynamic>.from(catchWeightInfoPicked.map((x) => x.toJson())),
        "handled_by": List<dynamic>.from(handledBy.map((x) => x.toJson())),
        "location_dispute_info": locationDisputeInfo,
        "unavail_reason": unavailableReason,
        "alternative_item_name": alternativeItemName,
        "alternative_item_code": alternativeItemCode,
        "allow_undo": allowUndo,
        "batches_list": List<dynamic>.from(batchesList.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 32)
class LocalTempDataPickList extends HiveObject {
  @HiveField(0)
  String queryData;

  LocalTempDataPickList({required this.queryData});

  factory LocalTempDataPickList.fromJson(Map<String, dynamic> json) => LocalTempDataPickList(
        queryData: json["query_data"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "query_data": queryData,
      };
}

@HiveType(typeId: 33)
class S3 extends HiveObject {
  @HiveField(0)
  final String bucketName;

  @HiveField(1)
  final String accessKey;

  @HiveField(2)
  final String secretKey;

  @HiveField(3)
  final String region;

  @HiveField(4)
  final String url;

  @HiveField(5)
  final String path;

  S3({
    required this.bucketName,
    required this.accessKey,
    required this.secretKey,
    required this.region,
    required this.url,
    required this.path,
  });

  factory S3.fromJson(Map<String, dynamic> json) => S3(
        bucketName: json["bucket_name"] ?? "",
        accessKey: json["access_key"] ?? "",
        secretKey: json["secret_key"] ?? "",
        region: json["region"] ?? "",
        url: json["url"] ?? "",
        path: json["path"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "bucket_name": bucketName,
        "access_key": accessKey,
        "secret_key": secretKey,
        "region": region,
        "url": url,
        "path": path,
      };
}

@HiveType(typeId: 34)
class InvoiceData extends HiveObject {
  @HiveField(0)
  String invoiceId;

  @HiveField(1)
  String invoiceNum;

  @HiveField(2)
  String invoiceDate;

  @HiveField(3)
  String invoiceTotal;

  @HiveField(4)
  String invoiceItems;

  @HiveField(5)
  String tripId;

  @HiveField(6)
  String soId;

  @HiveField(7)
  String itemId;

  InvoiceData({
    required this.invoiceId,
    required this.invoiceNum,
    required this.invoiceDate,
    required this.invoiceTotal,
    required this.invoiceItems,
    required this.tripId,
    required this.soId,
    required this.itemId,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) => InvoiceData(
        invoiceId: json["invoice_id"] ?? "",
        invoiceNum: json["invoice_num"] ?? "",
        invoiceDate: json["invoice_date"] ?? "",
        invoiceTotal: json["invoice_total"] ?? "",
        invoiceItems: json["invoice_items"] ?? "",
        tripId: json["trip_id"] ?? '',
        soId: json["so_id"] ?? '',
        itemId: json["line_item_id"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "invoice_id": invoiceId,
        "invoice_num": invoiceNum,
        "invoice_date": invoiceDate,
        "invoice_total": invoiceTotal,
        "invoice_items": invoiceItems,
        "trip_id": tripId,
        "so_id": soId,
        "line_item_id": itemId,
      };
}

@HiveType(typeId: 35)
class LoadingLocation extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String label;
  @HiveField(2)
  String type;

  LoadingLocation({
    required this.id,
    required this.label,
    required this.type,
  });

  factory LoadingLocation.fromJson(Map<String, dynamic> json) => LoadingLocation(
        id: json["id"] ?? "",
        label: json["label"] ?? "",
        type: json["type"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "type": type,
      };
}
