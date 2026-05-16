import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/equipment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EquipmentApiService {
  static const String baseUrl = 'https://medconnect-one-pi.vercel.app';

 
  // ✅✅✅ الميثود الوحيدة اللي انت عايزها ✅✅✅
  static Future<List<EquipmentList>> getAllEquipmentLists() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('$baseUrl/api/api/v1/equipment-list/all-with-items'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> listsData = data['data'];
      print('Response Data: $data');
      return listsData.map((json) => EquipmentList.fromJson(json)).toList();
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}