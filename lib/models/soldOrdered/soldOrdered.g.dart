// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soldOrdered.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderProductDescriptionAdapter
    extends TypeAdapter<OrderProductDescription> {
  @override
  final int typeId = 3;

  @override
  OrderProductDescription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderProductDescription(
      id: fields[0] as String,
      amount: fields[1] as double,
      type: fields[2] as ProductEnumHive,
      price: fields[3] as int,
      productName: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OrderProductDescription obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.productName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderProductDescriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SoldOrderedModelAdapter extends TypeAdapter<SoldOrderedModel> {
  @override
  final int typeId = 4;

  @override
  SoldOrderedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoldOrderedModel(
      image: fields[0] as Uint8List,
      guestOrder: fields[1] as String,
      guestPhoneNumber: fields[2] as String?,
      guestAddress: fields[3] as String?,
      soldOrdered: (fields[4] as List).cast<OrderProductDescription>(),
      id: fields[5] as String,
      idGuestOrder: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SoldOrderedModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.guestOrder)
      ..writeByte(2)
      ..write(obj.guestPhoneNumber)
      ..writeByte(3)
      ..write(obj.guestAddress)
      ..writeByte(4)
      ..write(obj.soldOrdered)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.idGuestOrder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoldOrderedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
