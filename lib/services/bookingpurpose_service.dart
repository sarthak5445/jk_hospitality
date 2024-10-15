import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jk_hospitality/models/boookingpurpose_model.dart';

class BookingPurposeService {
  static const String _baseUrl =
      'https://5218-122-161-242-121.ngrok-free.app/api/GetBookingPurposeDetails';
  static const String _apiKey = 'b6daab40b04e';

  static Future<List<BookingPurpose>> fetchBookingPurpose() async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': _apiKey,
        },
        body: jsonEncode({
          'Key': _apiKey,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> bookingTypeList = data['pd']['BookingPurpose_List'];
        return bookingTypeList
            .map((json) => BookingPurpose.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load room types');
      }
    } catch (e) {
      throw Exception("Failed to fetch data. Error: $e");
    }
  }
}
