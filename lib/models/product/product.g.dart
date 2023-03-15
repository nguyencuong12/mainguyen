// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 1;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      distributor: fields[0] as String,
      productName: fields[1] as String,
      imageProduct: fields[2] as Uint8List,
      price: fields[3] as int,
      amount: fields[4] as double,
      location: fields[5] as String,
      type: fields[6] as ProductEnumHive,
      id: fields[7] as String,
      date: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.distributor)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.imageProduct)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductEnumHiveAdapter extends TypeAdapter<ProductEnumHive> {
  @override
  final int typeId = 2;

  @override
  ProductEnumHive read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProductEnumHive.kg;
      case 1:
        return ProductEnumHive.tree;
      case 2:
        return ProductEnumHive.bag;
      default:
        return ProductEnumHive.kg;
    }
  }

  @override
  void write(BinaryWriter writer, ProductEnumHive obj) {
    switch (obj) {
      case ProductEnumHive.kg:
        writer.writeByte(0);
        break;
      case ProductEnumHive.tree:
        writer.writeByte(1);
        break;
      case ProductEnumHive.bag:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductEnumHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
