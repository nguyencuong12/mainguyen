import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mainguyen/models/product/product.dart';

class SellProduct {
  String id;
  double amount;
  ProductEnumHive type;
  int price;
  Uint8List image;
  String productName;

  SellProduct(
      {required this.id,
      required this.amount,
      required this.type,
      required this.price,
      required this.image,
      required this.productName});
  @override
  String toString() {
    // TODO: implement toString
    return "ID:$id";
  }
}
