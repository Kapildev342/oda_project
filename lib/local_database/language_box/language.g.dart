// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LanguageDataAdapter extends TypeAdapter<LanguageData> {
  @override
  final int typeId = 7;

  @override
  LanguageData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LanguageData(
      languageList: (fields[0] as List).cast<LanguageListModel>(),
      languageValueString: (fields[1] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, LanguageData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.languageList)
      ..writeByte(1)
      ..write(obj.languageValueString);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LanguageListModelAdapter extends TypeAdapter<LanguageListModel> {
  @override
  final int typeId = 8;

  @override
  LanguageListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LanguageListModel(
      code: fields[0] as String,
      name: fields[1] as String,
      isDefault: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LanguageListModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
