import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:mainguyen/classes/sell/sellProductClass.dart';
import 'package:mainguyen/models/product/product.dart';
part 'soldOrdered.g.dart';

@HiveType(typeId: 3)
class OrderProductDescription {
  OrderProductDescription(
      {required this.id,
      required this.amount,
      required this.type,
      required this.price,
      required this.productName});
  @HiveField(0)
  String id;
  @HiveField(1)
  double amount;
  @HiveField(2)
  ProductEnumHive type;
  @HiveField(3)
  int price;
  @HiveField(4)
  String productName;
}

@HiveType(typeId: 4)
class SoldOrderedModel {
  SoldOrderedModel({
    required this.image,
    required this.guestOrder,
    this.guestPhoneNumber,
    this.guestAddress,
    required this.soldOrdered,
    required this.id,
    this.idGuestOrder,
  });

  @HiveField(0)
  Uint8List image;
  @HiveField(1)
  String guestOrder;
  @HiveField(2)
  String? guestPhoneNumber;
  @HiveField(3)
  String? guestAddress;
  @HiveField(4)
  List<OrderProductDescription> soldOrdered;
  @HiveField(5)
  String id;
  @HiveField(6)
  String? idGuestOrder;
  @override
  String toString() => "GUEST NAME: $guestOrder";
}
