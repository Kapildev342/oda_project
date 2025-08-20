// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserResponseAdapter extends TypeAdapter<UserResponse> {
  @override
  final int typeId = 0;

  @override
  UserResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserResponse(
      loggedHeaders: fields[0] as HeadersLoggedData,
      bottomItemsList: (fields[1] as List).cast<String>(),
      sideItemsList: (fields[2] as List).cast<String>(),
      userProfile: fields[3] as UserProfile,
      profileNetworkImage: fields[4] as Uint8List,
      filterItemsListOptions: (fields[5] as List).cast<FilterOptionsResponse>(),
      filterCustomersOptions: (fields[6] as List).cast<FilterOptionsResponse>(),
      usersList: (fields[7] as List).cast<FilterOptionsResponse>(),
      s3: fields[8] as S3,
    );
  }

  @override
  void write(BinaryWriter writer, UserResponse obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.loggedHeaders)
      ..writeByte(1)
      ..write(obj.bottomItemsList)
      ..writeByte(2)
      ..write(obj.sideItemsList)
      ..writeByte(3)
      ..write(obj.userProfile)
      ..writeByte(4)
      ..write(obj.profileNetworkImage)
      ..writeByte(5)
      ..write(obj.filterItemsListOptions)
      ..writeByte(6)
      ..write(obj.filterCustomersOptions)
      ..writeByte(7)
      ..write(obj.usersList)
      ..writeByte(8)
      ..write(obj.s3);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HeadersLoggedDataAdapter extends TypeAdapter<HeadersLoggedData> {
  @override
  final int typeId = 1;

  @override
  HeadersLoggedData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HeadersLoggedData(
      authorization: fields[0] as String,
      deviceId: fields[1] as String,
      deviceType: fields[2] as String,
      deviceMaker: fields[3] as String,
      deviceModel: fields[4] as String,
      firmware: fields[5] as String,
      appVersion: fields[6] as String,
      lang: fields[7] as String,
      pushKey: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HeadersLoggedData obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.authorization)
      ..writeByte(1)
      ..write(obj.deviceId)
      ..writeByte(2)
      ..write(obj.deviceType)
      ..writeByte(3)
      ..write(obj.deviceMaker)
      ..writeByte(4)
      ..write(obj.deviceModel)
      ..writeByte(5)
      ..write(obj.firmware)
      ..writeByte(6)
      ..write(obj.appVersion)
      ..writeByte(7)
      ..write(obj.lang)
      ..writeByte(8)
      ..write(obj.pushKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeadersLoggedDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 2;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String,
      userName: fields[1] as String,
      employeeType: fields[2] as String,
      designation: fields[3] as String,
      langCode: fields[4] as String,
      image: fields[5] as String,
      superSalesName: fields[6] as String,
      superSalesPhone: fields[7] as String,
      rsmName: fields[8] as String,
      rsmPhone: fields[9] as String,
      data: (fields[10] as List).cast<Datum>(),
      userCode: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.employeeType)
      ..writeByte(3)
      ..write(obj.designation)
      ..writeByte(4)
      ..write(obj.langCode)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.superSalesName)
      ..writeByte(7)
      ..write(obj.superSalesPhone)
      ..writeByte(8)
      ..write(obj.rsmName)
      ..writeByte(9)
      ..write(obj.rsmPhone)
      ..writeByte(10)
      ..write(obj.data)
      ..writeByte(11)
      ..write(obj.userCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DatumAdapter extends TypeAdapter<Datum> {
  @override
  final int typeId = 3;

  @override
  Datum read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Datum(
      label: fields[0] as String,
      value: fields[1] as String,
      icon: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Datum obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FilterOptionsResponseAdapter extends TypeAdapter<FilterOptionsResponse> {
  @override
  final int typeId = 4;

  @override
  FilterOptionsResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FilterOptionsResponse(
      id: fields[0] as String,
      label: fields[1] as String,
      code: fields[2] as String,
      status: fields[3] as bool,
      image: fields[4] as String,
      room: (fields[5] as List).cast<Room>(),
    );
  }

  @override
  void write(BinaryWriter writer, FilterOptionsResponse obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.room);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterOptionsResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoomAdapter extends TypeAdapter<Room> {
  @override
  final int typeId = 5;

  @override
  Room read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Room(
      id: fields[0] as String,
      label: fields[1] as String,
      type: fields[2] as String,
      selection: fields[3] as String,
      status: fields[4] as bool,
      zone: (fields[5] as List).cast<Zone>(),
    );
  }

  @override
  void write(BinaryWriter writer, Room obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.selection)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.zone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ZoneAdapter extends TypeAdapter<Zone> {
  @override
  final int typeId = 6;

  @override
  Zone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Zone(
      id: fields[0] as String,
      label: fields[1] as String,
      type: fields[2] as String,
      status: fields[3] as bool,
      selection: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Zone obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.selection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
