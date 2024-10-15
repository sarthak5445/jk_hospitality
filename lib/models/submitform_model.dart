class ApiResponse {
  final String status;
  final String message;
  final BookingDetails? bookingDetails;

  ApiResponse({
    required this.status,
    required this.message,
    this.bookingDetails,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['rs'],
      message: json['pd']['Message'] ?? 'Success',
      bookingDetails:
          json['pd'] != null ? BookingDetails.fromJson(json['pd']) : null,
    );
  }
}

class BookingDetails {
  final String bookingId;
  final String guestHouseName;
  final String name;
  final String address;
  final String designation;
  final String department;
  final String phoneNo;
  final String emailId;

  final String checkInDate;
  final String checkOutDate;
  final String bookingPurpose;
  final String noOfRooms;

  // New fields
  final String idCardNo;
  final String isGovtEmployee;
  final String isGazettedEmp;
  final String docName;
  final String docExt;
  final String docContent;

  BookingDetails({
    required this.bookingId,
    required this.guestHouseName,
    required this.name,
    required this.address,
    required this.designation,
    required this.department,
    required this.phoneNo,
    required this.emailId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.bookingPurpose,
    required this.noOfRooms,

    // New parameters
    required this.idCardNo,
    required this.isGovtEmployee,
    required this.isGazettedEmp,
    required this.docName,
    required this.docExt,
    required this.docContent,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      bookingId: json['BookingID'],
      guestHouseName: json['GuestHouseName'],
      name: json['Name'],
      address: json['Address'],
      designation: json['Designation'],
      department: json['Department'],
      phoneNo: json['PhoneNo'],
      emailId: json['EmailId'],
      //roomTypeId: json['RoomTypeId'],
      checkInDate: json['CheckInDate'],
      checkOutDate: json['CheckoutDate'],
      bookingPurpose: json['BookingPurpose'],
      noOfRooms: json['Noofrooms'],

      // New fields
      idCardNo: json['idCardNo'] ?? '', // Provide a default value if null
      isGovtEmployee:
          json['isGovtEmployee'] ?? 'No', // Provide a default value if null
      isGazettedEmp:
          json['isGazettedEmp'] ?? 'No', // Provide a default value if null
      docName: json['DocName'] ?? '', // Provide a default value if null
      docExt: json['DocExt'] ?? '', // Provide a default value if null
      docContent: json['DocContent'] ?? '', // Provide a default value if null
    );
  }
}
