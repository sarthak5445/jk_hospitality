class BookingType {
  final int id;
  final String bookingType;

  BookingType({required this.id, required this.bookingType});

  factory BookingType.fromJson(Map<String, dynamic> json) {
    return BookingType(
      id: json['ID'],
      bookingType: json['BookingType'],
    );
  }
}
