import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jk_hospitality/models/guesthouse_model.dart';

class GuesthouselistService {
  static Future<List<GuestHouse>> getGuestHousesList() async {
    const String url =
        'https://5218-122-161-242-121.ngrok-free.app/api/GetGuestHouseDetails';

    final Map<String, dynamic> requestBody = {"Key": "b6daab40b04e"};

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'b6daab40b04e',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["rs"] == "S" && data["pd"]["GuestHouse_Details"] != null) {
          final guestHouseList = data["pd"]["GuestHouse_Details"];
          return guestHouseList
              .map<GuestHouse>((json) => GuestHouse.fromJson(json))
              .toList();
        } else {
          throw Exception("No Guest House data found.");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch data. Error: $e");
    }
  }
}
