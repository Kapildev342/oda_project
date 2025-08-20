class SocketMessageResponse {
  final String event;
  final String message;
  final String module;
  final String activity;
  final String actorId;
  final SocketMessageResponseBody body;

  SocketMessageResponse({
    required this.event,
    required this.message,
    required this.module,
    required this.activity,
    required this.actorId,
    required this.body,
  });

  factory SocketMessageResponse.fromJson(Map<String, dynamic> json) => SocketMessageResponse(
        event: json["event"] ?? "",
        message: json["message"] ?? "",
        module: json["module"] ?? "",
        activity: json["activity"] ?? "",
        actorId: json["actor_id"] ?? "",
        body: SocketMessageResponseBody.fromJson(json["body"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "event": event,
        "message": message,
        "module": module,
        "activity": activity,
        "actor_id": actorId,
        "body": body.toJson(),
      };
}

class SocketMessageResponseBody {
  final String picklistId;
  final String picklistItemId;
  final String btsId;
  final String catchWeightId;
  final String quantity;
  final String itemName;
  final String itemCode;
  final String locationName;
  final String reportedBy;
  final String entryTime;

  SocketMessageResponseBody({
    required this.picklistId,
    required this.picklistItemId,
    required this.btsId,
    required this.catchWeightId,
    required this.quantity,
    required this.itemName,
    required this.itemCode,
    required this.locationName,
    required this.reportedBy,
    required this.entryTime,
  });

  factory SocketMessageResponseBody.fromJson(Map<String, dynamic> json) => SocketMessageResponseBody(
        picklistId: json["picklist_id"] ?? "",
        picklistItemId: json["picklist_item_id"] ?? "",
        btsId: json["bts_id"] ?? "",
        catchWeightId: json["catchweight_id"] ?? "",
        quantity: json["quantity"] ?? "",
        itemName: json["item_name"] ?? "",
        itemCode: json["item_code"] ?? "",
        locationName: json["location_name"] ?? "",
        reportedBy: json["reported_by"] ?? "",
        entryTime: json["entry_time"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "picklist_id": picklistId,
        "picklist_item_id": picklistItemId,
        "bts_id": btsId,
        "catchweight_id": catchWeightId,
        "quantity": quantity,
        "item_name": itemName,
        "item_code": itemCode,
        "location_name": locationName,
        "reported_by": reportedBy,
        "entry_time": entryTime,
      };
}

class SocketPickListMessageResponse {
  final String event;
  final String message;
  final String module;
  final String activity;
  final String actorId;
  final SocketPickListResponseBody body;

  SocketPickListMessageResponse({
    required this.event,
    required this.message,
    required this.module,
    required this.activity,
    required this.actorId,
    required this.body,
  });

  factory SocketPickListMessageResponse.fromJson(Map<String, dynamic> json) => SocketPickListMessageResponse(
        event: json["event"] ?? "",
        message: json["message"] ?? "",
        module: json["module"] ?? "",
        activity: json["activity"] ?? "",
        actorId: json["actor_id"] ?? "",
        body: SocketPickListResponseBody.fromJson(json["body"] ?? ""),
      );

  Map<String, dynamic> toJson() => {
        "event": event,
        "message": message,
        "module": module,
        "activity": activity,
        "actor_id": actorId,
        "body": body.toJson(),
      };
}

class SocketPickListResponseBody {
  final String picklistId;
  final String picklistNum;
  final String totalItems;
  final String createdBy;
  final String createdTime;

  SocketPickListResponseBody({
    required this.picklistId,
    required this.picklistNum,
    required this.totalItems,
    required this.createdBy,
    required this.createdTime,
  });

  factory SocketPickListResponseBody.fromJson(Map<String, dynamic> json) => SocketPickListResponseBody(
      picklistId: json["picklist_id"] ?? "",
      picklistNum: json["picklist_num"] ?? "",
      totalItems: (json["total_items"] ?? 0).toString(),
      createdBy: json["created_by"] ?? "",
      createdTime: json["created_time"] ?? "");

  Map<String, dynamic> toJson() => {
        "picklist_id": picklistId,
        "picklist_num": picklistNum,
        "total_items": totalItems,
        "created_by": createdBy,
        "created_time": createdTime,
      };
}

class SocketDisputeResponse {
  final String event;
  final String message;
  final String module;
  final String activity;
  final String actorId;
  final SocketDisputeResponseBody body;

  SocketDisputeResponse({
    required this.event,
    required this.message,
    required this.module,
    required this.activity,
    required this.actorId,
    required this.body,
  });

  factory SocketDisputeResponse.fromJson(Map<String, dynamic> json) => SocketDisputeResponse(
        event: json["event"],
        message: json["message"],
        module: json["module"],
        activity: json["activity"],
        actorId: json["actor_id"],
        body: SocketDisputeResponseBody.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "event": event,
        "message": message,
        "module": module,
        "activity": activity,
        "actor_id": actorId,
        "body": body.toJson(),
      };
}

class SocketDisputeResponseBody {
  final String disputeId;
  final SocketDisputeResponseDisputeInfo disputeInfo;

  SocketDisputeResponseBody({
    required this.disputeId,
    required this.disputeInfo,
  });

  factory SocketDisputeResponseBody.fromJson(Map<String, dynamic> json) => SocketDisputeResponseBody(
        disputeId: (json["dispute_id"] ?? 0).toString(),
        disputeInfo: SocketDisputeResponseDisputeInfo.fromJson(json["dispute_info"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "dispute_id": disputeId,
        "dispute_info": disputeInfo.toJson(),
      };
}

class SocketDisputeResponseDisputeInfo {
  final String disputeNum;
  final String dt;
  final String status;
  final String reporterId;
  final String reporterType;
  final String itemId;
  final String itemCode;
  final String itemType;
  final String itemName;
  final String picklistId;
  final String picklistNum;
  final String picklistItemId;
  final String unavailableReasonName;
  final String unavailableReason;
  final String unavailableRemarks;
  final String reqQty;
  final String disputeQty;
  final String locationName;
  final String locationType;
  final String salesUom;
  final String disputeType;
  final String alternativeItem;

  SocketDisputeResponseDisputeInfo({
    required this.disputeNum,
    required this.dt,
    required this.status,
    required this.reporterId,
    required this.reporterType,
    required this.itemId,
    required this.itemCode,
    required this.itemType,
    required this.itemName,
    required this.picklistId,
    required this.picklistNum,
    required this.picklistItemId,
    required this.unavailableReasonName,
    required this.unavailableReason,
    required this.unavailableRemarks,
    required this.reqQty,
    required this.disputeQty,
    required this.locationName,
    required this.locationType,
    required this.salesUom,
    required this.disputeType,
    required this.alternativeItem,
  });

  factory SocketDisputeResponseDisputeInfo.fromJson(Map<String, dynamic> json) => SocketDisputeResponseDisputeInfo(
        disputeNum: (json["dispute_num"] ?? 0).toString(),
        dt: json["dt"] ?? "",
        status: json["status"] ?? "",
        reporterId: json["reporter_id"] ?? "",
        reporterType: json["reporter_type"] ?? "",
        itemId: json["item_id"] ?? "",
        itemCode: json["item_code"] ?? "",
        itemType: json["item_type"] ?? "",
        itemName: json["item_name"] ?? "",
        picklistId: json["picklist_id"] ?? "",
        picklistNum: json["picklist_num"] ?? "",
        picklistItemId: json["picklist_item_id"] ?? "",
        unavailableReasonName: json["unavail_reason_name"] ?? "",
        unavailableReason: json["unavail_reason"] ?? "",
        unavailableRemarks: json["unavail_remarks"] ?? "",
        reqQty: json["req_qty"] ?? "",
        disputeQty: (json["dispute_qty"] ?? 0).toString(),
        locationName: json["location_name"] ?? "",
        locationType: json["location_type"] ?? "",
        salesUom: json["sales_uom"] ?? "",
        disputeType: json["dispute_type"] ?? "",
        alternativeItem: json["alternative_item"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "dispute_num": disputeNum,
        "dt": dt,
        "status": status,
        "reporter_id": reporterId,
        "reporter_type": reporterType,
        "item_id": itemId,
        "item_code": itemCode,
        "item_type": itemType,
        "item_name": itemName,
        "picklist_id": picklistId,
        "picklist_num": picklistNum,
        "picklist_item_id": picklistItemId,
        "unavail_reason_name": unavailableReasonName,
        "unavail_reason": unavailableReason,
        "unavail_remarks": unavailableRemarks,
        "req_qty": reqQty,
        "dispute_qty": disputeQty,
        "location_name": locationName,
        "location_type": locationType,
        "sales_uom": salesUom,
        "dispute_type": disputeType,
        "alternative_item": alternativeItem,
      };
}

class SocketBtsResponse {
  final String event;
  final String message;
  final String module;
  final String activity;
  final String actorId;
  final SocketBtsResponseBody body;

  SocketBtsResponse({
    required this.event,
    required this.message,
    required this.module,
    required this.activity,
    required this.actorId,
    required this.body,
  });

  factory SocketBtsResponse.fromJson(Map<String, dynamic> json) => SocketBtsResponse(
    event: json["event"]??"",
    message: json["message"]??"",
    module: json["module"]??"",
    activity: json["activity"]??"",
    actorId: json["actor_id"]??"",
    body: SocketBtsResponseBody.fromJson(json["body"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "event": event,
    "message": message,
    "module": module,
    "activity": activity,
    "actor_id": actorId,
    "body": body.toJson(),
  };
}

class SocketBtsResponseBody {
  final String btsId;
  final String quantity;
  final String itemName;
  final String itemCode;
  final String locationName;
  final String reportedBy;
  final String entryTime;

  SocketBtsResponseBody({
    required this.btsId,
    required this.quantity,
    required this.itemName,
    required this.itemCode,
    required this.locationName,
    required this.reportedBy,
    required this.entryTime,
  });

  factory SocketBtsResponseBody.fromJson(Map<String, dynamic> json) => SocketBtsResponseBody(
    btsId: json["bts_id"]??"",
    quantity: json["quantity"]??"",
    itemName: json["item_name"]??"",
    itemCode: json["item_code"]??"",
    locationName: json["location_name"]??"",
    reportedBy: json["reported_by"]??"",
    entryTime: json["entry_time"]??"",
  );

  Map<String, dynamic> toJson() => {
    "bts_id": btsId,
    "quantity": quantity,
    "item_name": itemName,
    "item_code": itemCode,
    "location_name": locationName,
    "reported_by": reportedBy,
    "entry_time": entryTime,
  };
}
