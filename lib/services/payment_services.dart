import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentService {
  static const String baseUrl =
      'https://medconnect-one-pi.vercel.app/api/api/v1/payment';

  static String? _token;

  /// ✅ تحميل التوكن من shared preferences
  static Future<void> loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      print('🔑 Token loaded: $_token');
    } catch (e) {
      print('❌ Error loading token: $e');
    }
  }

  /// ✅ إرسال طلب دفع cash إلى API
  static Future<Map<String, dynamic>> placeCashOrder({
    required String orderType, // "sale" أو "rental"
    required String productId,
    required int quantity,
    String? rentalStartDate, // تاريخ البداية للحجز (MM/DD/YYYY)
    String? rentalEndDate, // تاريخ النهاية للحجز (MM/DD/YYYY)
  }) async {
    return _sendOrder(
      paymentType: 'cash',
      orderType: orderType,
      productId: productId,
      quantity: quantity,
      rentalStartDate: rentalStartDate,
      rentalEndDate: rentalEndDate,
    );
  }

  /// ✅ إرسال طلب دفع online إلى API
  static Future<Map<String, dynamic>> placeOnlineOrder({
    required String orderType, // "sale" أو "rental"
    required String productId,
    required int quantity,
    String? rentalStartDate, // تاريخ البداية للحجز (MM/DD/YYYY)
    String? rentalEndDate, // تاريخ النهاية للحجز (MM/DD/YYYY)
  }) async {
    return _sendOrder(
      paymentType: 'online',
      orderType: orderType,
      productId: productId,
      quantity: quantity,
      rentalStartDate: rentalStartDate,
      rentalEndDate: rentalEndDate,
    );
  }

  /// ✅ إرسال طلب الدفع إلى API
  static Future<Map<String, dynamic>> _sendOrder({
    required String paymentType,
    required String orderType,
    required String productId,
    required int quantity,
    String? rentalStartDate,
    String? rentalEndDate,
  }) async {
    try {
      print('🌐 Sending payment request...');
      print('📦 Payment Type: $paymentType');
      print('📦 Order Type: $orderType');
      print('📦 Product ID: $productId');
      print('📦 Quantity: $quantity');

      // ✅ تحميل التوكن إذا لم يكن محمل
      if (_token == null) {
        await loadToken();
      }

      // بناء الـ body
      Map<String, dynamic> requestBody = {
        'payment_type': paymentType.toLowerCase(),
        'order_type': orderType.toLowerCase(),
        'product_id': productId,
        'quantity': quantity,
      };

      // إضافة تواريخ الحجز إذا كان النوع rental
      if (orderType.toLowerCase() == 'rental') {
        if (rentalStartDate != null) {
          requestBody['rental_start_date'] = rentalStartDate;
        }
        if (rentalEndDate != null) {
          requestBody['rental_end_date'] = rentalEndDate;
        }
      }

      print('📤 Request Body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(requestBody),
      );

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final bool isSuccess =
            data['success'] == true || data['status'] == 'success';

        if (isSuccess) {
          print('✅ Order placed successfully!');
          return {
            'success': true,
            'message': data['status'] ?? 'Order created successfully',
            'data': data['data'],
            'invoice': data['data']?['invoice_id'],
            'redirectTo': data['data']?['payment_data']?['redirectTo'], // 🔗 استخراج الرابط
          };
        } else {
          print('❌ API returned success: false');
          return {
            'success': false,
            'message': data['status'].toString() ,
            'error': data['error'],
          };
        }
      } else {
        print('❌ Server returned status ${response.statusCode}');
        try {
          final data = jsonDecode(response.body);
          return {
            'success': false,
            'message': data['status'] ?? 'An error occurred while processing your order',
            'error': data['error'] ?? response.body,
          };
        } catch (_) {
          return {
            'success': false,
            'message': 'An error occurred while processing your order',
            'error': 'Status Code: ${response.statusCode}',
          };
        }
      }
    } catch (e) {
      print('❌ Exception: $e');
      return {
        'success': false,
        'message': 'Connection error: Make sure you are connected to the internet',
        'error': e.toString(),
      };
    }
  }
}
