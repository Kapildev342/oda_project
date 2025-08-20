// Package imports:
import 'package:hive/hive.dart';

part 'trip_list.g.dart';

@HiveType(typeId: 9)
class TripList extends HiveObject {
  @HiveField(0)
  String tripId;

  @HiveField(1)
  String tripNum;

  @HiveField(2)
  String tripVehicle;

  @HiveField(3)
  String tripRoute;

  @HiveField(4)
  String tripStops;

  @HiveField(5)
  String tripCreatedTime;

  @HiveField(6)
  String tripOrders;

  @HiveField(7)
  List<HandledByForUpdateList> tripHandledBy;

  @HiveField(8)
  String tripStatus;

  @HiveField(9)
  String tripStatusColor;

  @HiveField(10)
  String tripStatusBackGroundColor;

  @HiveField(11)
  String tripLoadingBayDry;

  @HiveField(12)
  String tripLoadingBayDryName;

  @HiveField(13)
  String tripLoadingBayFrozen;

  @HiveField(14)
  String tripLoadingBayFrozenName;

  @HiveField(15)
  String tripItemType;

  @HiveField(16)
  List<UnavailableReason> unavailableReasons;

  @HiveField(17)
  SessionInfo sessionInfo;

  @HiveField(18)
  List<ItemsList> partialItemsList;

  @HiveField(19)
  String businessDate;

  @HiveField(20)
  String deliveryArea;

  @HiveField(21)
  bool isSessionOpened;

  @HiveField(22)
  String sessionId;

  @HiveField(23)
  String sessionTimeStamp;

  @HiveField(24)
  String sessionEventType;

  TripList({
    required this.tripId,
    required this.tripNum,
    required this.tripVehicle,
    required this.tripRoute,
    required this.tripStops,
    required this.tripCreatedTime,
    required this.tripOrders,
    required this.tripHandledBy,
    required this.tripStatus,
    required this.tripStatusColor,
    required this.tripStatusBackGroundColor,
    required this.tripLoadingBayDry,
    required this.tripLoadingBayDryName,
    required this.tripLoadingBayFrozen,
    required this.tripLoadingBayFrozenName,
    required this.tripItemType,
    required this.unavailableReasons,
    required this.sessionInfo,
    required this.partialItemsList,
    required this.businessDate,
    required this.deliveryArea,
    required this.isSessionOpened,
    required this.sessionId,
    required this.sessionTimeStamp,
    required this.sessionEventType,
  });

  factory TripList.fromJson(Map<String, dynamic> json) => TripList(
        tripId: json["trip_id"] ?? '',
        tripNum: json["trip_num"] ?? '',
        tripVehicle: json["trip_vehicle"] ?? 'L01234',
        tripRoute: json["trip_route"] ?? '',
        tripStops: json["trip_stops"] ?? '',
        tripCreatedTime: json["trip_created_time"] ?? '26/11/2024, 04:21 PM',
        tripOrders: json["trip_orders"] ?? '',
        tripHandledBy: List<HandledByForUpdateList>.from((json["trip_handled_by"] ?? []).map((x) => HandledByForUpdateList.fromJson(x))),
        tripStatus: json["trip_status"] ?? "",
        tripStatusColor: json["trip_status_color"] ?? "",
        tripStatusBackGroundColor: json["trip_status_bg_color"] ?? "",
        tripLoadingBayDry: json["trip_dry_loading_bay"] ?? "1",
        tripLoadingBayDryName: json["trip_dry_loading_bay_name"] ?? "1",
        tripLoadingBayFrozen: json["trip_frozen_loading_bay"] ?? "A",
        tripLoadingBayFrozenName: json["trip_frozen_loading_bay_name"] ?? "A",
        tripItemType: json["trip_items_type"] ?? "",
        unavailableReasons: List<UnavailableReason>.from((json["unavailable_reasons"] ?? []).map((x) => UnavailableReason.fromJson(x))),
        sessionInfo: SessionInfo.fromJson(json["session_info"] ??
            {
              "is_opened": json["is_session_opened"],
              "id": json["session_id"],
              "session_start_timestamp": json["session_timestamp"],
            }),
        partialItemsList: List<ItemsList>.from((json["partial_items_list"] ?? []).map((x) => ItemsList.fromJson(x))),
        businessDate: json["business_date"] ?? "14/04/2025, 12:00 AM",
        deliveryArea: json["trip_route"] ?? "Texas",
        isSessionOpened: json["is_session_opened"] ?? false,
        sessionId: json["session_id"] ?? "",
        sessionTimeStamp: json["session_timestamp"] ?? "",
        sessionEventType: json["session_event_type"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "trip_id": tripId,
        "trip_num": tripNum,
        "trip_vehicle": tripVehicle,
        "trip_route": tripRoute,
        "trip_stops": tripStops,
        "trip_created_time": tripCreatedTime,
        "trip_orders": tripOrders,
        "trip_handled_by": List<dynamic>.from(tripHandledBy.map((x) => x.toJson())),
        "trip_status": tripStatus,
        "trip_status_color": tripStatusColor,
        "trip_status_bg_color": tripStatusBackGroundColor,
        "trip_dry_loading_bay": tripLoadingBayDry,
        "trip_dry_loading_bay_name": tripLoadingBayDryName,
        "trip_frozen_loading_bay": tripLoadingBayFrozen,
        "trip_frozen_loading_bay_name": tripLoadingBayFrozenName,
        "trip_items_type": tripItemType,
        "unavailable_reasons": unavailableReasons,
        "session_info": sessionInfo.toJson(),
        "partial_items_list": partialItemsList,
        "delivery_area": deliveryArea,
        "business_dt": businessDate,
        "is_session_opened": isSessionOpened,
        "session_id": sessionId,
        "session_timestamp": sessionTimeStamp,
        "session_event_type": sessionEventType,
      };
}

@HiveType(typeId: 10)
class SoList extends HiveObject {
  @HiveField(0)
  String soId;

