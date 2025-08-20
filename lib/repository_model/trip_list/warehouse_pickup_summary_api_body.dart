import 'dart:convert';

WareHousePickupSummaryApiBody wareHousePickupSummaryApiBodyFromJson(String str) => WareHousePickupSummaryApiBody.fromJson(json.decode(str));

String wareHousePickupSummaryApiBodyToJson(WareHousePickupSummaryApiBody data) => json.encode(data.toJson());

class WareHousePickupSummaryApiBody {
  String tripId;
  String stopId;
  String paymentMethod;
  String discountPercentage;
  String proofOfDelivery; // 5 images string
  String signature;
  String remarks;
  List<String> images;//50 images
  String referenceNo;
  String chequeAmount;
  String chequeNumber;
  String chequeDate;
  String bank;
  String branch;
  String chequeFront;
  String chequeBack;
  String comments;
  String remarksRecording;//NA
  String collectedAmount;//
  List<Invoice> invoices;
  String startSession;//
  String endSession;//

  WareHousePickupSummaryApiBody({
    required this.tripId,
    required this.stopId,
    required this.paymentMethod,
    required this.discountPercentage,
    required this.proofOfDelivery,
    required this.signature,
    required this.remarks,
    required this.images,
    required this.referenceNo,
    required this.chequeAmount,
    required this.chequeNumber,
    required this.chequeDate,
    required this.bank,
    required this.branch,
    required this.chequeFront,
    required this.chequeBack,
    required this.comments,
    required this.remarksRecording,
    required this.collectedAmount,
    required this.invoices,
    required this.startSession,
    required this.endSession,
  });

  factory WareHousePickupSummaryApiBody.fromJson(Map<String, dynamic> json) => WareHousePickupSummaryApiBody(
        tripId: json["trip_id"] ?? "",
        stopId: json["stop_id"] ?? "",
        paymentMethod: json["payment_method"] ?? "",
        discountPercentage: json["discount_percentage"] ?? "",
        proofOfDelivery: json["proof_of_delivery"] ?? "",
        signature: json["signature"] ?? "",
        remarks: json["remarks"] ?? "",
        images: List<String>.from((json["images"] ?? []).map((x) => x)),
        referenceNo: json["reference_no"] ?? "",
        chequeAmount: json["cheque_amount"] ?? "",
        chequeNumber: json["cheque_number"] ?? "",
        chequeDate: json["cheque_date"] ?? "",
        bank: json["bank"] ?? "",
        branch: json["branch"] ?? "",
        chequeFront: json["cheque_front"] ?? "",
        chequeBack: json["cheque_back"] ?? "",
        comments: json["comments"] ?? "",
        remarksRecording: json["remarks_recording"] ?? "",
        collectedAmount: json["collected_amount"] ?? "",
        invoices: List<Invoice>.from((json["invoices"] ?? []).map((x) => Invoice.fromJson(x))),
        startSession: json["start_session"] ?? "",
        endSession: json["end_session"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "trip_id": tripId,
        "stop_id": stopId,
        "payment_method": paymentMethod,
        "discount_percentage": discountPercentage,
        "proof_of_delivery": proofOfDelivery,
        "signature": signature,
        "remarks": remarks,
        "images": List<dynamic>.from(images.map((x) => x)),
        "reference_no": referenceNo,
        "cheque_amount": chequeAmount,
        "cheque_number": chequeNumber,
        "cheque_date": chequeDate,
        "bank": bank,
        "branch": branch,
        "cheque_front": chequeFront,
        "cheque_back": chequeBack,
        "comments": comments,
        "remarks_recording": remarksRecording,
        "collected_amount": collectedAmount,
        "invoices": List<dynamic>.from(invoices.map((x) => x.toJson())),
        "start_session": startSession,
        "end_session": endSession,
      };
}

class Invoice {
  String invoiceId;
  String proofOfDelivery;
  String proofOfDeliveryUrl;
  List<Item> items;

  Invoice({
    required this.invoiceId,
    required this.proofOfDelivery,
    required this.proofOfDeliveryUrl,
    required this.items,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        invoiceId: json["invoice_id"] ?? "",
        proofOfDelivery: json["proof_of_delivery"] ?? "",
        proofOfDeliveryUrl: json["proof_of_delivery_url"] ?? "",
        items: List<Item>.from((json["items"] ?? []).map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "invoice_id": invoiceId,
        "proof_of_delivery": proofOfDelivery,
        "proof_of_delivery_url": proofOfDeliveryUrl,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  String itemId;
  String delivered;
  String undelivered;
  String catchWeightQty;
  String undeliveredReason;
  String undeliveredRemarks;
  String lineItemId;

  Item({
    required this.itemId,
    required this.delivered,
    required this.undelivered,
    required this.catchWeightQty,
    required this.undeliveredReason,
    required this.undeliveredRemarks,
    required this.lineItemId,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemId: json["item_id"] ?? "",
        delivered: json["delivered"] ?? "",
        undelivered: json["undelivered"] ?? "",
        catchWeightQty: json["catchweight_qty"] ?? "",
        undeliveredReason: json["undelivered_reason"] ?? "",
        undeliveredRemarks: json["undelivered_remarks"] ?? "",
        lineItemId: json["line_item_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "delivered": delivered,
        "undelivered": undelivered,
        "catchweight_qty": catchWeightQty,
        "undelivered_reason": undeliveredReason,
        "undelivered_remarks": undeliveredRemarks,
        "line_item_id": lineItemId,
      };
}
