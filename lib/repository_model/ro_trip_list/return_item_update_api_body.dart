import 'dart:convert';

ReturnItemUpdateApiBody returnItemUpdateApiBodyFromJson(String str) => ReturnItemUpdateApiBody.fromJson(json.decode(str));

String returnItemUpdateApiBodyToJson(ReturnItemUpdateApiBody data) => json.encode(data.toJson());

class ReturnItemUpdateApiBody {
  String tripId;
  String locationId;
  List<Item> items;
  List<Item> otherItems;

  ReturnItemUpdateApiBody({
    required this.tripId,
    required this.locationId,
    required this.items,
    required this.otherItems,
  });

  factory ReturnItemUpdateApiBody.fromJson(Map<String, dynamic> json) => ReturnItemUpdateApiBody(
    tripId: json["trip_id"]??"",
    locationId: json["location_id"]??"",
    items: List<Item>.from((json["items"]??[]).map((x) => Item.fromJson(x))),
    otherItems: List<Item>.from((json["other_items"]??[]).map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "trip_id": tripId,
    "location_id": locationId,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "other_items": List<dynamic>.from(otherItems.map((x) => x.toJson())),
  };
}

class Item {
  String itemId;
  String returnQty;
  String unReturnQty;
  String proofOfReturn;

  Item({
    required this.itemId,
    required this.returnQty,
    required this.unReturnQty,
    required this.proofOfReturn,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    itemId: json["item_id"]??"",
    returnQty: json["return_qty"]??"",
    unReturnQty: json["unreturn_qty"]??"",
    proofOfReturn: json["proof_of_return"]??"",
  );

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "return_qty": returnQty,
    "unreturn_qty": unReturnQty,
    "proof_of_return": proofOfReturn,
 };
}
