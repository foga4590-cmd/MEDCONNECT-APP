import 'package:flutter/material.dart';
import 'package:medconnect_app/homeScreen.dart';


class CheckoutPaymentPage extends StatefulWidget {

   const CheckoutPaymentPage({super.key});

  @override
  State<CheckoutPaymentPage> createState() => _CheckoutPaymentPageState();
}
final TextEditingController discountController = TextEditingController();
double discountAmount = 0;
class _CheckoutPaymentPageState extends State<CheckoutPaymentPage> {
  String selectedPayment =
      "cod"; // cod = Cash on Delivery, online = Online Payment

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
                  children: [
                    _buildStepper(),
                    const SizedBox(height: 24),

                   
                    /// ===== Payment Options =====
                    
                    _buildPaymentOptions(),

               const SizedBox(height: 24),

                    /// ===== Discount Code =====
               
                    _buildDiscountSection(),

               const SizedBox(height: 24),

                    /// ===== Order Summary =====///
                 
                    _buildOrderSummary(),

               const SizedBox(height: 24),
                      
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildPlaceOrderButton(),
          ],
        ),
      ),     
    );
  }

  // ================= Stepper =================
  Widget _buildStepper() {
    return Row(
      children: [
        _step(true, 'Address'),
        _step(true, 'Summary'),
        _step(true, 'Payment'),
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
// ================= Payment Options =================

  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Options',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),

        GestureDetector(
          onTap: () {
            setState(() {
              selectedPayment = "cod";
            });
          },
          child: _paymentTile(
            title: 'Pay On Delivery',
            subtitle: 'Pay With Cash Or Card Upon Arrival',
            selected: selectedPayment == "cod",
          ),
        ),

        const SizedBox(height: 12),

        GestureDetector(
          onTap: () {
            setState(() {
              selectedPayment = "online";
            });
          },
          child: _paymentTile(
            title: 'Online Payment',
            subtitle: 'Credit/Debit Card, Net Banking',
            selected: selectedPayment == "online",
          ),
        ),
      ],
    );
  }

  Widget _paymentTile({
    required String title,
    required String subtitle,
    required bool selected,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? const Color(0xFF0D6EFD) : Colors.grey.shade300,
          width: 1.5,
        ),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: const Color(0xFF0D6EFD),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildDiscountSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Discount Code",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: discountController,
              decoration: InputDecoration(
                hintText: "Enter promo code",
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D6EFD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            onPressed: _applyDiscount,
            child: const Text(
              "Apply",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      if (discountAmount > 0) ...[
        const SizedBox(height: 8),
        Text(
          "Discount Applied: -\$${discountAmount.toStringAsFixed(2)}",
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
      ]
    ],
  );
}
void _applyDiscount() {
  setState(() {
    if (discountController.text.trim().toLowerCase() == "med10") {
      discountAmount = 10;
    } else {
      discountAmount = 0;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Promo Code")),
      );
    }
  });
}
  // ================= Order Summary =================

  Widget _buildOrderSummary() {
    double subtotal = cartItemsGlobal.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    double insurance = 50;
    double delivery = 25;
    
double total = subtotal + insurance + delivery - discountAmount;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====== عرض المنتجات ديناميكياً ======
          ...cartItemsGlobal.map((item) {
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
                      child: Image.asset(item.image, fit: BoxFit.contain),
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
                              color: Colors.grey,
                              fontSize: 12,
                            ),
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
          if (discountAmount > 0)
  _priceRow('Discount', '-\$${discountAmount.toStringAsFixed(2)}'),
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

  

  // ================= Button =================
  Widget _buildPlaceOrderButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D6EFD),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {},
        child: const Text(
          'Place Order',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE3EAF2)),
    );
  }
}
