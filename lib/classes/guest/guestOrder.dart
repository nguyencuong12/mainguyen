class GuestOrder {
  String? guestName;
  String? phoneNumber;
  String? address;
  String? id;

  GuestOrder({this.guestName, this.phoneNumber, this.address, this.id});
  @override
  String toString() => "Guest Name:$guestName";
}
