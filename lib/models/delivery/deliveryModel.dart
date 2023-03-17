import 'package:hive/hive.dart';

part 'deliveryModel.g.dart';

@HiveType(typeId: 6)
class DeliveryModel {
  DeliveryModel({required this.phoneNumber, required this.deliveryName});
  @HiveField(0)
  String phoneNumber;
  @HiveField(1)
  String deliveryName;

  @override
  String toString() {
    // TODO: implement toString
    return "Người giao hàng $deliveryName";
  }
}
