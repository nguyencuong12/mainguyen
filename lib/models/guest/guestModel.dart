import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'guestModel.g.dart';

@HiveType(typeId: 8)
enum GuestTypeEnum {
  @HiveField(0)
  dearCustomer,
  @HiveField(1)
  guestNormal,
  @HiveField(2)
  vip,
}

@HiveType(typeId: 7)
class GuestModel {
  GuestModel(
      {this.orderedID,
      required this.guestName,
      required this.guestPhoneNumber,
      this.avatar,
      this.guestAddress,
      required this.guestType});
  @HiveField(0)
  String? orderedID;
  @HiveField(1)
  String guestName;
  @HiveField(2)
  String guestPhoneNumber;
  @HiveField(3)
  Uint8List? avatar;
  @HiveField(4)
  String? guestAddress;
  @HiveField(5)
  GuestTypeEnum guestType;
  @override
  String toString() => "GuestName: $guestName";
  // @HiveField(3)
  // String? orderedID;
}
