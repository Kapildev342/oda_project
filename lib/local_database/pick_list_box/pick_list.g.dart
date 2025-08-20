// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pick_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PickListMainResponseAdapter extends TypeAdapter<PickListMainResponse> {
  @override
  final int typeId = 18;

  @override
  PickListMainResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PickListMainResponse(
      picklist: (fields[0] as List).cast<PicklistItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, PickListMainResponse obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.picklist);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PickListMainResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PicklistItemAdapter extends TypeAdapter<PicklistItem> {
  @override
  final int typeId = 19;

  @override
  PicklistItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PicklistItem(
      id: fields[0] as String,
      picklistNumber: fields[1] as String,
      route: fields[2] as String,
      status: fields[3] as String,
      deliveryArea: fields[4] as String,
      orderType: fields[5] as String,
      inProgress: fields[6] as bool,
      statusColor: fields[7] as String,
      statusBGColor: fields[8] as String,
      created: fields[9] as String,
      createdDate: fields[10] as String,
      createdTime: fields[11] as String,
      completed: fields[12] as String,
      completedDate: fields[13] as String,
      completedTime: fields[14] as String,
      quantity: fields[15] as String,
      pickedQty: fields[16] as String,
      handledBy: (fields[17] as List).cast<HandledByPickList>(),
      disputeStatus: fields[18] as bool,
      itemsType: fields[19] as String,
      itemsColor: fields[20] as String,
      itemLocation: fields[21] as String,
      soNum: (fields[22] as List).cast<String>(),
      soType: (fields[23] as List).cast<String>(),
      businessDate: fields[24] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PicklistItem obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.picklistNumber)
      ..writeByte(2)
      ..write(obj.route)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.deliveryArea)
      ..writeByte(5)
      ..write(obj.orderType)
      ..writeByte(6)
      ..write(obj.inProgress)
      ..writeByte(7)
      ..write(obj.statusColor)
      ..writeByte(8)
      ..write(obj.statusBGColor)
      ..writeByte(9)
      ..write(obj.created)
      ..writeByte(10)
      ..write(obj.createdDate)
      ..writeByte(11)
      ..write(obj.createdTime)
      ..writeByte(12)
      ..write(obj.completed)
      ..writeByte(13)
      ..write(obj.completedDate)
      ..writeByte(14)
      ..write(obj.completedTime)
      ..writeByte(15)
      ..write(obj.quantity)
      ..writeByte(16)
      ..write(obj.pickedQty)
      ..writeByte(17)
      ..write(obj.handledBy)
      ..writeByte(18)
      ..write(obj.disputeStatus)
      ..writeByte(19)
      ..write(obj.itemsType)
      ..writeByte(20)
      ..write(obj.itemsColor)
      ..writeByte(21)
      ..write(obj.itemLocation)
      ..writeByte(22)
      ..write(obj.soNum)
      ..writeByte(23)
      ..write(obj.soType)
      ..writeByte(24)
      ..write(obj.businessDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PicklistItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HandledByPickListAdapter extends TypeAdapter<HandledByPickList> {
  @override
  final int typeId = 20;

  @override
  HandledByPickList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HandledByPickList(
      id: fields[0] as String,
      code: fields[1] as String,
      name: fields[2] as String,
      image: fields[3] as String,
      pickedItems: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HandledByPickList obj) {
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
      ..write(obj.pickedItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HandledByPickListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PickListDetailsResponseAdapter
    extends TypeAdapter<PickListDetailsResponse> {
  @override
  final int typeId = 21;

  @override
  PickListDetailsResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PickListDetailsResponse(
      picklistId: fields[0] as String,
      picklistNum: fields[1] as String,
      route: fields[2] as String,
      picklistStatus: fields[3] as String,
      picklistTime: fields[4] as String,
      totalItems: fields[5] as String,
      pickedItems: fields[6] as String,
      isReadyToMoveComplete: fields[7] as bool,
      isCompleted: fields[8] as bool,
      handledBy: (fields[9] as List).cast<HandledByPickList>(),
      yetToPick: fields[10] as int,
      picked: fields[11] as int,
      partial: fields[12] as int,
      unavailable: fields[13] as int,
      items: (fields[14] as List).cast<PickListDetailsItem>(),
      unavailableReasons: (fields[15] as List).cast<UnavailableReason>(),
      completeReasons: (fields[16] as List).cast<UnavailableReason>(),
      alternateItems: (fields[17] as List).cast<FilterOptionsResponse>(),
      locationFilter: fields[18] as Filter,
      sessionInfo: fields[19] as PickListSessionInfo,
      timelineInfo: (fields[20] as List).cast<TimelineInfo>(),
    );
  }

  @override
  void write(BinaryWriter writer, PickListDetailsResponse obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.picklistId)
      ..writeByte(1)
      ..write(obj.picklistNum)
      ..writeByte(2)
      ..write(obj.route)
      ..writeByte(3)
      ..write(obj.picklistStatus)
      ..writeByte(4)
      ..write(obj.picklistTime)
      ..writeByte(5)
      ..write(obj.totalItems)
      ..writeByte(6)
      ..write(obj.pickedItems)
      ..writeByte(7)
      ..write(obj.isReadyToMoveComplete)
      ..writeByte(8)
      ..write(obj.isCompleted)
      ..writeByte(9)
      ..write(obj.handledBy)
      ..writeByte(10)
      ..write(obj.yetToPick)
      ..writeByte(11)
      ..write(obj.picked)
      ..writeByte(12)
      ..write(obj.partial)
      ..writeByte(13)
      ..write(obj.unavailable)
      ..writeByte(14)
      ..write(obj.items)
      ..writeByte(15)
      ..write(obj.unavailableReasons)
      ..writeByte(16)
      ..write(obj.completeReasons)
      ..writeByte(17)
      ..write(obj.alternateItems)
      ..writeByte(18)
      ..write(obj.locationFilter)
      ..writeByte(19)
      ..write(obj.sessionInfo)
      ..writeByte(20)
      ..write(obj.timelineInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PickListDetailsResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PickListDetailsItemAdapter extends TypeAdapter<PickListDetailsItem> {
  @override
  final int typeId = 22;

  @override
  PickListDetailsItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PickListDetailsItem(
      id: fields[0] as String,
      itemId: fields[1] as String,
      picklistNum: fields[2] as String,
      status: fields[3] as String,
      itemCode: fields[4] as String,
      itemName: fields[5] as String,
      quantity: fields[6] as String,
      pickedQty: fields[7] as String,
      uom: fields[8] as String,
      itemType: fields[9] as String,
      typeColor: fields[10] as String,
      floor: fields[11] as String,
      room: fields[12] as String,
      zone: fields[13] as String,
      stagingArea: fields[14] as String,
      isProgressStatus: fields[15] as bool,
      packageTerms: fields[16] as String,
      catchWeightStatus: fields[17] as String,
      catchWeightInfo: (fields[18] as List).cast<CatchWeightItem>(),
      catchWeightInfoForList: (fields[19] as List).cast<String>(),
      catchWeightInfoPicked: (fields[20] as List).cast<CatchWeightItem>(),
      handledBy: (fields[21] as List).cast<HandledByPickList>(),
      locationDisputeInfo: fields[22] as dynamic,
      unavailableReason: fields[23] as String,
      alternativeItemName: fields[24] as String,
      alternativeItemCode: fields[25] as String,
      batchesList: (fields[26] as List).cast<PickListBatchesList>(),
      allowUndo: fields[27] as bool,
      soNum: fields[28] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PickListDetailsItem obj) {
    writer
      ..writeByte(29)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.itemId)
      ..writeByte(2)
      ..write(obj.picklistNum)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.itemCode)
      ..writeByte(5)
      ..write(obj.itemName)
      ..writeByte(6)
      ..write(obj.quantity)
      ..writeByte(7)
      ..write(obj.pickedQty)
      ..writeByte(8)
      ..write(obj.uom)
      ..writeByte(9)
      ..write(obj.itemType)
      ..writeByte(10)
      ..write(obj.typeColor)
      ..writeByte(11)
      ..write(obj.floor)
      ..writeByte(12)
      ..write(obj.room)
      ..writeByte(13)
      ..write(obj.zone)
      ..writeByte(14)
      ..write(obj.stagingArea)
      ..writeByte(15)
      ..write(obj.isProgressStatus)
      ..writeByte(16)
      ..write(obj.packageTerms)
      ..writeByte(17)
      ..write(obj.catchWeightStatus)
      ..writeByte(18)
      ..write(obj.catchWeightInfo)
      ..writeByte(19)
      ..write(obj.catchWeightInfoForList)
      ..writeByte(20)
      ..write(obj.catchWeightInfoPicked)
      ..writeByte(21)
      ..write(obj.handledBy)
      ..writeByte(22)
      ..write(obj.locationDisputeInfo)
      ..writeByte(23)
      ..write(obj.unavailableReason)
      ..writeByte(24)
      ..write(obj.alternativeItemName)
      ..writeByte(25)
      ..write(obj.alternativeItemCode)
      ..writeByte(26)
      ..write(obj.batchesList)
      ..writeByte(27)
      ..write(obj.allowUndo)
      ..writeByte(28)
      ..write(obj.soNum);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PickListDetailsItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PickListBatchesListAdapter extends TypeAdapter<PickListBatchesList> {
  @override
  final int typeId = 23;

  @override
  PickListBatchesList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PickListBatchesList(
      id: fields[0] as String,
      itemId: fields[1] as String,
      batchNum: fields[2] as String,
      expiryDate: fields[3] as String,
      stockType: fields[4] as String,
      quantity: fields[5] as String,
      pickedQty: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PickListBatchesList obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.itemId)
      ..writeByte(2)
      ..write(obj.batchNum)
      ..writeByte(3)
      ..write(obj.expiryDate)
      ..writeByte(4)
      ..write(obj.stockType)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.pickedQty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PickListBatchesListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CatchWeightItemAdapter extends TypeAdapter<CatchWeightItem> {
  @override
  final int typeId = 24;

  @override
  CatchWeightItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CatchWeightItem(
      data: fields[0] as String,
      isSelected: fields[1] as bool,
      isSelectedAlready: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CatchWeightItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.isSelected)
      ..writeByte(2)
      ..write(obj.isSelectedAlready);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatchWeightItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocationDisputeInfoAdapter extends TypeAdapter<LocationDisputeInfo> {
  @override
  final int typeId = 25;

  @override
  LocationDisputeInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationDisputeInfo(
      updatedOn: fields[0] as String,
      floor: fields[1] as String,
      room: fields[2] as String,
      zone: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocationDisputeInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.updatedOn)
      ..writeByte(1)
      ..write(obj.floor)
      ..writeByte(2)
      ..write(obj.room)
      ..writeByte(3)
      ..write(obj.zone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationDisputeInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PickListSessionInfoAdapter extends TypeAdapter<PickListSessionInfo> {
  @override
  final int typeId = 26;

  @override
  PickListSessionInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PickListSessionInfo(
      isOpened: fields[0] as bool,
      id: fields[1] as String,
      pending: fields[2] as String,
      picked: fields[3] as String,
      partial: fields[4] as String,
      unavailable: fields[5] as String,
      sessionStartTimestamp: fields[6] as String,
      timeSpendSeconds: fields[7] as String,
      partialIdsList: (fields[8] as List).cast<String>(),
      pendingList: (fields[9] as List).cast<PickListDetailsItem>(),
      pickedList: (fields[10] as List).cast<PickListDetailsItem>(),
      partialList: (fields[11] as List).cast<PickListDetailsItem>(),
      unavailableList: (fields[12] as List).cast<PickListDetailsItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, PickListSessionInfo obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.isOpened)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.pending)
      ..writeByte(3)
      ..write(obj.picked)
      ..writeByte(4)
      ..write(obj.partial)
      ..writeByte(5)
      ..write(obj.unavailable)
      ..writeByte(6)
      ..write(obj.sessionStartTimestamp)
      ..writeByte(7)
      ..write(obj.timeSpendSeconds)
      ..writeByte(8)
      ..write(obj.partialIdsList)
      ..writeByte(9)
      ..write(obj.pendingList)
      ..writeByte(10)
      ..write(obj.pickedList)
      ..writeByte(11)
      ..write(obj.partialList)
      ..writeByte(12)
      ..write(obj.unavailableList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PickListSessionInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimelineInfoAdapter extends TypeAdapter<TimelineInfo> {
  @override
  final int typeId = 27;

  @override
  TimelineInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimelineInfo(
      id: fields[0] as String,
      description: fields[1] as String,
      time: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TimelineInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimelineInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FilterAdapter extends TypeAdapter<Filter> {
  @override
  final int typeId = 28;

  @override
  Filter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Filter(
      type: fields[0] as String,
      label: fields[1] as String,
      selection: fields[2] as String,
      options: (fields[3] as List).cast<FilterOptionsResponse>(),
      getOptions: fields[4] as bool,
      status: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Filter obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.selection)
      ..writeByte(3)
      ..write(obj.options)
      ..writeByte(4)
      ..write(obj.getOptions)
      ..writeByte(5)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FloorLocationAdapter extends TypeAdapter<FloorLocation> {
  @override
  final int typeId = 29;

  @override
  FloorLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FloorLocation(
      id: fields[0] as String,
      label: fields[1] as String,
      type: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FloorLocation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FloorLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StagingLocationAdapter extends TypeAdapter<StagingLocation> {
  @override
  final int typeId = 30;

  @override
  StagingLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StagingLocation(
      id: fields[0] as String,
      label: fields[1] as String,
      type: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StagingLocation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StagingLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PartialPickListDetailsItemAdapter
    extends TypeAdapter<PartialPickListDetailsItem> {
  @override
  final int typeId = 31;

  @override
  PartialPickListDetailsItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartialPickListDetailsItem(
      id: fields[0] as String,
      itemId: fields[1] as String,
      picklistNum: fields[2] as String,
      status: fields[3] as String,
      itemCode: fields[4] as String,
      itemName: fields[5] as String,
      quantity: fields[6] as String,
      pickedQty: fields[7] as String,
      uom: fields[8] as String,
      itemType: fields[9] as String,
      typeColor: fields[10] as String,
      floor: fields[11] as String,
      room: fields[12] as String,
      zone: fields[13] as String,
      stagingArea: fields[14] as String,
      isProgressStatus: fields[15] as bool,
      packageTerms: fields[16] as String,
      catchWeightStatus: fields[17] as String,
      catchWeightInfo: (fields[18] as List).cast<CatchWeightItem>(),
      catchWeightInfoForList: (fields[19] as List).cast<String>(),
      catchWeightInfoPicked: (fields[20] as List).cast<CatchWeightItem>(),
      handledBy: (fields[21] as List).cast<HandledByPickList>(),
      locationDisputeInfo: fields[22] as dynamic,
      unavailableReason: fields[23] as String,
      alternativeItemName: fields[24] as String,
      alternativeItemCode: fields[25] as String,
      batchesList: (fields[26] as List).cast<PickListBatchesList>(),
      allowUndo: fields[27] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PartialPickListDetailsItem obj) {
    writer
      ..writeByte(28)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.itemId)
      ..writeByte(2)
      ..write(obj.picklistNum)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.itemCode)
      ..writeByte(5)
      ..write(obj.itemName)
      ..writeByte(6)
      ..write(obj.quantity)
      ..writeByte(7)
      ..write(obj.pickedQty)
      ..writeByte(8)
      ..write(obj.uom)
      ..writeByte(9)
      ..write(obj.itemType)
      ..writeByte(10)
      ..write(obj.typeColor)
      ..writeByte(11)
      ..write(obj.floor)
      ..writeByte(12)
      ..write(obj.room)
      ..writeByte(13)
      ..write(obj.zone)
      ..writeByte(14)
      ..write(obj.stagingArea)
      ..writeByte(15)
      ..write(obj.isProgressStatus)
      ..writeByte(16)
      ..write(obj.packageTerms)
      ..writeByte(17)
      ..write(obj.catchWeightStatus)
      ..writeByte(18)
      ..write(obj.catchWeightInfo)
      ..writeByte(19)
      ..write(obj.catchWeightInfoForList)
      ..writeByte(20)
      ..write(obj.catchWeightInfoPicked)
      ..writeByte(21)
      ..write(obj.handledBy)
      ..writeByte(22)
      ..write(obj.locationDisputeInfo)
      ..writeByte(23)
      ..write(obj.unavailableReason)
      ..writeByte(24)
      ..write(obj.alternativeItemName)
      ..writeByte(25)
      ..write(obj.alternativeItemCode)
      ..writeByte(26)
      ..write(obj.batchesList)
      ..writeByte(27)
      ..write(obj.allowUndo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartialPickListDetailsItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocalTempDataPickListAdapter extends TypeAdapter<LocalTempDataPickList> {
  @override
  final int typeId = 32;

  @override
  LocalTempDataPickList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalTempDataPickList(
      queryData: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalTempDataPickList obj) {
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
      other is LocalTempDataPickListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class S3Adapter extends TypeAdapter<S3> {
  @override
  final int typeId = 33;

  @override
  S3 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return S3(
      bucketName: fields[0] as String,
      accessKey: fields[1] as String,
      secretKey: fields[2] as String,
      region: fields[3] as String,
      url: fields[4] as String,
      path: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, S3 obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.bucketName)
      ..writeByte(1)
      ..write(obj.accessKey)
      ..writeByte(2)
      ..write(obj.secretKey)
      ..writeByte(3)
      ..write(obj.region)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is S3Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InvoiceDataAdapter extends TypeAdapter<InvoiceData> {
  @override
  final int typeId = 34;

  @override
  InvoiceData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceData(
      invoiceId: fields[0] as String,
      invoiceNum: fields[1] as String,
      invoiceDate: fields[2] as String,
      invoiceTotal: fields[3] as String,
      invoiceItems: fields[4] as String,
      tripId: fields[5] as String,
      soId: fields[6] as String,
      itemId: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.invoiceId)
      ..writeByte(1)
      ..write(obj.invoiceNum)
      ..writeByte(2)
      ..write(obj.invoiceDate)
      ..writeByte(3)
      ..write(obj.invoiceTotal)
      ..writeByte(4)
      ..write(obj.invoiceItems)
      ..writeByte(5)
      ..write(obj.tripId)
      ..writeByte(6)
      ..write(obj.soId)
      ..writeByte(7)
      ..write(obj.itemId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LoadingLocationAdapter extends TypeAdapter<LoadingLocation> {
  @override
  final int typeId = 35;

  @override
  LoadingLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoadingLocation(
      id: fields[0] as String,
      label: fields[1] as String,
      type: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LoadingLocation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
