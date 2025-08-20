// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripListAdapter extends TypeAdapter<TripList> {
  @override
  final int typeId = 9;

  @override
  TripList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripList(
      tripId: fields[0] as String,
      tripNum: fields[1] as String,
      tripVehicle: fields[2] as String,
      tripRoute: fields[3] as String,
      tripStops: fields[4] as String,
      tripCreatedTime: fields[5] as String,
      tripOrders: fields[6] as String,
      tripHandledBy: (fields[7] as List).cast<HandledByForUpdateList>(),
      tripStatus: fields[8] as String,
      tripStatusColor: fields[9] as String,
      tripStatusBackGroundColor: fields[10] as String,
      tripLoadingBayDry: fields[11] as String,
      tripLoadingBayDryName: fields[12] as String,
      tripLoadingBayFrozen: fields[13] as String,
      tripLoadingBayFrozenName: fields[14] as String,
      tripItemType: fields[15] as String,
      unavailableReasons: (fields[16] as List).cast<UnavailableReason>(),
      sessionInfo: fields[17] as SessionInfo,
      partialItemsList: (fields[18] as List).cast<ItemsList>(),
      businessDate: fields[19] as String,
      deliveryArea: fields[20] as String,
      isSessionOpened: fields[21] as bool,
      sessionId: fields[22] as String,
      sessionTimeStamp: fields[23] as String,
      sessionEventType: fields[24] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TripList obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.tripId)
      ..writeByte(1)
      ..write(obj.tripNum)
      ..writeByte(2)
      ..write(obj.tripVehicle)
      ..writeByte(3)
      ..write(obj.tripRoute)
      ..writeByte(4)
      ..write(obj.tripStops)
      ..writeByte(5)
      ..write(obj.tripCreatedTime)
      ..writeByte(6)
      ..write(obj.tripOrders)
      ..writeByte(7)
      ..write(obj.tripHandledBy)
      ..writeByte(8)
      ..write(obj.tripStatus)
      ..writeByte(9)
      ..write(obj.tripStatusColor)
      ..writeByte(10)
      ..write(obj.tripStatusBackGroundColor)
      ..writeByte(11)
      ..write(obj.tripLoadingBayDry)
      ..writeByte(12)
      ..write(obj.tripLoadingBayDryName)
      ..writeByte(13)
      ..write(obj.tripLoadingBayFrozen)
      ..writeByte(14)
      ..write(obj.tripLoadingBayFrozenName)
      ..writeByte(15)
      ..write(obj.tripItemType)
      ..writeByte(16)
      ..write(obj.unavailableReasons)
      ..writeByte(17)
      ..write(obj.sessionInfo)
      ..writeByte(18)
      ..write(obj.partialItemsList)
      ..writeByte(19)
      ..write(obj.businessDate)
      ..writeByte(20)
      ..write(obj.deliveryArea)
      ..writeByte(21)
      ..write(obj.isSessionOpened)
      ..writeByte(22)
      ..write(obj.sessionId)
      ..writeByte(23)
      ..write(obj.sessionTimeStamp)
      ..writeByte(24)
      ..write(obj.sessionEventType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SoListAdapter extends TypeAdapter<SoList> {
  @override
  final int typeId = 10;

  @override
  SoList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoList(
      soId: fields[0] as String,
      soNum: fields[1] as String,
      soCustomerName: fields[2] as String,
      soCustomerCode: fields[3] as String,
      soDeliveryInstruction: fields[4] as String,
      soStatus: fields[5] as String,
      soNoOfItems: fields[6] as String,
      soType: fields[7] as String,
      soStops: fields[8] as String,
      disputeStatus: fields[9] as bool,
      soHandledBy: (fields[10] as List).cast<HandledByForUpdateList>(),
      soItemType: fields[12] as String,
      tripId: fields[11] as String,
      isSelected: fields[13] as bool,
      soNoOfSortedItems: fields[14] as String,
      soNoOfLoadedItems: fields[15] as String,
      sessionInfo: fields[16] as SessionInfo,
      soCreatedTime: fields[17] as String,
      doDelivery: fields[18] as bool,
      tripLoadingBayDryName: fields[19] as String,
      tripLoadingBayFrozenName: fields[20] as String,
      stopId: fields[21] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SoList obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.soId)
      ..writeByte(1)
      ..write(obj.soNum)
      ..writeByte(2)
      ..write(obj.soCustomerName)
      ..writeByte(3)
      ..write(obj.soCustomerCode)
      ..writeByte(4)
      ..write(obj.soDeliveryInstruction)
      ..writeByte(5)
      ..write(obj.soStatus)
      ..writeByte(6)
      ..write(obj.soNoOfItems)
      ..writeByte(7)
      ..write(obj.soType)
      ..writeByte(8)
      ..write(obj.soStops)
      ..writeByte(9)
      ..write(obj.disputeStatus)
      ..writeByte(10)
      ..write(obj.soHandledBy)
      ..writeByte(11)
      ..write(obj.tripId)
      ..writeByte(12)
      ..write(obj.soItemType)
      ..writeByte(13)
      ..write(obj.isSelected)
      ..writeByte(14)
      ..write(obj.soNoOfSortedItems)
      ..writeByte(15)
      ..write(obj.soNoOfLoadedItems)
      ..writeByte(16)
      ..write(obj.sessionInfo)
      ..writeByte(17)
      ..write(obj.soCreatedTime)
      ..writeByte(18)
      ..write(obj.doDelivery)
      ..writeByte(19)
      ..write(obj.tripLoadingBayDryName)
      ..writeByte(20)
      ..write(obj.tripLoadingBayFrozenName)
      ..writeByte(21)
      ..write(obj.stopId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ItemsListAdapter extends TypeAdapter<ItemsList> {
  @override
  final int typeId = 11;

  @override
  ItemsList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemsList(
      lineItemId: fields[0] as String,
      itemId: fields[1] as String,
      itemTrippedStatus: fields[2] as String,
      itemCode: fields[3] as String,
      itemName: fields[4] as String,
      quantity: fields[5] as String,
      lineSortedQty: fields[6] as String,
      uom: fields[7] as String,
      itemType: fields[8] as String,
      typeColor: fields[9] as String,
      stagingArea: fields[10] as String,
      packageTerms: fields[11] as String,
      catchWeightStatus: fields[12] as String,
      catchWeightInfo: fields[13] as String,
      itemSortedCatchWeightInfo: fields[14] as String,
      handledBy: (fields[15] as List).cast<HandledByForUpdateList>(),
      itemTrippedUnavailableReasonId: fields[16] as String,
      itemTrippedUnavailableReason: fields[17] as String,
      itemTrippedUnavailableRemarks: fields[18] as String,
      remarks: fields[19] as String,
      tripId: fields[20] as String,
      soId: fields[21] as String,
      isProgressStatus: fields[22] as bool,
      itemBatchesList: (fields[23] as List).cast<BatchesList>(),
      lineLoadedQty: fields[24] as String,
      itemLoadedUnavailableReasonId: fields[25] as String,
      itemLoadedUnavailableReason: fields[26] as String,
      itemLoadedUnavailableRemarks: fields[27] as String,
      itemLoadedStatus: fields[28] as String,
      itemLoadedCatchWeightInfo: fields[29] as String,
      itemPickedStatus: fields[30] as String,
      isCompleted: fields[31] as bool,
      invoiceId: fields[32] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ItemsList obj) {
    writer
      ..writeByte(33)
      ..writeByte(0)
      ..write(obj.lineItemId)
      ..writeByte(1)
      ..write(obj.itemId)
      ..writeByte(2)
      ..write(obj.itemTrippedStatus)
      ..writeByte(3)
      ..write(obj.itemCode)
      ..writeByte(4)
      ..write(obj.itemName)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.lineSortedQty)
      ..writeByte(7)
      ..write(obj.uom)
      ..writeByte(8)
      ..write(obj.itemType)
      ..writeByte(9)
      ..write(obj.typeColor)
      ..writeByte(10)
      ..write(obj.stagingArea)
      ..writeByte(11)
      ..write(obj.packageTerms)
      ..writeByte(12)
      ..write(obj.catchWeightStatus)
      ..writeByte(13)
      ..write(obj.catchWeightInfo)
      ..writeByte(14)
      ..write(obj.itemSortedCatchWeightInfo)
      ..writeByte(15)
      ..write(obj.handledBy)
      ..writeByte(16)
      ..write(obj.itemTrippedUnavailableReasonId)
      ..writeByte(17)
      ..write(obj.itemTrippedUnavailableReason)
      ..writeByte(18)
      ..write(obj.itemTrippedUnavailableRemarks)
      ..writeByte(19)
      ..write(obj.remarks)
      ..writeByte(20)
      ..write(obj.tripId)
      ..writeByte(21)
      ..write(obj.soId)
      ..writeByte(22)
      ..write(obj.isProgressStatus)
      ..writeByte(23)
      ..write(obj.itemBatchesList)
      ..writeByte(24)
      ..write(obj.lineLoadedQty)
      ..writeByte(25)
      ..write(obj.itemLoadedUnavailableReasonId)
      ..writeByte(26)
      ..write(obj.itemLoadedUnavailableReason)
      ..writeByte(27)
      ..write(obj.itemLoadedUnavailableRemarks)
      ..writeByte(28)
      ..write(obj.itemLoadedStatus)
      ..writeByte(29)
      ..write(obj.itemLoadedCatchWeightInfo)
      ..writeByte(30)
      ..write(obj.itemPickedStatus)
      ..writeByte(31)
      ..write(obj.isCompleted)
      ..writeByte(32)
      ..write(obj.invoiceId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemsListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BatchesListAdapter extends TypeAdapter<BatchesList> {
  @override
  final int typeId = 12;

  @override
  BatchesList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BatchesList(
      batchId: fields[0] as String,
      batchNum: fields[1] as String,
      stockType: fields[2] as String,
      quantity: fields[3] as String,
      batchSortedQty: fields[4] as String,
      expiryDate: fields[5] as String,
      tripId: fields[6] as String,
      soId: fields[7] as String,
      itemId: fields[8] as String,
      batchLoadedQty: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BatchesList obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.batchId)
      ..writeByte(1)
      ..write(obj.batchNum)
      ..writeByte(2)
      ..write(obj.stockType)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.batchSortedQty)
      ..writeByte(5)
      ..write(obj.expiryDate)
      ..writeByte(6)
      ..write(obj.tripId)
      ..writeByte(7)
      ..write(obj.soId)
      ..writeByte(8)
      ..write(obj.itemId)
      ..writeByte(9)
      ..write(obj.batchLoadedQty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BatchesListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HandledByForUpdateListAdapter
    extends TypeAdapter<HandledByForUpdateList> {
  @override
  final int typeId = 13;

  @override
  HandledByForUpdateList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HandledByForUpdateList(
      id: fields[0] as String,
      code: fields[1] as String,
      name: fields[2] as String,
      image: fields[3] as String,
      updatedItems: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HandledByForUpdateList obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.updatedItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HandledByForUpdateListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionInfoAdapter extends TypeAdapter<SessionInfo> {
  @override
  final int typeId = 14;

  @override
  SessionInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionInfo(
      isOpened: fields[0] as bool,
      id: fields[1] as String,
      pending: fields[2] as String,
      updated: fields[3] as String,
      partial: fields[4] as String,
      unavailable: fields[5] as String,
      sessionStartTimestamp: fields[6] as String,
      timeSpendSeconds: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SessionInfo obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.isOpened)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.pending)
      ..writeByte(3)
      ..write(obj.updated)
      ..writeByte(4)
      ..write(obj.partial)
      ..writeByte(5)
      ..write(obj.unavailable)
      ..writeByte(6)
      ..write(obj.sessionStartTimestamp)
      ..writeByte(7)
      ..write(obj.timeSpendSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UnavailableReasonAdapter extends TypeAdapter<UnavailableReason> {
  @override
  final int typeId = 15;

  @override
  UnavailableReason read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnavailableReason(
      id: fields[0] as String,
      code: fields[1] as String,
      description: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UnavailableReason obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnavailableReasonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PartialItemsListAdapter extends TypeAdapter<PartialItemsList> {
  @override
  final int typeId = 16;

  @override
  PartialItemsList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartialItemsList(
      lineItemId: fields[0] as String,
      itemId: fields[1] as String,
      itemTrippedStatus: fields[2] as String,
      itemCode: fields[3] as String,
      itemName: fields[4] as String,
      quantity: fields[5] as String,
      lineSortedQty: fields[6] as String,
      uom: fields[7] as String,
      itemType: fields[8] as String,
      typeColor: fields[9] as String,
      stagingArea: fields[10] as String,
      packageTerms: fields[11] as String,
      catchWeightStatus: fields[12] as String,
      catchWeightInfo: fields[13] as String,
      itemSortedCatchWeightInfo: fields[14] as String,
      handledBy: (fields[15] as List).cast<HandledByForUpdateList>(),
      itemTrippedUnavailableReasonId: fields[16] as String,
      itemTrippedUnavailableReason: fields[17] as String,
      itemTrippedUnavailableRemarks: fields[18] as String,
      remarks: fields[19] as String,
      tripId: fields[20] as String,
      soId: fields[21] as String,
      isProgressStatus: fields[22] as bool,
      itemBatchesList: (fields[23] as List).cast<BatchesList>(),
      lineLoadedQty: fields[24] as String,
      itemLoadedUnavailableReasonId: fields[25] as String,
      itemLoadedUnavailableReason: fields[26] as String,
      itemLoadedUnavailableRemarks: fields[27] as String,
      itemLoadedStatus: fields[28] as String,
      itemLoadedCatchWeightInfo: fields[29] as String,
      itemPickedStatus: fields[30] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PartialItemsList obj) {
    writer
      ..writeByte(31)
      ..writeByte(0)
      ..write(obj.lineItemId)
      ..writeByte(1)
      ..write(obj.itemId)
      ..writeByte(2)
      ..write(obj.itemTrippedStatus)
      ..writeByte(3)
      ..write(obj.itemCode)
      ..writeByte(4)
      ..write(obj.itemName)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.lineSortedQty)
      ..writeByte(7)
      ..write(obj.uom)
      ..writeByte(8)
      ..write(obj.itemType)
      ..writeByte(9)
      ..write(obj.typeColor)
      ..writeByte(10)
      ..write(obj.stagingArea)
      ..writeByte(11)
      ..write(obj.packageTerms)
      ..writeByte(12)
      ..write(obj.catchWeightStatus)
      ..writeByte(13)
      ..write(obj.catchWeightInfo)
      ..writeByte(14)
      ..write(obj.itemSortedCatchWeightInfo)
      ..writeByte(15)
      ..write(obj.handledBy)
      ..writeByte(16)
      ..write(obj.itemTrippedUnavailableReasonId)
      ..writeByte(17)
      ..write(obj.itemTrippedUnavailableReason)
      ..writeByte(18)
      ..write(obj.itemTrippedUnavailableRemarks)
      ..writeByte(19)
      ..write(obj.remarks)
      ..writeByte(20)
      ..write(obj.tripId)
      ..writeByte(21)
      ..write(obj.soId)
      ..writeByte(22)
      ..write(obj.isProgressStatus)
      ..writeByte(23)
      ..write(obj.itemBatchesList)
      ..writeByte(24)
      ..write(obj.lineLoadedQty)
      ..writeByte(25)
      ..write(obj.itemLoadedUnavailableReasonId)
      ..writeByte(26)
      ..write(obj.itemLoadedUnavailableReason)
      ..writeByte(27)
      ..write(obj.itemLoadedUnavailableRemarks)
      ..writeByte(28)
      ..write(obj.itemLoadedStatus)
      ..writeByte(29)
      ..write(obj.itemLoadedCatchWeightInfo)
      ..writeByte(30)
      ..write(obj.itemPickedStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartialItemsListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocalTempDataListAdapter extends TypeAdapter<LocalTempDataList> {
  @override
  final int typeId = 17;

  @override
  LocalTempDataList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalTempDataList(
      queryData: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalTempDataList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.queryData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalTempDataListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
