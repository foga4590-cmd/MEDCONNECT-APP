import 'package:flutter/material.dart';
import 'package:medconnect_app/cartScreen.dart';
import 'package:medconnect_app/checkoutSummary.dart';

class CheckoutAddressPage extends StatefulWidget {
   

  const CheckoutAddressPage({super.key});

  @override
  State<CheckoutAddressPage> createState() => _CheckoutAddressPageState();
}

class _CheckoutAddressPageState extends State<CheckoutAddressPage> {
  int selectedAddress = 0;

  final List<Map<String, String>> addresses = [
    {
      "title": "General Hospital",
      "address": "123 Health St, MedCity, 10001",
      "icon": "hospital",
    },
    {
      "title": "Downtown Clinic",
      "address": "456 Wellness Ave, MedCity, 10002",
      "icon": "location",
    },
  ];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            );
          },
        ),
        title: const Text("Checkout", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepper(),
            const SizedBox(height: 24),

            const Text(
              "Delivery Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            /// ADDRESSES LIST
            for (int i = 0; i < addresses.length; i++) ...[
              _buildAddressCard(
                index: i,
                title: addresses[i]['title']!,
                address: addresses[i]['address']!,
                icon: addresses[i]['icon'] == "hospital"
                    ? Icons.local_hospital
                    : Icons.location_on,
              ),
              const SizedBox(height: 12),
            ],

            _buildAddAddress(),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A4C8B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CheckoutSummaryPage(
                        cartItems: const [],
                        subtotal: 0.0,
                        taxes: 0.0,
                        total: 0.0,
                        selectedAddress: addresses[selectedAddress],
                     ),
                    )
                  );
                },
                child: const Text(
                  "Continue To Summary",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ---------------- STEP INDICATOR ----------------

  Widget _buildStepper() {
    return Row(
      children: [
        _step(true, 'Address', isBlueText: true),
        _line(true),
        _step(false, 'Summary'),
        _line(false),
        _step(false, 'Payment'),
      ],
    );
  }

  Widget _step(bool active, String title, {bool isBlueText = false}) {
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
              color: isBlueText ? const Color(0xFF0D6EFD) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(bool active) {
    return const SizedBox(width: 8);
  }

  // ---------------- ADDRESS CARD ----------------

  Widget _buildAddressCard({
    required int index,
    required String title,
    required String address,
    required IconData icon,
  }) {
    bool isSelected = selectedAddress == index;

    return InkWell(
      onTap: () => setState(() => selectedAddress = index),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFF0A4C8B) : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF0A4C8B)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(address,
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: (_) => setState(() => selectedAddress = index),
              activeColor: const Color(0xFF0A4C8B),
            )
          ],
        ),
      ),
    );
  }

  // ---------------- ADD ADDRESS ----------------

  Widget _buildAddAddress() {
    return InkWell(
      onTap: _showAddAddressDialog,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "+ Add New Address",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  // ---------------- ADD ADDRESS DIALOG ----------------

  void _showAddAddressDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add New Address"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Place Name",
              ),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: "Address",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  addressController.text.isNotEmpty) {
                setState(() {
                  addresses.add({
                    "title": titleController.text,
                    "address": addressController.text,
                    "icon": "location",
                  });
                  selectedAddress = addresses.length - 1;
                });

                titleController.clear();
                addressController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
