class BookingPurpose {
  final int id;
  final String bookingPurpose;

  BookingPurpose({required this.id, required this.bookingPurpose});

  factory BookingPurpose.fromJson(Map<String, dynamic> json) {
    return BookingPurpose(
      id: json['ID'],
      bookingPurpose: json['BookingPurpose'],
    );
  }
}