  @HiveField(1)
  String soNum;

  @HiveField(2)
  String soCustomerName;

  @HiveField(3)
  String soCustomerCode;

  @HiveField(4)
  String soDeliveryInstruction;

  @HiveField(5)
  String soStatus;

  @HiveField(6)
  String soNoOfItems;

  @HiveField(7)
  String soType;

  @HiveField(8)
  String soStops;

  @HiveField(9)
  bool disputeStatus;

  @HiveField(10)
  List<HandledByForUpdateList> soHandledBy;

  @HiveField(11)
  String tripId;

  @HiveField(12)
  String soItemType;

  @HiveField(13)
  bool isSelected;

  @HiveField(14)
  String soNoOfSortedItems;

  @HiveField(15)
  String soNoOfLoadedItems;

  @HiveField(16)
  SessionInfo sessionInfo;

  @HiveField(17)
  String soCreatedTime;

  @HiveField(18)
  bool doDelivery;

  /*@HiveField(19)
  List<InvoiceData> invoiceDataList;*/

  @HiveField(19)
  String tripLoadingBayDryName;

  @HiveField(20)
  String tripLoadingBayFrozenName;

  @HiveField(21)
  String stopId;

  SoList(
      {required this.soId,
      required this.soNum,
      required this.soCustomerName,
      required this.soCustomerCode,
      required this.soDeliveryInstruction,
      required this.soStatus,
      required this.soNoOfItems,
      required this.soType,
      required this.soStops,
      required this.disputeStatus,
      required this.soHandledBy,
      required this.soItemType,
      required this.tripId,
      required this.isSelected,
      required this.soNoOfSortedItems,
      required this.soNoOfLoadedItems,
      required this.sessionInfo,
      required this.soCreatedTime,
      required this.doDelivery,
      // required this.invoiceDataList,
      required this.tripLoadingBayDryName,
      required this.tripLoadingBayFrozenName,
      required this.stopId});

