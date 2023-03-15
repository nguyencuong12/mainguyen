import 'dart:typed_data';

import 'package:mainguyen/models/product/product.dart';

import '../../enum/product/productEnum.dart';

class ProductClass {
  String? distributor;
  String? productName;
  List<Uint8List>? imageProduct;
  int? price;
  double? amount;
  String? location;
  ProductEnum? type;
  ProductClass();
  @override
  String toString() {
    // TODO: implement toString
    return "Price:$price , Type:$type";
  }
}
