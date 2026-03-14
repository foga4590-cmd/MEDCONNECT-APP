import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://medconnect-one-pi.vercel.app/api/api';
  
  static String? _token;
  
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/v1/$role/login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      var data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        // تخزين التوكن
        if (data['data'] != null && data['data']['token'] != null) {
          await _saveToken(data['data']['token']);
        }
        
        return {
          'success': true,
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'Sign in is failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'خطأ في الاتصال: تأكد من اتصالك بالإنترنت',
      };
    }
  }

  Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  static String? get token => _token;
  static bool get isLoggedIn => _token != null;
}