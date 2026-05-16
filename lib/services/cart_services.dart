import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static const String baseUrl =
      'https://medconnect-one-pi.vercel.app/api/api';

  Future<Map<String, dynamic>> addToCart({
    required int productId,
    int quantity = 1,
    String type = "sale",
    String? token,
  }) async {
     final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final url = Uri.parse('$baseUrl/v1/cart/add/$productId');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "quantity": quantity,
        "type": type,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      return {
        'success': false,
        'message': jsonDecode(response.body)['message'] ?? 'Unauthorized. Please log in.',
      };
    } else if (response.statusCode == 422) {
      return {
        'success': false,
        'error': jsonDecode(response.body)['error'] ?? 'Invalid request data.',
      };
    } else {
      throw Exception('Failed to add to cart: ${response.body}');
    }
  }
  
  Future<List<dynamic>> getCartItems()
    
  async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/v1/cart/show'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    print('Reponse Cart body: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('data: $data');
      print('message: ${data['message']}');
      return data['data'];
       // ده اللي فيه المنتجات
    } else {
      throw Exception('message: ${response.body}');
    }
  }
  Future<Map<String, dynamic>> updateCart({
  required int cartId,
  required int quantity,
  String? token,
}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
  final url = Uri.parse('$baseUrl/v1/cart/update/$cartId');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      "quantity": quantity,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('message: ${response.body}');
  }
}
Future<void> deleteCartItem({
  required int cartId,
  String? token,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final savedToken = prefs.getString('auth_token');

  final response = await http.delete(
    Uri.parse('$baseUrl/v1/cart/delete/$cartId'),
    headers: {
      'Content-Type': 'application/json',
      if (savedToken != null) 'Authorization': 'Bearer $savedToken',
    },
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    print('Deleted successfully: ${data['message']}');
  } else {
    throw Exception('Delete failed: ${data['message']}');
  }
}
}