// Dart imports:
import 'dart:convert';

DisputeListResponse disputeListResponseFromJson(String str) => DisputeListResponse.fromJson(json.decode(str));

String disputeListResponseToJson(DisputeListResponse data) => json.encode(data.toJson());

class DisputeListResponse {
  String status;
  DisputeMainResponse response;

  DisputeListResponse({
    required this.status,
    required this.response,
  });

  factory DisputeListResponse.fromJson(Map<String, dynamic> json) => DisputeListResponse(
    status: json["status"]??"",
    response: DisputeMainResponse.fromJson(json["response"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": response.toJson(),
  };
}

class DisputeMainResponse {
  int yetToResolve;
  int resolved;
  int closed;
  List<DisputeList> disputeList;
  List<Reason> resolveReasons;
  List<Reason> reassignReasons;

  DisputeMainResponse({
    required this.yetToResolve,
    required this.resolved,
    required this.closed,
    required this.disputeList,
    required this.resolveReasons,
    required this.reassignReasons,
  });

  factory DisputeMainResponse.fromJson(Map<String, dynamic> json) => DisputeMainResponse(
    yetToResolve: json["yet_to_resolve"]??0,
    resolved: json["resolved"]??0,
    closed: json["closed"]??0,
    disputeList: List<DisputeList>.from((json["dispute_list"]??[]).map((x) => DisputeList.fromJson(x))),
    resolveReasons: List<Reason>.from((json["resolve_reasons"]??[]).map((x) => Reason.fromJson(x))),
    reassignReasons: List<Reason>.from((json["reassign_reasons"]??[]).map((x) => Reason.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "yet_to_resolve": yetToResolve,
    "resolved": resolved,
    "closed": closed,
    "dispute_list": List<dynamic>.from(disputeList.map((x) => x.toJson())),
    "resolve_reasons": List<dynamic>.from(resolveReasons.map((x) => x.toJson())),
    "reassign_reasons": List<dynamic>.from(reassignReasons.map((x) => x.toJson())),
  };
}

class DisputeList {
  String id;
  bool reassignAction;
  bool resolveAction;
  bool removeAction;
  String picklistNum;
  String disputeNum;
  String soNum;
  String locationType;
  String location;
  String status;
  String created;
  String updated;
  String quantity;
  String itemName;
  String itemCode;
  String uom;
  String itemType;
  String itemColor;
  Info disputeInfo;
  Info resolutionInfo;
  List<BatchInfo> batchInfo;

  DisputeList({
    required this.id,
    required this.reassignAction,
    required this.resolveAction,
    required this.removeAction,
    required this.picklistNum,
    required this.disputeNum,
    required this.soNum,
    required this.locationType,
    required this.location,
    required this.status,
    required this.created,
    required this.updated,
    required this.quantity,
    required this.itemName,
    required this.itemCode,
    required this.uom,
    required this.itemType,
    required this.itemColor,
    required this.disputeInfo,
    required this.resolutionInfo,
    required this.batchInfo,
  });

  factory DisputeList.fromJson(Map<String, dynamic> json) => DisputeList(
    id: json["id"]??"",
    reassignAction: json["reassign_action"]??false,
    resolveAction: json["resolve_action"]??false,
    removeAction: json["remove_action"]??false,
    picklistNum: json["picklist_num"]??"",
    disputeNum: json["dispute_num"]??"",
    soNum: json["so_num"]??"",
    locationType: json["location_type"]??"",
    location: json["location"]??"",
    status: json["status"]??"",
    created: json["created"]??"",
    updated: json["updated"]??"",
    quantity: json["quantity"]??"",
    itemName: json["item_name"]??"",
    itemCode: json["item_code"]??"",
    uom: json["uom"]??"",
    itemType: json["item_type"]??"",
    itemColor: json["item_color"]??"",
    disputeInfo: Info.fromJson(json["dispute_info"]??{}),
    resolutionInfo: Info.fromJson(json["resolution_info"]??{}),
    batchInfo: List<BatchInfo>.from((json["batch_info"]??[]).map((x) => BatchInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reassign_action": reassignAction,
    "resolve_action": resolveAction,
    "remove_action": removeAction,
    "picklist_num": picklistNum,
    "dispute_num": disputeNum,
    "so_num": soNum,
    "location_type": locationType,
    "location": location,
    "status": status,
    "created": created,
    "updated": updated,
    "quantity": quantity,
    "item_name": itemName,
    "item_code": itemCode,
    "uom": uom,
    "item_type": itemType,
    "item_color": itemColor,
    "dispute_info": disputeInfo.toJson(),
    "resolution_info": resolutionInfo.toJson(),
    "batch_info": List<dynamic>.from(batchInfo.map((x) => x.toJson())),
  };
}

class BatchInfo {
  String id;
  String picklistItemId;
  String stockType;
  String batchNum;
  String quantity;
  String disputeQty;

  BatchInfo({
    required this.id,
    required this.picklistItemId,
    required this.stockType,
    required this.batchNum,
    required this.quantity,
    required this.disputeQty,
  });

  factory BatchInfo.fromJson(Map<String, dynamic> json) => BatchInfo(
    id: json["id"]??'',
    picklistItemId: json["picklist_item_id"]??'',
    stockType: json["stock_type"]??'',
    batchNum: json["batch_num"]??'',
    quantity: json["quantity"]??'',
    disputeQty: json["dispute_qty"]??'',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "picklist_item_id": picklistItemId,
    "stock_type": stockType,
    "batch_num": batchNum,
    "quantity": quantity,
    "dispute_qty": disputeQty,
  };
}

class Info {
  List<By> by;
  String on;
  String reason;
  String remarks;

  Info({
    required this.by,
    required this.on,
    required this.reason,
    required this.remarks,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    by: List<By>.from((json["by"]??[]).map((x) => By.fromJson(x))),
    on: json["on"]??"",
    reason: json["reason"]??"",
    remarks: json["remarks"]??"",
  );

  Map<String, dynamic> toJson() => {
    "by": List<dynamic>.from(by.map((x) => x.toJson())),
    "on": on,
    "reason": reason,
    "remarks": remarks,
  };
}

class By {
  String id;
  String code;
  String name;
  String image;
  String employeeType;

  By({
    required this.id,
    required this.code,
    required this.name,
    required this.image,
    required this.employeeType,
  });

  factory By.fromJson(Map<String, dynamic> json) => By(
    id: json["id"]??'',
    code: json["code"]??'',
    name: json["name"]??'',
    image: json["image"]??'',
    employeeType: json["employee_type"]??'',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "image": image,
    "employee_type": employeeType,
  };
}

class Reason {
  String id;
  String code;
  String description;

  Reason({
    required this.id,
    required this.code,
    required this.description,
  });

  factory Reason.fromJson(Map<String, dynamic> json) => Reason(
    id: json["id"]??"",
    code: json["code"]??"",
    description: json["description"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "description": description,
  };
}
