class GuestOrder {
  String? guestName;
  String? phoneNumber;
  String? address;

  GuestOrder({this.guestName, this.phoneNumber, this.address});
  @override
  String toString() => "Guest Name:$guestName";
}
