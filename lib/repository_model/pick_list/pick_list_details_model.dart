// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:oda/local_database/pick_list_box/pick_list.dart';

PickListDetailsModel pickListDetailsModelFromJson(String str) => PickListDetailsModel.fromJson(json.decode(str));

String pickListDetailsModelToJson(PickListDetailsModel data) => json.encode(data.toJson());

class PickListDetailsModel {
  String status;
  PickListDetailsResponse response;

  PickListDetailsModel({
    required this.status,
    required this.response,
  });

  factory PickListDetailsModel.fromJson(Map<String, dynamic> json) => PickListDetailsModel(
        status: json["status"] ?? "",
        response: PickListDetailsResponse.fromJson(json["response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

/*class PickListDetailsResponse {
  String picklistId;
  String picklistNum;
  String route;
  String picklistStatus;
  String picklistTime;
  String totalItems;
  String pickedItems;
  bool isReadyToMoveComplete;
  bool isCompleted;
  List<HandledByPickList> handledBy;
  int yetToPick;
  int picked;
  int partial;
  int unavailable;
  List<PickListDetailsItem> items;
  List<UnavailableReason> unavailableReasons;
  List<UnavailableReason> completeReasons;
  List<FilterOptionsResponse> alternateItems;
  Filter locationFilter;
  SessionInfo sessionInfo;
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
        picklistTime: json["picklist_time"] ?? "",
        totalItems: json["total_items"] ?? "",
        pickedItems: json["picked_items"] ?? "",
        isReadyToMoveComplete: json["do_complete_action"] ?? false,
        isCompleted: json["is_completed"] ?? false,
        handledBy: List<HandledByPickList>.from((json["handled_by"] ?? []).map((x) => HandledByPickList.fromJson(x))),
        yetToPick: int.parse((json["yet_to_pick"] ?? 0).toString()),
        picked: int.parse((json["picked"] ?? 0).toString()),
        partial: int.parse((json["partial"] ?? 0).toString()),
        unavailable: int.parse((json["unavailable"] ?? 0).toString()),
        items: List<PickListDetailsItem>.from((json["items"] ?? []).map((x) => PickListDetailsItem.fromJson(x))),
        unavailableReasons: List<UnavailableReason>.from((json["unavailable_reasons"] ?? []).map((x) => UnavailableReason.fromJson(x))),
        completeReasons: List<UnavailableReason>.from((json["complete_reasons"] ?? []).map((x) => UnavailableReason.fromJson(x))),
        alternateItems: List<FilterOptionsResponse>.from((json["alternate_items"] ?? []).map((x) => FilterOptionsResponse.fromJson(x))),
        locationFilter: Filter.fromJson(json["location_filter_options"] ?? {}),
        sessionInfo: SessionInfo.fromJson(json["session_info"] ?? {}),
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
        "handled_by": List<HandledByForUpdateList>.from(handledBy.map((x) => x)),
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

class PickListDetailsItem {
  String id;
  String itemId;
  String picklistNum;
  String status;
  String itemCode;
  String itemName;
  String quantity;
  String pickedQty;
  String uom;
  String itemType;
  String typeColor;
  String floor;
  String room;
  String zone;
  String stagingArea;
  bool isProgressStatus;
  String packageTerms;
  String catchWeightStatus;
  List<CatchWeightItem> catchWeightInfo;
  List<String> catchWeightInfoForList;
  List<CatchWeightItem> catchWeightInfoPicked;
  List<HandledByPickList> handledBy;
  dynamic locationDisputeInfo;
  String unavailableReason;
  String alternativeItemName;
  String alternativeItemCode;
  List<PickListBatchesList> batchesList;
  bool allowUndo;

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
  });

  factory PickListDetailsItem.fromJson(Map<String, dynamic> json) => PickListDetailsItem(
        id: json["id"] ?? "",
        itemId: json["item_id"] ?? "",
        picklistNum: json["picklist_num"] ?? "",
        status: json["status"] ?? json["picklist_item_status"] ?? "",
        itemCode: json["item_code"] ?? "",
        itemName: json["item_name"] ?? "",
        quantity: json["quantity"] ?? json["item_quantity"]??"",
        pickedQty: json["picked_qty"] ?? json["item_picked_qty"]??"",
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
            : getIt<Functions>().getStringToCatchWeight(value: json["catchweight_info"] ?? "25.000,88.222,999.222,1,9999,2,0.5,0.0,25.000,88.222,999.222,1,9999,2,0.5,0.0"),
        catchWeightInfoForList: json["picked_catchweight_info"] == ""
            ? []
            : getIt<Functions>().getStringToList(
                value: json["picked_catchweight_info"] ?? "25.000,88.222,999.222,1,9999,2,0.5,0.0,25.000,88.222,999.222,1,9999,2,0.5,0.0",
                quantity: json["picked_qty"] ?? "",
                weightUnit: json["uom"] ?? ""),
        catchWeightInfoPicked: json["picked_catchweight_info"] == "" ? [] : getIt<Functions>().getStringToCatchWeight(value: json["picked_catchweight_info"] ?? "25.000,1"),
        handledBy: List<HandledByPickList>.from((json["handled_by"] ?? []).map((x) => HandledByPickList.fromJson(x))),
        locationDisputeInfo: json["location_dispute_info"] ?? [],
        unavailableReason: json["unavail_reason"] ?? "",
        alternativeItemName: json["alternative_item_name"] ?? "",
        alternativeItemCode: json["alternative_item_code"] ?? "",
        allowUndo: json["allow_undo"] ?? "",
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
        "catchweight_info": catchWeightInfo,
        "picked_catchweight_info": catchWeightInfoPicked,
        "handled_by": List<dynamic>.from(handledBy.map((x) => x)),
        "location_dispute_info": locationDisputeInfo,
        "unavail_reason": unavailableReason,
        "alternative_item_name": alternativeItemName,
        "alternative_item_code": alternativeItemCode,
        "allow_undo": allowUndo,
        "batches_list": List<HandledByForUpdateList>.from(batchesList.map((x) => x.toJson())),
      };
}

class PickListBatchesList {
  String id;
  String itemId;
  String batchNum;
  String expiryDate;
  String stockType;
  String quantity;
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
        id: json["id"] ?? json["batch_id"]??'',
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

class CatchWeightItem {
  String data;
  bool isSelected;
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

class LocationDisputeInfo {
  String updatedOn;
  String floor;
  String room;
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

class TimelineInfo {
  String id;
  String description;
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

class SessionInfo {
  bool isOpened;
  String id;
  String pending;
  String picked;
  String partial;
  String unavailable;
  String sessionStartTimestamp;
  String timeSpendSeconds;

  SessionInfo({
    required this.isOpened,
    required this.id,
    required this.pending,
    required this.picked,
    required this.partial,
    required this.unavailable,
    required this.sessionStartTimestamp,
    required this.timeSpendSeconds,
  });

  factory SessionInfo.fromJson(Map<String, dynamic> json) => SessionInfo(
    isOpened: json["is_opened"] ?? false,
    id: json["id"] ?? "",
    pending: json["pending"] ?? "0",
    picked: json["picked"] ?? "0",
    partial: json["partial"] ?? "0",
    unavailable: json["unavailable"] ?? "0",
    sessionStartTimestamp: json["session_start_timestamp"] ?? "",
    timeSpendSeconds: json["time_spend_seconds"] ?? "0",
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
  };
}*/
