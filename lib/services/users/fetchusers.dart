import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchUsers {
  static const String baseUrl = 'http://192.168.18.213:8080/serviceapi';

  static Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    try {
      final requestData = {
        'username': username,
        'password': password,
      };

      print('Request Data: $requestData');

      final response = await http.post(
        Uri.parse('$baseUrl/usersapi.php?login'),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to login. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Exception during login: $e');
      throw Exception('Failed to login');
    }
  }

  static Future<Map<String, dynamic>> addUser(
      String nama, String alamat, String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/usersapi.php'),
        body: {
          'nama': nama,
          'alamat': alamat,
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to add user. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to add user');
      }
    } catch (e) {
      print('Exception during add user: $e');
      throw Exception('Failed to add user');
    }
  }
}
