import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/submitform_model.dart';

class SubmitFormService {
  static const String _baseUrl =
      'https://5218-122-161-242-121.ngrok-free.app/api/SaveBooking';
  static const String _apiKey = 'b6daab40b04e';

  Future<ApiResponse> submitBookingForm({
    required int guestHouseId,
    required String name,
    required String address,
    required String designation,
    required String department,
    required String idCardNo,
    required String isGovtEmployee,
    required String isGazettedEmployee,
    required String phoneNo,
    required String emailId,
    required String roomTypeId,
    required String checkInDate,
    required String checkOutDate,
    required String docName,
    required String docExt,
    required String docContent,
    required String bookingPurpose,
    required String bookingTypeId,
    required int noOfRooms,
  }) async {
    final url = Uri.parse('$_baseUrl/SaveBooking');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'GuestHouseId': guestHouseId.toString(),
        'Name': name,
        'Address': address,
        'Designation': designation,
        'Department': department,
        'idCardNo': idCardNo,
        'isGovtEmployee': isGovtEmployee,
        'isGazettedEmp': isGazettedEmployee,
        'PhoneNo': phoneNo,
        'EmailId': emailId,
        'RoomTypeId': roomTypeId,
        'CheckInDate': checkInDate,
        'CheckoutDate': checkOutDate,
        'DocName': docName,
        'DocExt': docExt,
        'DocContent': docContent.isNotEmpty ? docContent : "",
        'BookingPurpose': bookingPurpose,
        'BookingTypeId': bookingTypeId,
        'Noofrooms': noOfRooms.toString(),
        'Key': _apiKey,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['rs'] == 'S') {
        // print(jsonResponse);
        return ApiResponse.fromJson(jsonResponse);
      } else {
        return ApiResponse(
            status: 'Failure', message: jsonResponse['pd']['Message']);
      }
    } else {
      return ApiResponse(status: 'Error', message: 'Server error');
    }
    //  catch (e) {
    //   return ApiResponse(status: 'Error', message: e.toString());
    // }
  }
}