  factory SoList.fromJson(Map<String, dynamic> json) => SoList(
        soId: json["so_id"] ?? '',
        soNum: json["so_num"] ?? '',
        soCustomerName: json["so_customer_name"] ?? '',
        soCustomerCode: json["so_customer_code"] ?? '',
        soDeliveryInstruction: json["so_delivery_instruction"] ?? '',
        soStatus: json["so_status"] ?? '',
        soNoOfItems: json["so_total_items"] ?? '',
        soType: json["so_type"] ?? '',
        soStops: json["so_stop_num"] == null ? "" : json["so_stop_num"].toString(),
        soItemType: json["so_items_type"] ?? '',
        disputeStatus: json["dispute_status"].toString() == "true",
        soHandledBy: List<HandledByForUpdateList>.from((json["so_handledBy"] ?? []).map((x) => HandledByForUpdateList.fromJson(x))),
        tripId: json["trip_id"] ?? '',
        isSelected: json["is_selected"] ?? false,
        soNoOfSortedItems: json["so_sorted_items"] ?? "0",
        soNoOfLoadedItems: json["so_loaded_items"] ?? "0",
        sessionInfo: SessionInfo.fromJson(json["session_info"] ?? {}),
        soCreatedTime: json["trip_created_time"] ?? "26/11/2024, 04:21 PM",
        doDelivery: json["do_delivery"] ?? false,
        //invoiceDataList: List<InvoiceData>.from((json["invoice_data_list"] ?? []).map((x) => InvoiceData.fromJson(x))),
        tripLoadingBayDryName: json["trip_dry_loading_bay_name"] ?? "1",
        tripLoadingBayFrozenName: json["trip_frozen_loading_bay_name"] ?? "A",
        stopId: json["stop_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "so_id": soId,
        "so_num": soNum,
        "so_customer_name": soCustomerName,
        "so_customer_code": soCustomerCode,
        "so_delivery_instruction": soDeliveryInstruction,
        "so_status": soStatus,
        "so_total_items": soNoOfItems,
        "so_type": soType,
        "so_stop_num": soStops,
        "so_items_type": soItemType,
        "dispute_status": disputeStatus,
        "so_handledBy": List<dynamic>.from(soHandledBy.map((x) => x.toJson())),
        "trip_id": tripId,
        "is_selected": isSelected,
        "so_sorted_items": soNoOfSortedItems,
        "so_loaded_items": soNoOfLoadedItems,
        "session_info": sessionInfo.toJson(),
        "created_time": soCreatedTime,
        "do_delivery": doDelivery,
        //"invoice_data_list": List<dynamic>.from(invoiceDataList.map((x) => x.toJson())),
        "trip_dry_loading_bay_name": tripLoadingBayDryName,
        "trip_frozen_loading_bay_name": tripLoadingBayFrozenName,
        "stop_id": stopId,
      };
}

@HiveType(typeId: 11)
class ItemsList extends HiveObject {
  @HiveField(0)
  String lineItemId;

  @HiveField(1)
  String itemId;

  @HiveField(2)
  String itemTrippedStatus;

  @HiveField(3)
  String itemCode;

  @HiveField(4)
  String itemName;

  @HiveField(5)
  String quantity;

  @HiveField(6)
  String lineSortedQty;

  @HiveField(7)
  String uom;

  @HiveField(8)
  String itemType;

  @HiveField(9)
  String typeColor;

  @HiveField(10)
  String stagingArea;

  @HiveField(11)
  String packageTerms;

  @HiveField(12)
  String catchWeightStatus;

  @HiveField(13)
  String catchWeightInfo;

  @HiveField(14)
  String itemSortedCatchWeightInfo;

  @HiveField(15)
  List<HandledByForUpdateList> handledBy;

  @HiveField(16)
  String itemTrippedUnavailableReasonId;

  @HiveField(17)
  String itemTrippedUnavailableReason;

  @HiveField(18)
  String itemTrippedUnavailableRemarks;

  @HiveField(19)
  String remarks;

  @HiveField(20)
  String tripId;

  @HiveField(21)
  String soId;

  @HiveField(22)
  bool isProgressStatus;

  @HiveField(23)
  List<BatchesList> itemBatchesList;

  @HiveField(24)
  String lineLoadedQty;

  @HiveField(25)
  String itemLoadedUnavailableReasonId;

  @HiveField(26)
  String itemLoadedUnavailableReason;

  @HiveField(27)
  String itemLoadedUnavailableRemarks;

  @HiveField(28)
  String itemLoadedStatus;

  @HiveField(29)
  String itemLoadedCatchWeightInfo;

  @HiveField(30)
  String itemPickedStatus;

  @HiveField(31)
  bool isCompleted;

  @HiveField(32)
  String invoiceId;

