import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  Future<List<dynamic>> fetchLocation(String userId) async {
    try {
      final response = await http.get(Uri.parse(
          "http://localhost:3000/api/v1/locations/$userId/date-range?startDate=2024-11-01&endDate=2024-12-08"));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load location data");
      }
    } catch (error) {
      print("Error fetching location: $error");
      rethrow;
    }
  }
}
