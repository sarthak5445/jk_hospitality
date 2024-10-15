class GuestHouse {
  final int id;
  final String guestHouseName;
  final String address;

  GuestHouse({
    required this.id,
    required this.guestHouseName,
    required this.address,
  });

  factory GuestHouse.fromJson(Map<String, dynamic> json) {
    return GuestHouse(
      id: json['ID'],
      guestHouseName: json['GuestHouseName'],
      address: json['Address'],
    );
  }
}
