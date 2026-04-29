import 'package:flutter/material.dart';
import 'package:medconnect_app/checkoutAddress.dart';
import 'package:medconnect_app/mainScreen.dart';
import 'package:medconnect_app/services/cart_services.dart';
import 'package:medconnect_app/homeScreen.dart';

class CartItem {
  final int id; // 🔥 مهم
  final String name;
  final String image;
  int quantity;
  final double price;
  final String type;

  final double daily_rent;
  String? dateRange;
  DateTime? rStartDate;
  DateTime? rEndDate;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
    required this.type,
    required this.daily_rent,
    this.dateRange,
  });
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService cartService = CartService();

  late Future<List<dynamic>> cartItems;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      final items = await getCartItemsMapped();

      setState(() {
        cartItemsGlobal = items;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load cart")));
    }
  }

  Future<List<CartItem>> getCartItemsMapped() async {
    final data = await cartService.getCartItems();
    return data.map<CartItem>((item) {
      final product = item['product'];

      if (product['image']['image'] != null &&
          product['image']['image'] is List &&
          product['image']['image'].isNotEmpty) {
        final firstImage = product['image']['image'][0];
        print("First image object: $firstImage"); // 🔍

      }
      return CartItem(
        id: item['id'],
        name: product['name'],
        image:
            (product['image']['image'] != null &&
                product['image']['image'] is List &&
                product['image']['image'].isNotEmpty &&
                product['image']['image'][0]['image'] != null)
            ? product['image']['image'][0]['image']
            : "",
        quantity: item['quantity'],
        price: double.parse(product['price'].toString()),
        type: item['type'],
        daily_rent: 0, // مش موجود في API حالياً
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
   final filteredItems = cartItemsGlobal;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            //new modification
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
        ),

        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: const Color(0xFFF4F4F4),

      body: (isLoading)
          ? Center(child: CircularProgressIndicator())
          : cartItemsGlobal.isEmpty
          ? const Center(
              child: Text("Your cart is empty", style: TextStyle(fontSize: 16)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                 
                  const SizedBox(height: 16),

                  for (int i = 0; i < filteredItems.length; i++) ...[
                    buildCartItem(
                      item: filteredItems[i],
                      index: cartItemsGlobal.indexOf(filteredItems[i]),
                    ),
                    const SizedBox(height: 12),
                  ],
                  buildOrderSummary(),
                  const SizedBox(height: 90),
                ],
              ),
            ),
      bottomSheet: cartItemsGlobal.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A69C3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CheckoutAddressPage(cartItems: cartItemsGlobal),
                      ),
                    );
                  },
                 child: const Text(
  "Pay to buy",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  

  

  // ================= CART ITEM =================
  
  Widget buildCartItem({required CartItem item, required int index}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _productImage(item.image),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                 

                const SizedBox(height: 4),

                 Text(
  '\$${item.price.toStringAsFixed(2)}',
  style: const TextStyle(fontWeight: FontWeight.bold),
),

                const SizedBox(height: 4),
                  Column(

                  ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                 
                 
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                     ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _qtyButton(Icons.add, () async {
                        await cartService.updateCart(
                          cartId: item.id,
                          quantity: item.quantity + 1,
                        );
                        await loadCart();
                      }),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('${item.quantity}'),
                      ),

                      _qtyButton(Icons.remove, () async {
                        if (item.quantity > 1) {
                          await cartService.updateCart(
                            cartId: item.id,
                            quantity: item.quantity - 1,
                          );
                          await loadCart();
                        }
                      }),
                    ],
                  ),
                ],
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                     

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('${item.quantity}'),
                      ),

                     
                    ],
                  ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Delete Item"),
                        content: Text(
                          "Are you sure you want to remove this item?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await cartService.deleteCartItem(cartId: item.id);
                      await loadCart();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productImage(String path) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
  path,
   
  fit: BoxFit.cover,
  errorBuilder: (_, error, __) {
    print("IMAGE ERROR: $error");
    return Icon(Icons.broken_image);
  },
)
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }

  // ================= ORDER SUMMARY =================

  Widget buildOrderSummary() {
        double subtotal = cartItemsGlobal.fold(
  0,
  (sum, item) => sum + (item.price * item.quantity),
);
    double taxes = subtotal * 0.05;
    double total = subtotal + taxes;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),
          _row("Subtotal", subtotal),
          _row("Estimated Taxes & Fees", taxes),
          const Divider(height: 24),
          _row("Total", total, isBold: true),
        ],
      ),
    );
  }

  Widget _row(String title, double value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: isBold ? FontWeight.bold : null),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(fontWeight: isBold ? FontWeight.bold : null),
        ),
      ],
    );
  }

}