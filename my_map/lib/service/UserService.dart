import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String apiUrl = "http://localhost:3000/api/v1/users";

  // Fetch data from API
  Future<List<dynamic>> users() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Parse JSON data
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }
}
