import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  static const String baseUrl = 'https://api.ppatq-rf.id/api';
  static Future<Map<String, String>> _getHeaders({bool withAuth = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    return {
      'Accept': 'application/json', 
      'Content-Type': 'application/json',
      if (withAuth && token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(String endpoint, {bool withAuth = true}) async {
    final headers = await _getHeaders(withAuth: withAuth);
    final url = Uri.parse('$baseUrl$endpoint');

    final response = await http.get(url, headers: headers);
    return response;
  }

  static Future<http.Response> post(String endpoint, dynamic body, {bool withAuth = true}) async {
    final headers = await _getHeaders(withAuth: withAuth);
    final url = Uri.parse('$baseUrl$endpoint');

    final response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  
  static Future<http.Response> put(String endpoint, dynamic body, {bool withAuth = true}) async {
    final headers = await _getHeaders(withAuth: withAuth);
    final url = Uri.parse('$baseUrl$endpoint');

    final response = await http.put(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> delete(String endpoint, {bool withAuth = true}) async {
    final headers = await _getHeaders(withAuth: withAuth);
    final url = Uri.parse('$baseUrl$endpoint');

    final response = await http.delete(url, headers: headers);
    return response;
  }
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('idUser');
  }
}
