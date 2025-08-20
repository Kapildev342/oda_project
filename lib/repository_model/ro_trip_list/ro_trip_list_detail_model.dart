
import 'dart:convert';

RoTripDetailModel roTripDetailModelFromJson(String str) => RoTripDetailModel.fromJson(json.decode(str));

String roTripDetailModelToJson(RoTripDetailModel data) => json.encode(data.toJson());

class RoTripDetailModel {
  final String status;
  final Response response;

  RoTripDetailModel({
    required this.status,
    required this.response,
  });

  factory RoTripDetailModel.fromJson(Map<String, dynamic> json) => RoTripDetailModel(
        status: json["status"] ?? "",
        response: Response.fromJson(json["response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class Response {
  final TripInfo tripInfo;
  final List<Stop> stops;
  final List<OtherItem> otherItems;
  final bool assetsReturned;
  final List<AssetChecklist> assetChecklist;

  Response({
    required this.tripInfo,
    required this.stops,
    required this.otherItems,
    required this.assetsReturned,
    required this.assetChecklist,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        tripInfo: TripInfo.fromJson(json["trip_info"] ?? {}),
        stops: List<Stop>.from((json["stops"] ?? []).map((x) => Stop.fromJson(x))),
        otherItems: List<OtherItem>.from((json["other_items"] ?? []).map((x) => OtherItem.fromJson(x))),
        assetsReturned: json["assets_returned"] ?? false,
        assetChecklist: List<AssetChecklist>.from((json["asset_checklist"] ?? []).map((x) => AssetChecklist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "trip_info": tripInfo.toJson(),
        "stops": List<dynamic>.from(stops.map((x) => x.toJson())),
        "other_items": List<dynamic>.from(otherItems.map((x) => x.toJson())),
        "assets_returned": assetsReturned,
        "asset_checklist": List<dynamic>.from(assetChecklist.map((x) => x.toJson())),
      };
}

class AssetChecklist {
  final String label;
  final String id;
  final bool req;
  final bool isSelected;
  final bool isReturned;

  AssetChecklist({
    required this.label,
    required this.id,
    required this.req,
    required this.isSelected,
    required this.isReturned,
  });

  factory AssetChecklist.fromJson(Map<String, dynamic> json) => AssetChecklist(
        label: json["label"] ?? '',
        id: json["id"] ?? '',
        req: json["req"] ?? false,
        isSelected: json["is_selected"] ?? false,
        isReturned: json["is_returned"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "id": id,
        "req": req,
        "is_selected": isSelected,
        "is_returned": isReturned,
      };
}

class OtherItem {
  final String id;
  final String itemName;
  final String itemCode;
  final int quantity;

  OtherItem({
    required this.id,
    required this.itemName,
    required this.itemCode,
    required this.quantity,
  });

  factory OtherItem.fromJson(Map<String, dynamic> json) => OtherItem(
        id: json["id"] ?? "",
        itemName: json["item_name"] ?? "",
        itemCode: json["item_code"] ?? "",
        quantity: json["quantity"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "item_name": itemName,
        "item_code": itemCode,
        "quantity": quantity,
      };
}

class Stop {
  final String stopId;
  final String stopNum;
  final String stopStatus;
  final String type;
  final String deliveryLocation;
  final String deliveryLat;
  final String deliveryLon;
  final String totalCount;
  final String deliveryCount;
  final String takeBackCount;
  final String deliveredCount;
  final String undeliveredCount;
  final String collectedCount;
  final int totalQty;
  final int totalReturnQty;
  final String customerName;
  final String customerPhone;
  final String salesRepName;
  final String salesRepPhone;
  final String stopInvoiceTotal;
  final String stopCollectedTotal;
  final String stopReceivedTotal;
  final bool receivedAmountStatus;
  final List<Invoice> invoices;

  Stop({
    required this.stopId,
    required this.stopNum,
    required this.stopStatus,
    required this.type,
    required this.deliveryLocation,
    required this.deliveryLat,
    required this.deliveryLon,
    required this.totalCount,
    required this.deliveryCount,
    required this.takeBackCount,
    required this.deliveredCount,
    required this.undeliveredCount,
    required this.collectedCount,
    required this.totalQty,
    required this.totalReturnQty,
    required this.customerName,
    required this.customerPhone,
    required this.salesRepName,
    required this.salesRepPhone,
    required this.stopInvoiceTotal,
    required this.stopCollectedTotal,
    required this.stopReceivedTotal,
    required this.receivedAmountStatus,
    required this.invoices,
  });

  factory Stop.fromJson(Map<String, dynamic> json) => Stop(
        stopId: json["stop_id"] ?? "",
        stopNum: json["stop_num"] ?? "",
        stopStatus: json["stop_status"] ?? "",
        type: json["type"] ?? "",
        deliveryLocation: json["delivery_location"] ?? "",
        deliveryLat: json["delivery_lat"] ?? "",
        deliveryLon: json["delivery_lon"] ?? "",
        totalCount: json["total_count"] ?? "",
        deliveryCount: json["delivery_count"] ?? "",
        takeBackCount: json["takeback_count"] ?? "",
        deliveredCount: json["delivered_count"] ?? "",
        undeliveredCount: json["undelivered_count"] ?? "",
        collectedCount: json["collected_count"] ?? "",
        totalQty: json["total_qty"] ?? 0,
        totalReturnQty: json["total_return_qty"] ?? 0,
        customerName: json["customer_name"] ?? "",
        customerPhone: json["customer_phone"] ?? "",
        salesRepName: json["sales_rep_name"] ?? "",
        salesRepPhone: json["sales_rep_phone"] ?? "",
        stopInvoiceTotal: json["stop_invoice_total"] ?? "",
        stopCollectedTotal: json["stop_collected_total"] ?? "",
        stopReceivedTotal: json["stop_received_total"] ?? "",
        receivedAmountStatus: json["received_amount_status"]?? false,
        invoices: List<Invoice>.from((json["invoices"] ?? []).map((x) => Invoice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "stop_id": stopId,
        "stop_num": stopNum,
        "stop_status": stopStatus,
        "type": type,
        "delivery_location": deliveryLocation,
        "delivery_lat": deliveryLat,
        "delivery_lon": deliveryLon,
        "total_count": totalCount,
        "delivery_count": deliveryCount,
        "takeback_count": takeBackCount,
        "delivered_count": deliveredCount,
        "undelivered_count": undeliveredCount,
        "collected_count": collectedCount,
        "total_qty": totalQty,
        "total_return_qty": totalReturnQty,
        "customer_name": customerName,
        "customer_phone": customerPhone,
        "sales_rep_name": salesRepName,
        "sales_rep_phone": salesRepPhone,
        "stop_invoice_total": stopInvoiceTotal,
        "stop_collected_total": stopCollectedTotal,
        "stop_received_total": stopReceivedTotal,
        "received_amount_status": receivedAmountStatus,
        "invoices": List<dynamic>.from(invoices.map((x) => x.toJson())),
      };
}

class Invoice {
  final String invoiceId;
  final String invoiceNum;
  final String invoiceTotal;
  final String collectedAmount;
  final String receivedAmount;
  final bool receivedAmountStatus;
  final String paymentCode;
  final String reasonText;
  final String status;
  final String customerName;
  final String customerPhone;
  final String salesRepName;
  final String salesRepPhone;
  final int totalQty;
  final int deliveredQty;
  final int undeliveredQty;
  final int returnedQty;
  final String instructions;
  final int totalItems;
  final List<ReturnedItemModel> items;

  Invoice({
    required this.invoiceId,
    required this.invoiceNum,
    required this.invoiceTotal,
    required this.collectedAmount,
    required this.receivedAmount,
    required this.receivedAmountStatus,
    required this.paymentCode,
    required this.reasonText,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.salesRepName,
    required this.salesRepPhone,
    required this.totalQty,
    required this.deliveredQty,
    required this.undeliveredQty,
    required this.returnedQty,
    required this.instructions,
    required this.totalItems,
    required this.items,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        invoiceId: json["invoice_id"] ?? "",
        invoiceNum: json["invoice_num"] ?? "",
        invoiceTotal: json["invoice_total"] ?? "",
        collectedAmount: json["collected_amount"] ?? "",
        receivedAmount: json["received_amount"] ?? "",
        receivedAmountStatus: json["received_amount_status"] ?? false,
        paymentCode: json["payment_code"] ?? "",
        reasonText: json["reason_text"] ?? "",
        status: json["status"] ?? "",
        customerName: json["customer_name"] ?? "",
        customerPhone: json["customer_phone"] ?? "",
        salesRepName: json["sales_rep_name"] ?? "",
        salesRepPhone: json["sales_rep_phone"] ?? "",
        totalQty: json["total_qty"] ?? 0,
        deliveredQty: json["delivered_qty"] ?? 0,
        undeliveredQty: json["undelivered_qty"] ?? 0,
        returnedQty: json["returned_qty"] ?? 0,
        instructions: json["instructions"] ?? '',
        totalItems: json["total_items"] ?? 0,
        items: List<ReturnedItemModel>.from((json["items"] ?? []).map((x) => ReturnedItemModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "invoice_id": invoiceId,
        "invoice_num": invoiceNum,
        "invoice_total": invoiceTotal,
        "collected_amount": collectedAmount,
        "received_amount": receivedAmount,
        "received_amount_status": receivedAmountStatus,
        "payment_code": paymentCode,
        "reason_text": reasonText,
        "status": status,
        "customer_name": customerName,
        "customer_phone": customerPhone,
        "sales_rep_name": salesRepName,
        "sales_rep_phone": salesRepPhone,
        "total_qty": totalQty,
        "delivered_qty": deliveredQty,
        "undelivered_qty": undeliveredQty,
        "returned_qty": returnedQty,
        "instructions": instructions,
        "total_items": totalItems,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ReturnedItemModel {
  final String id;
  final String invoiceId;
  final String deliveryStatus;
  final int quantity;
  final int deliveredQty;
  final int undeliveredQty;
  final int returnQty;
  final int unReturnQty;
  final String returnStatus;
  final String returnProof;
  final String undeliveredReason;
  final String tripNo;
  final String soNum;
  final String itemId;
  final String itemCode;
  final String itemType;
  final String itemName;
  final String catchWeightStatus;
  final String catchWeightInfo;
  final String itemImage;
  final String itemColor;
  final String deliveryType;
  final String returnExpiry;

  ReturnedItemModel({
    required this.id,
    required this.invoiceId,
    required this.deliveryStatus,
    required this.quantity,
    required this.deliveredQty,
    required this.undeliveredQty,
    required this.returnQty,
    required this.unReturnQty,
    required this.returnStatus,
    required this.returnProof,
    required this.undeliveredReason,
    required this.tripNo,
    required this.soNum,
    required this.itemId,
    required this.itemCode,
    required this.itemType,
    required this.itemName,
    required this.catchWeightStatus,
    required this.catchWeightInfo,
    required this.itemImage,
    required this.itemColor,
    required this.deliveryType,
    required this.returnExpiry,
  });

  factory ReturnedItemModel.fromJson(Map<String, dynamic> json) => ReturnedItemModel(
        id: json["id"] ?? "",
        invoiceId: json["invoice_id"] ?? "",
        deliveryStatus: json["delivery_status"] ?? "",
        quantity: json["quantity"] ?? 0,
        deliveredQty: json["delivered_qty"] ?? 0,
        undeliveredQty: json["undelivered_qty"] ?? 0,
        returnQty: json["return_qty"] ?? 0,
        unReturnQty: json["unreturn_qty"] ?? 0,
        returnStatus: json["return_status"] ?? "",
        returnProof: json["return_proof"] ?? "",
        undeliveredReason: json["undelivered_reason"] ?? "",
        tripNo: json["trip_no"] ?? "",
        soNum: json["so_num"] ?? "",
        itemId: json["item_id"] ?? "",
        itemCode: json["item_code"] ?? "",
        itemType: json["item_type"] ?? "",
        itemName: json["item_name"] ?? "",
        catchWeightStatus: json["catchweight_status"] ?? "",
        catchWeightInfo: json["catchweight_info"] ?? "",
        itemImage: json["item_image"] ?? "",
        itemColor: json["item_color"] ?? "",
        deliveryType: json["delivery_type"] ?? "",
        returnExpiry: json["return_expiry"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_id": invoiceId,
        "delivery_status": deliveryStatus,
        "quantity": quantity,
        "delivered_qty": deliveredQty,
        "undelivered_qty": undeliveredQty,
        "return_qty": returnQty,
        "unreturn_qty": unReturnQty,
        "return_status": returnStatus,
        "return_proof": returnProof,
        "undelivered_reason": undeliveredReason,
        "trip_no": tripNo,
        "so_num": soNum,
        "item_id": itemId,
        "item_code": itemCode,
        "item_type": itemType,
        "item_name": itemName,
        "catchweight_status": catchWeightStatus,
        "catchweight_info": catchWeightInfo,
        "item_image": itemImage,
        "item_color": itemColor,
        "delivery_type": deliveryType,
        "return_expiry": returnExpiry,
      };
}

class TripInfo {
  final String tripId;
  final String tripReturnStatus;
  final String tripNum;
  final String routeName;
  final String stopsCount;
  final String createdDt;
  final String driverId;
  final String helper1Id;
  final String helper2Id;
  final String driverName;
  final String helper1Name;
  final String helper2Name;
  final String loadingBay;
  final String vehicleNumber;
  final String vehicleType;
  final String gatePassNum;
  final String itemsType;
  final String maxDiscountPercent;
  final int tripStartMeter;
  final String tripStartTime;
  final int tripEndMeter;
  final String tripEndTime;
  final String pinkSlipCaptured;
  final String pinkSlipNotCaptured;
  final String tripDuration;
  final String tripDistance;
  final int completedStopsCount;
  final int remainingStopsCount;
  final int totalInvoiceCount;
  final int completedInvoiceCount;
  final int remainingInvoiceCount;
  final int totalTakeBackCount;
  final int completedTakeBackCount;
  final int remainingTakeBackCount;
  final String totalCollectedAmount;
  final String totalExpenseAmount;
  final int totalReturnQty;
  final int totalReturnedQty;
  final int totalUnreturnedQty;
  final int totalAssetsQty;

  TripInfo({
    required this.tripId,
    required this.tripReturnStatus,
    required this.tripNum,
    required this.routeName,
    required this.stopsCount,
    required this.createdDt,
    required this.driverId,
    required this.helper1Id,
    required this.helper2Id,
    required this.driverName,
    required this.helper1Name,
    required this.helper2Name,
    required this.loadingBay,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.gatePassNum,
    required this.itemsType,
    required this.maxDiscountPercent,
    required this.tripStartMeter,
    required this.tripStartTime,
    required this.tripEndMeter,
    required this.tripEndTime,
    required this.pinkSlipCaptured,
    required this.pinkSlipNotCaptured,
    required this.tripDuration,
    required this.tripDistance,
    required this.completedStopsCount,
    required this.remainingStopsCount,
    required this.totalInvoiceCount,
    required this.completedInvoiceCount,
    required this.remainingInvoiceCount,
    required this.totalTakeBackCount,
    required this.completedTakeBackCount,
    required this.remainingTakeBackCount,
    required this.totalCollectedAmount,
    required this.totalExpenseAmount,
    required this.totalReturnQty,
    required this.totalReturnedQty,
    required this.totalUnreturnedQty,
    required this.totalAssetsQty,
  });

  factory TripInfo.fromJson(Map<String, dynamic> json) => TripInfo(
        tripId: json["trip_id"] ?? "",
    tripReturnStatus: json["return_status"] ?? "",
        tripNum: json["trip_num"] ?? "",
        routeName: json["route_name"] ?? "",
        stopsCount: json["stops_count"] ?? "",
        createdDt: json["created_dt"] ?? "",
        driverId: json["driver_id"] ?? "",
        helper1Id: json["helper1_id"] ?? "",
        helper2Id: json["helper2_id"] ?? "",
        driverName: json["driver_name"] ?? "",
        helper1Name: json["helper1_name"] ?? "",
        helper2Name: json["helper2_name"] ?? "",
        loadingBay: json["loading_bay"] ?? "",
        vehicleNumber: json["vehicle_number"] ?? "",
        vehicleType: json["vehicle_type"] ?? "",
        gatePassNum: json["gatepass_num"] ?? "",
        itemsType: json["items_type"] ?? "",
        maxDiscountPercent: json["max_discount_percent"] ?? "",
        tripStartMeter: json["trip_start_meter"] ?? 0,
        tripStartTime: json["trip_start_time"] ?? "",
        tripEndMeter: json["trip_end_meter"] ?? 0,
        tripEndTime: json["trip_end_time"] ?? "",
        pinkSlipCaptured: json["pinkslip_captured"] ?? "",
        pinkSlipNotCaptured: json["pinkslip_notcaptured"] ?? "",
        tripDuration: json["trip_duration"] ?? "",
        tripDistance: json["trip_distance"] ?? "",
        completedStopsCount: json["completed_stops_count"] ?? 0,
        remainingStopsCount: json["remaining_stops_count"] ?? 0,
        totalInvoiceCount: json["total_invoice_count"] ?? 0,
        completedInvoiceCount: json["completed_invoice_count"] ?? 0,
        remainingInvoiceCount: json["remaining_invoice_count"] ?? 0,
        totalTakeBackCount: json["total_takeback_count"] ?? 0,
        completedTakeBackCount: json["completed_takeback_count"] ?? 0,
        remainingTakeBackCount: json["remaining_takeback_count"] ?? 0,
        totalCollectedAmount: json["total_collected_amount"] ?? "",
        totalExpenseAmount: json["total_expense_amount"] ?? "",
        totalReturnQty: json["total_return_qty"] ?? 0,
        totalReturnedQty: json["total_returned_qty"] ?? 0,
        totalUnreturnedQty: json["total_unreturned_qty"] ?? 0,
    totalAssetsQty: json["total_assets"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "trip_id": tripId,
        "return_status": tripReturnStatus,
        "trip_num": tripNum,
        "route_name": routeName,
        "stops_count": stopsCount,
        "created_dt": createdDt,
        "driver_id": driverId,
        "helper1_id": helper1Id,
        "helper2_id": helper2Id,
        "driver_name": driverName,
        "helper1_name": helper1Name,
        "helper2_name": helper2Name,
        "loading_bay": loadingBay,
        "vehicle_number": vehicleNumber,
        "vehicle_type": vehicleType,
        "gatepass_num": gatePassNum,
        "items_type": itemsType,
        "max_discount_percent": maxDiscountPercent,
        "trip_start_meter": tripStartMeter,
        "trip_start_time": tripStartTime,
        "trip_end_meter": tripEndMeter,
        "trip_end_time": tripEndTime,
        "pinkslip_captured": pinkSlipCaptured,
        "pinkslip_notcaptured": pinkSlipNotCaptured,
        "trip_duration": tripDuration,
        "trip_distance": tripDistance,
        "completed_stops_count": completedStopsCount,
        "remaining_stops_count": remainingStopsCount,
        "total_invoice_count": totalInvoiceCount,
        "completed_invoice_count": completedInvoiceCount,
        "remaining_invoice_count": remainingInvoiceCount,
        "total_takeback_count": totalTakeBackCount,
        "completed_takeback_count": completedTakeBackCount,
        "remaining_takeback_count": remainingTakeBackCount,
        "total_collected_amount": totalCollectedAmount,
        "total_expense_amount": totalExpenseAmount,
        "total_return_qty": totalReturnQty,
        "total_returned_qty": totalReturnedQty,
        "total_unreturned_qty": totalUnreturnedQty,
        "total_assets": totalAssetsQty,
      };
}

/*import 'dart:convert';

RoTripDetailModel roTripDetailModelFromJson(String str) => RoTripDetailModel.fromJson(json.decode(str));

String roTripDetailModelToJson(RoTripDetailModel data) => json.encode(data.toJson());

class RoTripDetailModel {
  String status;
  Response response;

  RoTripDetailModel({
    required this.status,
    required this.response,
  });

  factory RoTripDetailModel.fromJson(Map<String, dynamic> json) => RoTripDetailModel(
        status: json["status"] ?? '',
        response: Response.fromJson(json["response"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class Response {
  TripInfo tripInfo;
  List<Stop> stops;
  List<OtherItem> otherItems;
  List<AssetChecklist> assetChecklist;

  Response({
    required this.tripInfo,
    required this.stops,
    required this.otherItems,
    required this.assetChecklist,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        tripInfo: TripInfo.fromJson(json["trip_info"] ?? {}),
        stops: List<Stop>.from((json["stops"] ?? []).map((x) => Stop.fromJson(x))),
        otherItems: List<OtherItem>.from((json["other_items"] ?? []).map((x) => OtherItem.fromJson(x))),
        assetChecklist: List<AssetChecklist>.from((json["asset_checklist"] ?? []).map((x) => AssetChecklist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "trip_info": tripInfo.toJson(),
        "stops": List<dynamic>.from(stops.map((x) => x.toJson())),
        "other_items": List<dynamic>.from(otherItems.map((x) => x.toJson())),
        "asset_checklist": List<dynamic>.from(assetChecklist.map((x) => x.toJson())),
      };
}

class AssetChecklist {
  String label;
  String id;
  bool req;
  bool isSelected;

  AssetChecklist({
    required this.label,
    required this.id,
    required this.req,
    required this.isSelected,
  });

  factory AssetChecklist.fromJson(Map<String, dynamic> json) => AssetChecklist(
        label: json["label"] ?? "",
        id: json["id"] ?? "",
        req: json["req"] ?? false,
        isSelected: json["is_selected"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "id": id,
        "req": req,
        "is_selected": isSelected,
      };
}

class OtherItem {
  String id;
  String itemName;
  String itemCode;
  int quantity;

  OtherItem({
    required this.id,
    required this.itemName,
    required this.itemCode,
    required this.quantity,
  });

  factory OtherItem.fromJson(Map<String, dynamic> json) =>
      OtherItem(id: json["id"] ?? "", itemName: json["it??0m_name"] ?? "", itemCode: json["item_code"] ?? "" ?? 0, quantity: json["quantity"] ?? 0);

  Map<String, dynamic> toJson() => {
        "id": id,
        "item_name": itemName,
        "item_code": itemCode,
        "quantity": quantity,
      };
}

class Stop {
  String stopId;
  String stopNum;
  String stopStatus;
  String type;
  String deliveryLocation;
  String deliveryLat;
  String deliveryLon;
  String totalCount;
  String deliveryCount;
  String takeBackCount;
  String deliveredCount;
  String undeliveredCount;
  String collectedCount;
  int totalQty;
  int totalReturnQty;
  String customerName;
  String customerPhone;
  String salesRepName;
  String salesRepPhone;
  List<Invoice> invoices;

  Stop({
    required this.stopId,
    required this.stopNum,
    required this.stopStatus,
    required this.type,
    required this.deliveryLocation,
    required this.deliveryLat,
    required this.deliveryLon,
    required this.totalCount,
    required this.deliveryCount,
    required this.takeBackCount,
    required this.deliveredCount,
    required this.undeliveredCount,
    required this.collectedCount,
    required this.totalQty,
    required this.totalReturnQty,
    required this.customerName,
    required this.customerPhone,
    required this.salesRepName,
    required this.salesRepPhone,
    required this.invoices,
  });

  factory Stop.fromJson(Map<String, dynamic> json) => Stop(
        stopId: json["stop_id"] ?? "",
        stopNum: json["stop_num"] ?? "",
        stopStatus: json["stop_status"] ?? "",
        type: json["type"] ?? "",
        deliveryLocation: json["delivery_location"] ?? "",
        deliveryLat: json["delivery_lat"] ?? "",
        deliveryLon: json["delivery_lon"] ?? "",
        totalCount: json["total_count"] ?? "",
        deliveryCount: json["delivery_count"] ?? "",
        takeBackCount: json["takeback_count"] ?? "",
        deliveredCount: json["delivered_count"] ?? "",
        undeliveredCount: json["undelivered_count"] ?? "",
        collectedCount: json["collected_count"] ?? "",
        totalQty: json["total_qty"] ?? 0,
        totalReturnQty: json["total_return_qty"] ?? 0,
        customerName: json["customer_name"] ?? "",
        customerPhone: json["customer_phone"] ?? "",
        salesRepName: json["sales_rep_name"] ?? "",
        salesRepPhone: json["sales_rep_phone"] ?? "",
        invoices: List<Invoice>.from((json["invoices"] ?? []).map((x) => Invoice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "stop_id": stopId,
        "stop_num": stopNum,
        "stop_status": stopStatus,
        "type": type,
        "delivery_location": deliveryLocation,
        "delivery_lat": deliveryLat,
        "delivery_lon": deliveryLon,
        "total_count": totalCount,
        "delivery_count": deliveryCount,
        "takeback_count": takeBackCount,
        "delivered_count": deliveredCount,
        "undelivered_count": undeliveredCount,
        "collected_count": collectedCount,
        "total_qty": totalQty,
        "total_return_qty": totalReturnQty,
        "customer_name": customerName,
        "customer_phone": customerPhone,
        "sales_rep_name": salesRepName,
        "sales_rep_phone": salesRepPhone,
        "invoices": List<dynamic>.from(invoices.map((x) => x.toJson())),
      };
}

class Invoice {
  String invoiceId;
  String invoiceNum;
  String invoiceTotal;
  String collectedAmount;
  String receivedAmount;
  String totalReceivedAmount;
  String paymentCode;
  String reasonText;
  String status;
  String customerName;
  String customerPhone;
  String salesRepName;
  String salesRepPhone;
  int totalQty;
  int deliveredQty;
  int undeliveredQty;
  int returnedQty;
  String instructions;
  int totalItems;
  List<ReturnedItemData> items;

  Invoice({
    required this.invoiceId,
    required this.invoiceNum,
    required this.invoiceTotal,
    required this.collectedAmount,
    required this.receivedAmount,
    required this.totalReceivedAmount,
    required this.paymentCode,
    required this.reasonText,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.salesRepName,
    required this.salesRepPhone,
    required this.totalQty,
    required this.deliveredQty,
    required this.undeliveredQty,
    required this.returnedQty,
    required this.instructions,
    required this.totalItems,
    required this.items,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        invoiceId: json["invoice_id"] ?? "",
        invoiceNum: json["invoice_num"] ?? "",
        invoiceTotal: json["invoice_total"] ?? "",
        collectedAmount: json["collected_amount"] ?? "",
        receivedAmount: json["received_amount"] ?? "",
        totalReceivedAmount: json["total_received_amount"] ?? "",
        paymentCode: json["payment_code"] ?? "",
        reasonText: json["reason_text"] ?? "",
        status: json["status"] ?? "",
        customerName: json["customer_name"] ?? "",
        customerPhone: json["customer_phone"] ?? "",
        salesRepName: json["sales_rep_name"] ?? "",
        salesRepPhone: json["sales_rep_phone"] ?? "",
        totalQty: json["total_qty"] ?? 0,
        deliveredQty: json["delivered_qty"] ?? 0,
        undeliveredQty: json["undelivered_qty"] ?? 0,
        returnedQty: json["returned_qty"] ?? 0,
        instructions: json["instructions"] ?? "",
        totalItems: json["total_items"] ?? 0,
        items: List<ReturnedItemData>.from((json["items"] ?? []).map((x) => ReturnedItemData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "invoice_id": invoiceId,
        "invoice_num": invoiceNum,
        "invoice_total": invoiceTotal,
        "collected_amount": collectedAmount,
        "received_amount": receivedAmount,
        "total_received_amount": totalReceivedAmount,
        "payment_code": paymentCode,
        "reason_text": reasonText,
        "status": status,
        "customer_name": customerName,
        "customer_phone": customerPhone,
        "sales_rep_name": salesRepName,
        "sales_rep_phone": salesRepPhone,
        "total_qty": totalQty,
        "delivered_qty": deliveredQty,
        "undelivered_qty": undeliveredQty,
        "returned_qty": returnedQty,
        "instructions": instructions,
        "total_items": totalItems,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ReturnedItemData {
  String id;
  String invoiceId;
  String deliveryStatus;
  int quantity;
  int deliveredQty;
  int undeliveredQty;
  int returnQty;
  int unReturnQty;
  String returnStatus;
  String returnProof;
  String undeliveredReason;
  String tripNo;
  String soNum;
  String itemId;
  String itemCode;
  String itemType;
  String itemName;
  String catchWeightStatus;
  String catchWeightInfo;
  String itemImage;
  String itemColor;
  String deliveryType;
  String returnExpiry;

  ReturnedItemData({
    required this.id,
    required this.invoiceId,
    required this.deliveryStatus,
    required this.quantity,
    required this.deliveredQty,
    required this.undeliveredQty,
    required this.returnQty,
    required this.unReturnQty,
    required this.returnStatus,
    required this.returnProof,
    required this.undeliveredReason,
    required this.tripNo,
    required this.soNum,
    required this.itemId,
    required this.itemCode,
    required this.itemType,
    required this.itemName,
    required this.catchWeightStatus,
    required this.catchWeightInfo,
    required this.itemImage,
    required this.itemColor,
    required this.deliveryType,
    required this.returnExpiry,
  });

  factory ReturnedItemData.fromJson(Map<String, dynamic> json) => ReturnedItemData(
        id: json["id"] ?? "",
        invoiceId: json["invoice_id"] ?? "",
        deliveryStatus: json["delivery_status"] ?? "",
        quantity: json["quantity"] ?? 0,
        deliveredQty: json["delivered_qty"] ?? 0,
        undeliveredQty: json["undelivered_qty"] ?? 0,
        returnQty: json["return_qty"] ?? 0,
        unReturnQty: json["unreturn_qty"] ?? 0,
        returnStatus: json["return_status"] ?? "",
        returnProof: json["return_proof"] ?? "",
        undeliveredReason: json["undelivered_reason"] ?? "",
        tripNo: json["trip_no"] ?? "",
        soNum: json["so_num"] ?? "",
        itemId: json["item_id"] ?? "",
        itemCode: json["item_code"] ?? "",
        itemType: json["item_type"] ?? "",
        itemName: json["item_name"] ?? "",
        catchWeightStatus: json["catchweight_status"] ?? "",
        catchWeightInfo: json["catchweight_info"] ?? "",
        itemImage: json["item_image"] ?? "",
        itemColor: json["item_color"] ?? "",
        deliveryType: json["delivery_type"] ?? "",
        returnExpiry: json["return_expiry"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_id": invoiceId,
        "delivery_status": deliveryStatus,
        "quantity": quantity,
        "delivered_qty": deliveredQty,
        "undelivered_qty": undeliveredQty,
        "return_qty": returnQty,
        "unreturn_qty": unReturnQty,
        "return_status": returnStatus,
        "return_proof": returnProof,
        "undelivered_reason": undeliveredReason,
        "trip_no": tripNo,
        "so_num": soNum,
        "item_id": itemId,
        "item_code": itemCode,
        "item_type": itemType,
        "item_name": itemName,
        "catchweight_status": catchWeightStatus,
        "catchweight_info": catchWeightInfo,
        "item_image": itemImage,
        "item_color": itemColor,
        "delivery_type": deliveryType,
        "return_expiry": returnExpiry,
      };
}

class TripInfo {
  String tripId;
  String tripReturnStatus;
  String tripNum;
  String routeName;
  String stopsCount;
  String createdDt;
  String driverId;
  String helper1Id;
  String helper2Id;
  String driverName;
  String helper1Name;
  String helper2Name;
  String loadingBay;
  String vehicleNumber;
  String vehicleType;
  String gatePassNum;
  String itemsType;
  String maxDiscountPercent;
  int tripStartMeter;
  String tripStartTime;
  int tripEndMeter;
  String tripEndTime;
  String pinkSlipCaptured;
  String pinkSlipNotCaptured;
  String tripDuration;
  String tripDistance;
  int completedStopsCount;
  int remainingStopsCount;
  int totalInvoiceCount;
  int completedInvoiceCount;
  int remainingInvoiceCount;
  int totalTakeBackCount;
  int completedTakeBackCount;
  int remainingTakeBackCount;
  String totalCollectedAmount;
  String totalExpenseAmount;
  int totalReturnQty;
  int totalReturnedQty;
  int totalUnreturnedQty;
  int totalAssetsQty;

  TripInfo({
    required this.tripId,
    required this.tripReturnStatus,
    required this.tripNum,
    required this.routeName,
    required this.stopsCount,
    required this.createdDt,
    required this.driverId,
    required this.helper1Id,
    required this.helper2Id,
    required this.driverName,
    required this.helper1Name,
    required this.helper2Name,
    required this.loadingBay,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.gatePassNum,
    required this.itemsType,
    required this.maxDiscountPercent,
    required this.tripStartMeter,
    required this.tripStartTime,
    required this.tripEndMeter,
    required this.tripEndTime,
    required this.pinkSlipCaptured,
    required this.pinkSlipNotCaptured,
    required this.tripDuration,
    required this.tripDistance,
    required this.completedStopsCount,
    required this.remainingStopsCount,
    required this.totalInvoiceCount,
    required this.completedInvoiceCount,
    required this.remainingInvoiceCount,
    required this.totalTakeBackCount,
    required this.completedTakeBackCount,
    required this.remainingTakeBackCount,
    required this.totalCollectedAmount,
    required this.totalExpenseAmount,
    required this.totalReturnQty,
    required this.totalReturnedQty,
    required this.totalUnreturnedQty,
    required this.totalAssetsQty,
  });

  factory TripInfo.fromJson(Map<String, dynamic> json) => TripInfo(
        tripId: json["trip_id"] ?? '',
        tripReturnStatus: json["return_status"] ?? '',
        tripNum: json["trip_num"] ?? '',
        routeName: json["route_name"] ?? '',
        stopsCount: json["stops_count"] ?? '',
        createdDt: json["created_dt"] ?? '',
        driverId: json["driver_id"] ?? '',
        helper1Id: json["helper1_id"] ?? '',
        helper2Id: json["helper2_id"] ?? '',
        driverName: json["driver_name"] ?? '',
        helper1Name: json["helper1_name"] ?? '',
        helper2Name: json["helper2_name"] ?? '',
        loadingBay: json["loading_bay"] ?? '',
        vehicleNumber: json["vehicle_number"] ?? '',
        vehicleType: json["vehicle_type"] ?? '',
        gatePassNum: json["gatepass_num"] ?? '',
        itemsType: json["items_type"] ?? '',
        maxDiscountPercent: json["max_discount_percent"] ?? '',
        tripStartMeter: json["trip_start_meter"] ?? 0,
        tripStartTime: json["trip_start_time"] ?? "",
        tripEndMeter: json["trip_end_meter"] ?? 0,
        tripEndTime: json["trip_end_time"] ?? "",
        pinkSlipCaptured: json["pinkslip_captured"] ?? "",
        pinkSlipNotCaptured: json["pinkslip_notcaptured"] ?? "",
        tripDuration: json["trip_duration"] ?? "",
        tripDistance: json["trip_distance"] ?? "",
        completedStopsCount: json["completed_stops_count"] ?? 0,
        remainingStopsCount: json["remaining_stops_count"] ?? 0,
        totalInvoiceCount: json["total_invoice_count"] ?? 0,
        completedInvoiceCount: json["completed_invoice_count"] ?? 0,
        remainingInvoiceCount: json["remaining_invoice_count"] ?? 0,
        totalTakeBackCount: json["total_takeback_count"] ?? 0,
        completedTakeBackCount: json["completed_takeback_count"] ?? 0,
        remainingTakeBackCount: json["remaining_takeback_count"] ?? 0,
        totalCollectedAmount: json["total_collected_amount"] ?? "",
        totalExpenseAmount: json["total_expense_amount"] ?? "",
        totalReturnQty: json["total_return_qty"] ?? 0,
        totalReturnedQty: json["total_returned_qty"] ?? 0,
        totalUnreturnedQty: json["total_unreturned_qty"] ?? 0,
    totalAssetsQty: json["total_assets"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "trip_id": tripId,
        "return_status": tripReturnStatus,
        "trip_num": tripNum,
        "route_name": routeName,
        "stops_count": stopsCount,
        "created_dt": createdDt,
        "driver_id": driverId,
        "helper1_id": helper1Id,
        "helper2_id": helper2Id,
        "driver_name": driverName,
        "helper1_name": helper1Name,
        "helper2_name": helper2Name,
        "loading_bay": loadingBay,
        "vehicle_number": vehicleNumber,
        "vehicle_type": vehicleType,
        "gatepass_num": gatePassNum,
        "items_type": itemsType,
        "max_discount_percent": maxDiscountPercent,
        "trip_start_meter": tripStartMeter,
        "trip_start_time": tripStartTime,
        "trip_end_meter": tripEndMeter,
        "trip_end_time": tripEndTime,
        "pinkslip_captured": pinkSlipCaptured,
        "pinkslip_notcaptured": pinkSlipNotCaptured,
        "trip_duration": tripDuration,
        "trip_distance": tripDistance,
        "completed_stops_count": completedStopsCount,
        "remaining_stops_count": remainingStopsCount,
        "total_invoice_count": totalInvoiceCount,
        "completed_invoice_count": completedInvoiceCount,
        "remaining_invoice_count": remainingInvoiceCount,
        "total_takeback_count": totalTakeBackCount,
        "completed_takeback_count": completedTakeBackCount,
        "remaining_takeback_count": remainingTakeBackCount,
        "total_collected_amount": totalCollectedAmount,
        "total_expense_amount": totalExpenseAmount,
        "total_return_qty": totalReturnQty,
        "total_returned_qty": totalReturnedQty,
        "total_unreturned_qty": totalUnreturnedQty,
        "total_assets": totalAssetsQty,
      };
}*/
