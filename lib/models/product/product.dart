import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 2)
enum ProductEnumHive {
  @HiveField(0)
  kg,
  @HiveField(1)
  tree,
  @HiveField(2)
  bag,
}

@HiveType(typeId: 1)
class Product {
  Product(
      {required this.distributor,
      required this.productName,
      required this.imageProduct,
      required this.price,
      required this.amount,
      required this.location,
      required this.type,
      required this.id,
      required this.date});
  @HiveField(0)
  String distributor;
  @HiveField(1)
  String productName;
  @HiveField(2)
  Uint8List imageProduct;
  @HiveField(3)
  int price;
  @HiveField(4)
  double amount;
  @HiveField(5)
  String location;
  @HiveField(6)
  ProductEnumHive type;
  @HiveField(7)
  String id;
  @HiveField(8)
  DateTime date;
  // @override
  String toString() {
    return productName;
  }
}
