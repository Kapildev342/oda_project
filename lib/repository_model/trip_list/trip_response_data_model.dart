// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:oda/local_database/trip_box/trip_list.dart';

TripResponseDataModel tripResponseDataModelFromJson(String str) => TripResponseDataModel.fromJson(json.decode(str));

String tripResponseDataModelToJson(TripResponseDataModel data) => json.encode(data.toJson());

class TripResponseDataModel {
  String status;
  TripListResponse response;

  TripResponseDataModel({
    required this.status,
    required this.response,
  });

  factory TripResponseDataModel.fromJson(Map<String, dynamic> json) => TripResponseDataModel(
    status: json["status"]??"",
    response: TripListResponse.fromJson(json["response"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": response.toJson(),
  };
}

class TripListResponse {
  List<TripResponse> tripList;

  TripListResponse({
    required this.tripList,
  });

  factory TripListResponse.fromJson(Map<String, dynamic> json) => TripListResponse(
    tripList: List<TripResponse>.from((json["triplist"]??[]).map((x) => TripResponse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "triplist": List<dynamic>.from(tripList.map((x) => x.toJson())),
  };
}

class TripResponse {
  String tripId;
  String tripNum;
  String tripVehicle;
  String tripRoute;
  String tripStops;
  String tripCreatedTime;
  String tripOrders;
  String tripStatus;
  String tripStatusColor;
  String tripStatusBgColor;
  String tripDryLoadingBay;
  String tripFrozenLoadingBay;
  String soId;
  String soNum;
  String soCustomerName;
  String soCustomerCode;
  String soDeliveryInstruction;
  String soStatus;
  String soTotalItems;
  String soType;
  String lineItemId;
  String liRemarks;
  String liQuantity;
  bool liProgressStatus;
  String itemId;
  String itemCode;
  String itemName;
  String itemType;
  String itemColor;
  String packageTerms;
  String uom;
  String itemSortingStatus;
  String itemLoadingStatus;
  String stagingArea;
  String loadingBay;
  String catchweightStatus;
  String catchweightInfo;
  String sortedCatchweightInfo;
  String loadedCatchweightInfo;
  String batchId;
  String batchNum;
  String quantity;
  String sortedQty;
  String loadedQty;
  String expiryDate;
  String stockType;
  bool inProgress;
  List<HandledByForUpdateList> handledBy;
  bool disputeStatus;

  TripResponse({
    required this.tripId,
    required this.tripNum,
    required this.tripVehicle,
    required this.tripRoute,
    required this.tripStops,
    required this.tripCreatedTime,
    required this.tripOrders,
    required this.tripStatus,
    required this.tripStatusColor,
    required this.tripStatusBgColor,
    required this.tripDryLoadingBay,
    required this.tripFrozenLoadingBay,
    required this.soId,
    required this.soNum,
    required this.soCustomerName,
    required this.soCustomerCode,
    required this.soDeliveryInstruction,
    required this.soStatus,
    required this.soTotalItems,
    required this.soType,
    required this.lineItemId,
    required this.liRemarks,
    required this.liQuantity,
    required this.liProgressStatus,
    required this.itemId,
    required this.itemCode,
    required this.itemName,
    required this.itemType,
    required this.itemColor,
    required this.packageTerms,
    required this.uom,
    required this.itemSortingStatus,
    required this.itemLoadingStatus,
    required this.stagingArea,
    required this.loadingBay,
    required this.catchweightStatus,
    required this.catchweightInfo,
    required this.sortedCatchweightInfo,
    required this.loadedCatchweightInfo,
    required this.batchId,
    required this.batchNum,
    required this.quantity,
    required this.sortedQty,
    required this.loadedQty,
    required this.expiryDate,
    required this.stockType,
    required this.inProgress,
    required this.handledBy,
    required this.disputeStatus,
  });

  factory TripResponse.fromJson(Map<String, dynamic> json) => TripResponse(
    tripId: json["trip_id"]??"",
    tripNum: json["trip_num"]??"",
    tripVehicle: json["trip_vehicle"]??"",
    tripRoute: json["trip_route"]??"",
    tripStops: json["trip_stops"]??"",
    tripCreatedTime: json["trip_created_time"]??"",
    tripOrders: json["trip_orders"]??"",
    tripStatus: json["trip_status"]??"",
    tripStatusColor: json["trip_status_color"]??"",
    tripStatusBgColor: json["trip_status_bg_color"]??"",
    tripDryLoadingBay: json["trip_dry_loading_bay"]??"",
    tripFrozenLoadingBay: json["trip_frozen_loading_bay"]??"",
    soId: json["so_id"]??"",
    soNum: json["so_num"]??"",
    soCustomerName: json["so_customer_name"]??"",
    soCustomerCode: json["so_customer_code"]??"",
    soDeliveryInstruction: json["so_delivery_instruction"]??"",
    soStatus: json["so_status"]??"",
    soTotalItems: json["so_total_items"]??"",
    soType: json["so_type"]??"",
    lineItemId: json["line_item_id"]??"",
    liRemarks: json["li_remarks"]??"",
    liQuantity: json["li_quantity"]??"",
    liProgressStatus: json["li_progress_status"]??false,
    itemId: json["item_id"]??"",
    itemCode: json["item_code"]??"",
    itemName: json["item_name"]??"",
    itemType: json["item_type"]??"",
    itemColor: json["item_color"]??"",
    packageTerms: json["package_terms"]??"",
    uom: json["uom"]??"",
    itemSortingStatus: json["item_sorting_status"]??"",
    itemLoadingStatus: json["item_loading_status"]??"",
    stagingArea: json["staging_area"]??"",
    loadingBay: json["loading_bay"]??"",
    catchweightStatus: json["catchweight_status"]??"",
    catchweightInfo: json["catchweight_info"]??"",
    sortedCatchweightInfo: json["sorted_catchweight_info"]??"",
    loadedCatchweightInfo: json["loaded_catchweight_info"]??"",
    batchId: json["batch_id"]??"",
    batchNum: json["batch_num"]??"",
    quantity: json["quantity"]??"",
    sortedQty: json["sorted_qty"]??"",
    loadedQty: json["loaded_qty"]??"",
    expiryDate: json["expiry_date"]??"",
    stockType: json["stock_type"]??"",
    inProgress: json["in_progress"]??false,
    handledBy: List<HandledByForUpdateList>.from((json["handled_by"]??[]).map((x) => x)),
    disputeStatus: json["dispute_status"]??false,
  );

  Map<String, dynamic> toJson() => {
    "trip_id": tripId,
    "trip_num": tripNum,
    "trip_vehicle": tripVehicle,
    "trip_route": tripRoute,
    "trip_stops": tripStops,
    "trip_created_time": tripCreatedTime,
    "trip_orders": tripOrders,
    "trip_status": tripStatus,
    "trip_status_color": tripStatusColor,
    "trip_status_bg_color": tripStatusBgColor,
    "trip_dry_loading_bay": tripDryLoadingBay,
    "trip_frozen_loading_bay": tripFrozenLoadingBay,
    "so_id": soId,
    "so_num": soNum,
    "so_customer_name": soCustomerName,
    "so_customer_code": soCustomerCode,
    "so_delivery_instruction": soDeliveryInstruction,
    "so_status": soStatus,
    "so_total_items": soTotalItems,
    "so_type": soType,
    "line_item_id": lineItemId,
    "li_remarks": liRemarks,
    "li_quantity": liQuantity,
    "li_progress_status": liProgressStatus,
    "item_id": itemId,
    "item_code": itemCode,
    "item_name": itemName,
    "item_type": itemType,
    "item_color": itemColor,
    "package_terms": packageTerms,
    "uom": uom,
    "item_sorting_status": itemSortingStatus,
    "item_loading_status": itemLoadingStatus,
    "staging_area": stagingArea,
    "loading_bay": loadingBay,
    "catchweight_status": catchweightStatus,
    "catchweight_info": catchweightInfo,
    "sorted_catchweight_info": sortedCatchweightInfo,
    "loaded_catchweight_info": loadedCatchweightInfo,
    "batch_id": batchId,
    "batch_num": batchNum,
    "quantity": quantity,
    "sorted_qty": sortedQty,
    "loaded_qty": loadedQty,
    "expiry_date": expiryDate,
    "stock_type": stockType,
    "in_progress": inProgress,
    "handled_by": List<dynamic>.from(handledBy.map((x) => x)),
    "dispute_status": disputeStatus,
  };
}
