import 'package:flutter/material.dart';
import 'package:medconnect_app/checkoutPayment.dart';

// ========== صفحة الـ Summary ==========
class CheckoutSummaryPage extends StatelessWidget {
  final List cartItems ;
  final double subtotal;
  final double taxes;
  final double total;
final Map<String, String> selectedAddress;

  const CheckoutSummaryPage({super.key,
  required this.selectedAddress,
  required this.cartItems,
  required this.subtotal,
  required this.taxes,
  required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepper(),
                    const SizedBox(height: 24),
                    const Text(
                      'Delivery Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDeliveryCard(), // 🔹 هيعرض العنوان المختار الآن
                    const SizedBox(height: 24),
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildOrderSummary(),
                  ],
                ),
              ),
            ),
            _buildButton(context),
          ],
        ),
      ),
    );
  }

  // ========== Stepper ==========
  Widget _buildStepper() {
    return Row(
      children: [
        _step(true, 'Address'),
        const SizedBox(width: 8),
        _step(true, 'Summary'),
        const SizedBox(width: 8),
        _step(false, 'Payment'),
      ],
    );
  }

  Widget _step(bool active, String title) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: active ? const Color(0xFF0D6EFD) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: active ? const Color(0xFF0D6EFD) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ========== Delivery Card ==========
  Widget _buildDeliveryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.local_hospital, color: Color(0xFF0D6EFD)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 استخدم العنوان المختار
                Text(
                  selectedAddress['title'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedAddress['address'] ?? '',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('Change')),
        ],
      ),
    );
  }

  // ========== Order Summary ==========
  Widget _buildOrderSummary() {
    double subtotal = cartItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity));
    double insurance = 50;
    double delivery = 25;
    double total = subtotal + insurance + delivery;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====== عرض المنتجات ديناميكياً ======
          ...cartItems.map((item) {
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
                      ),
                      child: Image.asset(
                        item.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Qty: ${item.quantity}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF0D6EFD),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
          const Divider(height: 32),
          _priceRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          _priceRow('Insurance', '\$${insurance.toStringAsFixed(2)}'),
          _priceRow('Delivery', '\$${delivery.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _priceRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
        ],
      ),
    );
  }

  Widget _priceRow(String left, String right, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              left,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 16 : 14,
              ),
            ),
          ),
          Text(
            right,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? const Color(0xFF0D6EFD) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ========== Continue Button ==========
  Widget _buildButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D6EFD),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CheckoutPaymentPage(),
            ),
          );
        },
        child: const Text(
          'Continue To Payment',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ========== Card Style ==========
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE3EAF2)),
    );
  }
}
