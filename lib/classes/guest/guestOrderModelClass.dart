import 'dart:typed_data';

import 'package:mainguyen/models/guest/guestModel.dart';

class GuestOrderModelClass {
  String? guestName;
  String? phoneNumber;
  String? address;
  String guestID;
  Uint8List? avatar;
  GuestTypeEnum type;

  GuestOrderModelClass(
      {this.guestName,
      this.phoneNumber,
      this.address,
      required this.guestID,
      required this.type,
      this.avatar});
  @override
  String toString() => "Guest Name:$guestName";
}
