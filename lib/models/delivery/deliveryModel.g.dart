// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deliveryModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryModelAdapter extends TypeAdapter<DeliveryModel> {
  @override
  final int typeId = 6;

  @override
  DeliveryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliveryModel(
      phoneNumber: fields[0] as String,
      deliveryName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DeliveryModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.phoneNumber)
      ..writeByte(1)
      ..write(obj.deliveryName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
