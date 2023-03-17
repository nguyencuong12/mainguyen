// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guestModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GuestModelAdapter extends TypeAdapter<GuestModel> {
  @override
  final int typeId = 7;

  @override
  GuestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GuestModel(
      orderedID: fields[0] as String?,
      guestName: fields[1] as String,
      guestPhoneNumber: fields[2] as String,
      avatar: fields[3] as Uint8List?,
      guestAddress: fields[4] as String?,
      guestType: fields[5] as GuestTypeEnum,
    );
  }

  @override
  void write(BinaryWriter writer, GuestModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.orderedID)
      ..writeByte(1)
      ..write(obj.guestName)
      ..writeByte(2)
      ..write(obj.guestPhoneNumber)
      ..writeByte(3)
      ..write(obj.avatar)
      ..writeByte(4)
      ..write(obj.guestAddress)
      ..writeByte(5)
      ..write(obj.guestType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GuestTypeEnumAdapter extends TypeAdapter<GuestTypeEnum> {
  @override
  final int typeId = 8;

  @override
  GuestTypeEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GuestTypeEnum.dearCustomer;
      case 1:
        return GuestTypeEnum.guestNormal;
      case 2:
        return GuestTypeEnum.vip;
      default:
        return GuestTypeEnum.dearCustomer;
    }
  }

  @override
  void write(BinaryWriter writer, GuestTypeEnum obj) {
    switch (obj) {
      case GuestTypeEnum.dearCustomer:
        writer.writeByte(0);
        break;
      case GuestTypeEnum.guestNormal:
        writer.writeByte(1);
        break;
      case GuestTypeEnum.vip:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuestTypeEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
