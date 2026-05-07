# Payment Service Documentation

## نظرة عامة
تم إنشاء `PaymentService` كـ service مركزي للتعامل مع عمليات الدفع والطلبات في تطبيق MedConnect.

---

## 📋 ملخص التغييرات

### 1️⃣ ملف جديد: `lib/services/payment_services.dart`
يحتوي على class `PaymentService` مع method واحد رئيسي:

```dart
static Future<Map<String, dynamic>> placeOrder({
  required String paymentType,      // "cash" أو "online"
  required String orderType,        // "sale" أو "rental"
  required String productId,
  required int quantity,
  String? rentalStartDate,          // تاريخ البداية (MM/DD/YYYY) - اختياري
  String? rentalEndDate,            // تاريخ النهاية (MM/DD/YYYY) - اختياري
})
```

### 2️⃣ تحديثات `lib/checkoutPayment.dart`
- ✅ إضافة import للـ `PaymentService`
- ✅ إضافة state variables لـ rental dates و order type
- ✅ تحديث زرار "Place Order" مع loading state
- ✅ إضافة `_handlePlaceOrder()` للتعامل مع الطلب
- ✅ إضافة `_showSuccessDialog()` و `_showErrorDialog()` لعرض النتائج

---

## 🚀 كيفية الاستخدام

### استدعاء الـ Payment API

```dart
// مثال: طلب شراء (Sale)
final response = await PaymentService.placeOrder(
  paymentType: 'cash',          // دفع عند الاستلام
  orderType: 'sale',            // نوع الطلب شراء
  productId: '142985',
  quantity: 2,
);

// مثال: طلب حجز (Rental)
final response = await PaymentService.placeOrder(
  paymentType: 'online',        // دفع أونلاين
  orderType: 'rental',          // نوع الطلب حجز
  productId: '142985',
  quantity: 2,
  rentalStartDate: '4/21/2026',
  rentalEndDate: '4/24/2026',
);
```

### معالجة الـ Response

```dart
if (response['success'] == true) {
  // ✅ نجح الطلب
  print('Invoice: ${response['invoice']}');
  print('Message: ${response['message']}');
} else {
  // ❌ فشل الطلب
  print('Error: ${response['message']}');
  print('Details: ${response['error']}');
}
```

---

## 📊 بنية الـ Request

**API Endpoint:** `https://medconnect-one-pi.vercel.app/api/api/v1/payment`

### Request Body مثال:
```json
{
  "payment_type": "cash",
  "order_type": "rental",
  "product_id": "142985",
  "quantity": 2,
  "rental_start_date": "4/21/2026",
  "rental_end_date": "4/24/2026"
}
```

### Headers:
```
Accept: application/json
Content-Type: application/json
Authorization: Bearer {token}  // يتم تحميله تلقائياً
```

---

## 📤 بنية الـ Response

### ✅ عند النجاح (200/201):
```json
{
  "success": true,
  "message": "order created successfully",
  "data": {
    "doctor_id": 1,
    "invoice_number": "INV-1776627316",
    "order_type": "sale",
    "subtotal": "6644.00",
    "total": "6644.00",
    "status": "confirmed",
    "id": 151656,
    "items": [ ... ]
  }
}
```

### ❌ عند الفشل:
```json
{
  "success": false,
  "message": "خطأ في البيانات",
  "error": "Product not found"
}
```

---

## 🔧 الميزات

✅ **Auto Token Loading** - يحمل التوكن تلقائياً من `SharedPreferences`  
✅ **Error Handling** - معالجة شاملة للأخطاء (401, 400, etc.)  
✅ **Debug Logging** - طباعة تفاصيل الطلب و الاستجابة  
✅ **Dynamic Request Body** - بناء الـ body بناءً على نوع الطلب  
✅ **Invoice Extraction** - استخراج رقم الفاتورة من الـ response  

---

## ⚠️ ملاحظات مهمة

1. **التوكن يجب أن يكون محفوظاً** في `SharedPreferences` تحت key `'auth_token'`
2. **صيغة التاريخ** للحجز: `MM/DD/YYYY` (مثال: `4/21/2026`)
3. **الكميات** يجب أن تكون أرقام صحيحة (integers)
4. **Product IDs** يجب أن تكون سلسلة نصية أو أرقام

---

## 📝 تعديلات إضافية قد تكون مطلوبة

إذا كنت تريد:

### 1. إضافة support للـ Batch Orders
```dart
static Future<Map<String, dynamic>> placeMultipleOrders(
  List<Map<String, dynamic>> orders
) async {
  // معالجة عدة طلبات دفعة واحدة
}
```

### 2. إضافة Support للـ Coupons/Discounts
```dart
static Future<Map<String, dynamic>> placeOrder({
  // ...existing params...
  String? couponCode,
  double? discountAmount,
})
```

### 3. تحديث صفحة الـ Checkout لمرور Rental Dates
في `checkoutPayment.dart`، قد تحتاج لإضافة TextFields لاختيار التواريخ:
```dart
GestureDetector(
  onTap: () => _selectDate('start'),
  child: Text(rentalStartDate ?? 'Select Start Date'),
)
```

---

## 🧪 اختبار

```dart
// في main.dart أو في أي صفحة
void testPayment() async {
  final response = await PaymentService.placeOrder(
    paymentType: 'cash',
    orderType: 'sale',
    productId: '142985',
    quantity: 1,
  );
  
  print('Response: $response');
}
```

---

## 📞 المساعدة والدعم

في حالة حدوث أي مشاكل:
1. تحقق من أن التوكن محفوظ بشكل صحيح
2. تحقق من اتصالك بالإنترنت
3. تحقق من صيغة البيانات المرسلة
4. تحقق من logs الطباعة في console

---

**تاريخ الإنشاء:** 2026-05-07  
**الإصدار:** 1.0.0
