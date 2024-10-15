class BookingStatusModel {
  final String bookingID;
  final String bookingStatus;
  final String guestName;
  final String guestContactNo;
  final String guestHouse;
  final String roomType;
  final String bookingType;
  final String checkInDate;
  final String checkOutDate;
  final String noOfDays;
  final String designation;
  final String department;

  BookingStatusModel(
      {required this.bookingID,
      required this.bookingStatus,
      required this.guestName,
      required this.guestContactNo,
      required this.guestHouse,
      required this.roomType,
      required this.bookingType,
      required this.checkInDate,
      required this.checkOutDate,
      required this.noOfDays,
      required this.designation,
      required this.department});

  factory BookingStatusModel.fromJson(Map<String, dynamic> json) {
    return BookingStatusModel(
      bookingID: json['BookingID'] ?? 'N/A',
      bookingStatus: json['BookingStatus'] ?? 'N/A',
      guestName: json['GuestName'] ?? 'N/A',
      guestContactNo: json['GuestContactNo'] ?? 'N/A',
      guestHouse: json['GuestHouse'] ?? 'N/A',
      roomType: json['RoomType'] ?? 'N/A',
      bookingType: json['BookingType'] ?? 'N/A',
      checkInDate: json['CheckInDate'] ?? 'N/A',
      checkOutDate: json['CheckOutDate'] ?? 'N/A',
      noOfDays: json['NoofDays'] ?? 'N/A',
      designation: json['GovtEmpDesignation'] ?? 'N/A',
      department: json['GovtEmpDepartment'] ?? 'N/A',
    );
  }
}
