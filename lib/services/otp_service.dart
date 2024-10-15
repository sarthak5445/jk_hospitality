import 'dart:convert';
import 'package:http/http.dart' as http;

class OTPService {
  static Future<String> sendOTP(String mobileNumber) async {
    // Define the API URL
    const String url =
        'https://5218-122-161-242-121.ngrok-free.app/api/GetOTP'; // Replace with your API URL

    // Define the request body
    final Map<String, dynamic> requestBody = {
      "MobileNo": mobileNumber,
      "Key": "b6daab40b04e"
    };

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Parse the response
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['rs'] == 'S' && responseData['rc'] == 'PM0000') {
          // OTP successfully sent, return "success"
          return 'success';
        } else if (responseData['pd']['Message'].contains('Not Registered')) {
          // Return a custom message if the user is not registered
          return 'not_registered';
        } else {
          // Return the error message from the server
          return 'error';
        }
      } else {
        // Handle non-200 status codes
        return 'server_error';
      }
    } catch (e) {
      // Catch any errors and return failure
      print('Error sending OTP: $e');
      return 'error';
    }
  }

  static Future<bool> verifyOTP(String mobileNumber, String otp) async {
    const String url =
        'https://5218-122-161-242-121.ngrok-free.app/api/verifyOtp'; // Update with your URL
    final Map<String, dynamic> requestBody = {
      "MobileNo": mobileNumber,
      "OTP": otp,
      "Key": "b6daab40b04e"
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "b6daab40b04e",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['rs'] == 'S' && responseData['rc'] == 'PM0000';
      } else {
        throw Exception('Failed to verify OTP');
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      return false;
    }
  }
}
