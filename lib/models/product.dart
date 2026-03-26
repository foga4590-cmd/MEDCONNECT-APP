class Product {
  final int id;                    // 👈 جديد
  final String name;
  final String brand;
  final double price;
  final String imagePath;
  final int stock;                 // 👈 جديد (للتحقق من Out of Stock)
  final bool isRentable;           // 👈 جديد (لإظهار زر Rent)
  final DateTime? restockDate;     // 👈 جديد (لإظهار Notify Me)
  final String status;             // موجود
  final List<String> images;       // موجود

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imagePath,
    required this.stock,
    required this.isRentable,
    this.restockDate,
    required this.status,
    required this.images,
  });

  // دالة لتحويل JSON من API إلى Product
  factory Product.fromJson(Map<String, dynamic> json) {
    // استخراج أول صورة إذا وجدت
    String firstImage = '';
    List<String> imagesList = [];
    
    if (json['image'] != null && json['image'] is List) {
      imagesList = (json['image'] as List)
          .map((img) => img['image'] as String)
          .toList();
      firstImage = imagesList.isNotEmpty ? imagesList.first : '';
    }

    return Product(
      id: json['id'],
      name: json['name'],
      brand: json['name'], // مؤقتاً، لو مفيش brand منفصل
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imagePath: firstImage,
      stock: json['stock'] ?? 0,
      isRentable: json['is_rentable'] ?? false,
      restockDate: json['restock_date'] != null 
          ? DateTime.tryParse(json['restock_date']) 
          : null,
      status: json['status'] ?? 'active',
      images: imagesList,
    );
  }
}