  ItemsList({
    required this.lineItemId,
    required this.itemId,
    required this.itemTrippedStatus,
    required this.itemCode,
    required this.itemName,
    required this.quantity,
    required this.lineSortedQty,
    required this.uom,
    required this.itemType,
    required this.typeColor,
    required this.stagingArea,
    required this.packageTerms,
    required this.catchWeightStatus,
    required this.catchWeightInfo,
    required this.itemSortedCatchWeightInfo,
    required this.handledBy,
    required this.itemTrippedUnavailableReasonId,
    required this.itemTrippedUnavailableReason,
    required this.itemTrippedUnavailableRemarks,
    required this.remarks,
    required this.tripId,
    required this.soId,
    required this.isProgressStatus,
    required this.itemBatchesList,
    required this.lineLoadedQty,
    required this.itemLoadedUnavailableReasonId,
    required this.itemLoadedUnavailableReason,
    required this.itemLoadedUnavailableRemarks,
    required this.itemLoadedStatus,
    required this.itemLoadedCatchWeightInfo,
    required this.itemPickedStatus,
    required this.isCompleted,
    required this.invoiceId,
  });

  factory ItemsList.fromJson(Map<String, dynamic> json) => ItemsList(
        lineItemId: json["line_item_id"] ?? '',
        itemId: json["item_id"] ?? '',
        itemTrippedStatus: /*"sorted",*/ json["item_sorting_status"] ?? '',
        itemCode: json["item_code"] ?? '',
        itemName: json["item_name"] ?? '',
        quantity: json["li_quantity"] ?? '',
        uom: json["uom"] ?? '',
        itemType: json["item_type"] ?? '',
        typeColor: json["item_color"] ?? '',
        stagingArea: json["staging_area"] ?? '',
        packageTerms: json["package_terms"] ?? '',
        catchWeightStatus: json["catchweight_status"] ?? '',
        catchWeightInfo: json["catchweight_info"] ?? '',
        itemSortedCatchWeightInfo: json["sorted_catchweight_info"] ?? '',
        handledBy: List<HandledByForUpdateList>.from((json["handled_by"] ?? []).map((x) => HandledByForUpdateList.fromJson(x))),
        lineSortedQty: json["li_sorted_qty"] ?? '0',
        itemTrippedUnavailableReasonId: json["li_sorting_unavail_reason"] ?? '',
        itemTrippedUnavailableReason: json["li_sorting_unavail_reason_description"] ?? '',
        itemTrippedUnavailableRemarks: json["li_sorting_unavail_remarks"] ?? '',
        remarks: json["li_remarks"] ?? '',
        tripId: json["trip_id"] ?? '',
        soId: json["so_id"] ?? '',
        isProgressStatus: json["li_progress_status"].toString() == "true",
        itemBatchesList: List<BatchesList>.from((json["batches_list"] ?? []).map((x) => BatchesList.fromJson(x))),
        lineLoadedQty: json["li_loaded_qty"] ?? '0',
        itemLoadedUnavailableReasonId: json["li_loading_unavail_reason"] ?? '',
        itemLoadedUnavailableReason: json["li_loading_unavail_reason_description"] ?? '',
        itemLoadedUnavailableRemarks: json["li_loading_unavail_remarks"] ?? '',
        itemLoadedStatus: json["item_loading_status"] ?? '',
        itemLoadedCatchWeightInfo: json["loaded_catchweight_info"] ?? '',
        itemPickedStatus: json["item_picking_status"] ?? '',
        isCompleted: json["is_completed"] ?? false,
        invoiceId: json["invoice_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "line_item_id": lineItemId,
        "item_id": itemId,
        "item_sorting_status": itemTrippedStatus,
        "item_code": itemCode,
        "item_name": itemName,
        "li_quantity": quantity,
        "li_sorted_qty": lineSortedQty,
        "uom": uom,
        "item_type": itemType,
        "item_color": typeColor,
        "staging_area": stagingArea,
        "package_terms": packageTerms,
        "catchweight_status": catchWeightStatus,
        "catchweight_info": catchWeightInfo,
        "sorted_catchweight_info": itemSortedCatchWeightInfo,
        "handled_by": List<dynamic>.from(handledBy.map((x) => x.toJson())),
        "li_sorting_unavail_reason": itemTrippedUnavailableReasonId,
        "li_sorting_unavail_reason_description": itemTrippedUnavailableReason,
        "li_sorting_unavail_remarks": itemTrippedUnavailableRemarks,
        "li_remarks": remarks,
        "trip_id": tripId,
        "so_id": soId,
        "li_progress_status": isProgressStatus,
        "li_loaded_qty": lineLoadedQty,
        "li_loading_unavail_reason": itemLoadedUnavailableReasonId,
        "li_loading_unavail_reason_description": itemLoadedUnavailableReason,
        "li_loading_unavail_remarks": itemLoadedUnavailableRemarks,
        "item_loading_status": itemLoadedStatus,
        "loaded_catchweight_info": itemLoadedCatchWeightInfo,
        "item_picking_status": itemPickedStatus,
        "is_completed": isCompleted,
        "invoice_id": isCompleted,
        "batches_list": List<dynamic>.from(itemBatchesList.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 12)
class BatchesList extends HiveObject {
  @HiveField(0)
  String batchId;

  @HiveField(1)
  String batchNum;

  @HiveField(2)
  String stockType;

  @HiveField(3)
  String quantity;

  @HiveField(4)
  String batchSortedQty;

  @HiveField(5)
  String expiryDate;

  @HiveField(6)
  String tripId;

  @HiveField(7)
  String soId;

  @HiveField(8)
  String itemId;

  @HiveField(9)
  String batchLoadedQty;

  BatchesList({
    required this.batchId,
    required this.batchNum,
    required this.stockType,
    required this.quantity,
    required this.batchSortedQty,
    required this.expiryDate,
    required this.tripId,
    required this.soId,
    required this.itemId,
    required this.batchLoadedQty,
  });

  factory BatchesList.fromJson(Map<String, dynamic> json) => BatchesList(
        batchId: json["batch_id"] ?? "",
        batchNum: json["batch_num"] ?? "",
        stockType: json["stock_type"] ?? "",
        quantity: json["quantity"] ?? "0",
        batchSortedQty: json["sorted_qty"] ?? "0",
        expiryDate: json["expiry_date"] ?? "",
        tripId: json["trip_id"] ?? '',
        soId: json["so_id"] ?? '',
        itemId: json["line_item_id"] ?? '',
        batchLoadedQty: json["loaded_qty"] ?? '0',
      );

  Map<String, dynamic> toJson() => {
        "batch_id": batchId,
        "batch_num": batchNum,
        "stock_type": stockType,
        "quantity": quantity,
        "sorted_qty": batchSortedQty,
        "expiry_date": expiryDate,
        "trip_id": tripId,
        "so_id": soId,
        "line_item_id": itemId,
        "loaded_qty": batchLoadedQty,
      };
}

@HiveType(typeId: 13)
class HandledByForUpdateList extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String code;

  @HiveField(2)
  String name;

  @HiveField(3)
  String image;

  @HiveField(4)
  String updatedItems;

  HandledByForUpdateList({
    required this.id,
    required this.code,
    required this.name,
    required this.image,
    required this.updatedItems,
  });

  factory HandledByForUpdateList.fromJson(Map<String, dynamic> json) => HandledByForUpdateList(
        id: json["id"] ?? "",
        code: json["code"] ?? "",
        name: json["name"] ?? json["label"] ?? "",
        image: json["image"] ?? "",
        updatedItems: (json["updated_items"] ?? 0).toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "image": image,
        "sorted_items": updatedItems,
      };
}

@HiveType(typeId: 14)
class SessionInfo extends HiveObject {
  @HiveField(0)
  bool isOpened;

  @HiveField(1)
  String id;

  @HiveField(2)
  String pending;

  @HiveField(3)
  String updated;

  @HiveField(4)
  String partial;

  @HiveField(5)
  String unavailable;

  @HiveField(6)
  String sessionStartTimestamp;

  @HiveField(7)
  String timeSpendSeconds;

  SessionInfo({
    required this.isOpened,
    required this.id,
    required this.pending,
    required this.updated,
    required this.partial,
    required this.unavailable,
    required this.sessionStartTimestamp,
    required this.timeSpendSeconds,
  });

  factory SessionInfo.fromJson(Map<String, dynamic> json) => SessionInfo(
        isOpened: json["is_opened"] ?? false,
        id: json["id"] ?? "",
        pending: json["pending"] ?? "0",
        updated: json["updated"] ?? "0",
        partial: json["partial"] ?? "0",
        unavailable: json["unavailable"] ?? "0",
        sessionStartTimestamp: json["session_start_timestamp"] ?? "",
        timeSpendSeconds: json["time_spend_seconds"] ?? "0",
      );

  Map<String, dynamic> toJson() => {
        "is_opened": isOpened,
        "id": id,
        "pending": pending,
        "updated": updated,
        "partial": partial,
        "unavailable": unavailable,
        "session_start_timestamp": sessionStartTimestamp,
        "time_spend_seconds": timeSpendSeconds,
      };
}

@HiveType(typeId: 15)
class UnavailableReason extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String code;

  @HiveField(2)
  String description;

  UnavailableReason({
    required this.id,
    required this.code,
    required this.description,
  });

  factory UnavailableReason.fromJson(Map<String, dynamic> json) => UnavailableReason(
        id: json["id"] ?? '',
        code: json["code"] ?? '',
        description: json["description"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
      };
}

@HiveType(typeId: 16)
class PartialItemsList extends HiveObject {
  @HiveField(0)
  String lineItemId;

  @HiveField(1)
  String itemId;

  @HiveField(2)
  String itemTrippedStatus;

  @HiveField(3)
  String itemCode;

  @HiveField(4)
  String itemName;

  @HiveField(5)
  String quantity;

  @HiveField(6)
  String lineSortedQty;

  @HiveField(7)
  String uom;

  @HiveField(8)
  String itemType;

  @HiveField(9)
  String typeColor;

  @HiveField(10)
  String stagingArea;

  @HiveField(11)
  String packageTerms;

  @HiveField(12)
  String catchWeightStatus;

  @HiveField(13)
  String catchWeightInfo;

  @HiveField(14)
  String itemSortedCatchWeightInfo;

  @HiveField(15)
  List<HandledByForUpdateList> handledBy;

  @HiveField(16)
  String itemTrippedUnavailableReasonId;

  @HiveField(17)
  String itemTrippedUnavailableReason;

  @HiveField(18)
  String itemTrippedUnavailableRemarks;

  @HiveField(19)
  String remarks;

  @HiveField(20)
  String tripId;

  @HiveField(21)
  String soId;

  @HiveField(22)
  bool isProgressStatus;

  @HiveField(23)
  List<BatchesList> itemBatchesList;

  @HiveField(24)
  String lineLoadedQty;

  @HiveField(25)
  String itemLoadedUnavailableReasonId;

  @HiveField(26)
  String itemLoadedUnavailableReason;

  @HiveField(27)
  String itemLoadedUnavailableRemarks;

  @HiveField(28)
  String itemLoadedStatus;

  @HiveField(29)
  String itemLoadedCatchWeightInfo;

  @HiveField(30)
  String itemPickedStatus;

  PartialItemsList({
    required this.lineItemId,
    required this.itemId,
    required this.itemTrippedStatus,
    required this.itemCode,
    required this.itemName,
    required this.quantity,
    required this.lineSortedQty,
    required this.uom,
    required this.itemType,
    required this.typeColor,
    required this.stagingArea,
    required this.packageTerms,
    required this.catchWeightStatus,
    required this.catchWeightInfo,
    required this.itemSortedCatchWeightInfo,
    required this.handledBy,
    required this.itemTrippedUnavailableReasonId,
    required this.itemTrippedUnavailableReason,
    required this.itemTrippedUnavailableRemarks,
    required this.remarks,
    required this.tripId,
    required this.soId,
    required this.isProgressStatus,
    required this.itemBatchesList,
    required this.lineLoadedQty,
    required this.itemLoadedUnavailableReasonId,
    required this.itemLoadedUnavailableReason,
    required this.itemLoadedUnavailableRemarks,
    required this.itemLoadedStatus,
    required this.itemLoadedCatchWeightInfo,
    required this.itemPickedStatus,
  });

  factory PartialItemsList.fromJson(Map<String, dynamic> json) => PartialItemsList(
        lineItemId: json["line_item_id"] ?? '',
        itemId: json["item_id"] ?? '',
        itemTrippedStatus: /*"sorted",*/ json["item_sorting_status"] ?? '',
        itemCode: json["item_code"] ?? '',
        itemName: json["item_name"] ?? '',
        quantity: json["li_quantity"] ?? '',
        uom: json["uom"] ?? '',
        itemType: json["item_type"] ?? '',
        typeColor: json["item_color"] ?? '',
        stagingArea: json["staging_area"] ?? '',
        packageTerms: json["package_terms"] ?? '',
        catchWeightStatus: /*"Yes",*/ json["catchweight_status"] ?? '',
        catchWeightInfo: /*"25.000,88.222,999.222",*/ json["catchweight_info"] ?? '',
        itemSortedCatchWeightInfo: /*"25.000,88.222,999.222",*/ json["sorted_catchweight_info"] ?? '',
        handledBy: List<HandledByForUpdateList>.from((json["handled_by"] ?? []).map((x) => HandledByForUpdateList.fromJson(x))),
        lineSortedQty: json["li_sorted_qty"] ?? '0',
        itemTrippedUnavailableReasonId: json["li_sorting_unavail_reason"] ?? '',
        itemTrippedUnavailableReason: json["li_sorting_unavail_reason_description"] ?? '',
        itemTrippedUnavailableRemarks: json["li_sorting_unavail_remarks"] ?? '',
        remarks: json["li_remarks"] ?? '',
        tripId: json["trip_id"] ?? '',
        soId: json["so_id"] ?? '',
        isProgressStatus: json["li_progress_status"] ?? false,
        itemBatchesList: List<BatchesList>.from((json["batches_list"] ?? []).map((x) => BatchesList.fromJson(x))),
        lineLoadedQty: json["li_loaded_qty"] ?? '0',
        itemLoadedUnavailableReasonId: json["li_loading_unavail_reason"] ?? '',
        itemLoadedUnavailableReason: json["li_loading_unavail_reason_description"] ?? '',
        itemLoadedUnavailableRemarks: json["li_loading_unavail_remarks"] ?? '',
        itemLoadedStatus: json["item_loading_status"] ?? '',
        itemLoadedCatchWeightInfo: json["loaded_catchweight_info"] ?? '',
        itemPickedStatus: json["item_picking_status"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "line_item_id": lineItemId,
        "item_id": itemId,
        "item_sorting_status": itemTrippedStatus,
        "item_code": itemCode,
        "item_name": itemName,
        "li_quantity": quantity,
        "li_sorted_qty": lineSortedQty,
        "uom": uom,
        "item_type": itemType,
        "item_color": typeColor,
        "staging_area": stagingArea,
        "package_terms": packageTerms,
        "catchweight_status": catchWeightStatus,
        "catchweight_info": catchWeightInfo,
        "sorted_catchweight_info": itemSortedCatchWeightInfo,
        "handled_by": List<dynamic>.from(handledBy.map((x) => x.toJson())),
        "li_sorting_unavail_reason": itemTrippedUnavailableReasonId,
        "li_sorting_unavail_reason_description": itemTrippedUnavailableReason,
        "li_sorting_unavail_remarks": itemTrippedUnavailableRemarks,
        "li_remarks": remarks,
        "trip_id": tripId,
        "so_id": soId,
        "li_progress_status": isProgressStatus,
        "li_loaded_qty": lineLoadedQty,
        "li_loading_unavail_reason": itemLoadedUnavailableReasonId,
        "li_loading_unavail_reason_description": itemLoadedUnavailableReason,
        "li_loading_unavail_remarks": itemLoadedUnavailableRemarks,
        "item_loading_status": itemLoadedStatus,
        "loaded_catchweight_info": itemLoadedCatchWeightInfo,
        "item_picking_status": itemPickedStatus,
        "batches_list": List<dynamic>.from(itemBatchesList.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 17)
class LocalTempDataList extends HiveObject {
  @HiveField(0)
  String queryData;

  LocalTempDataList({required this.queryData});

  factory LocalTempDataList.fromJson(Map<String, dynamic> json) => LocalTempDataList(
        queryData: json["query_data"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "query_data": queryData,
      };
}
