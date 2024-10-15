import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentInfoService {
  static const String _baseUrl =
      'https://5218-122-161-242-121.ngrok-free.app/api/PrintBooking';
  static const String _apiKey = 'b6daab40b04e';

  static Future<Map<String, dynamic>?> fetchPaymentInfo(
      String bookingId) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': _apiKey,
        },
        body: jsonEncode({
          'BookingID': bookingId,
          'Key': _apiKey,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to load payment info');
      }
    } catch (e) {
      throw Exception("Failed to fetch payment info. Error: $e");
    }
  }
}
