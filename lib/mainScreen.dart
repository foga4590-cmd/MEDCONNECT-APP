import 'package:flutter/material.dart';
import 'package:medconnect_app/cartScreen.dart';
import 'package:medconnect_app/wishList.dart';
import 'package:medconnect_app/equipmentListScreen.dart';


import 'homeScreen.dart';



class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
String pending='';
// ⭐️⭐️⭐️ دالة جديدة: دي اللي هتستقبل اسم الجهاز من EquipmentListsScreen
void _navigateToHomeWithSearch(String searchQuery) {
    setState(() {
      _selectedIndex = 0; // نروح على الـ HomeScreen (الاندكس 0)
      pending=searchQuery;
    });
    
    // محتاجين نأخر شوية عشان الـ HomeScreen يتأكد إنه اتبنى قبل ما نبعتله البحث
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // هنستخدم الـ context دلوقتي عشان نوصل للـ HomeScreen ونشغل البحث
      // هنحتاج نعمل كود في HomeScreen نفسه يستقبل الامر
    });
  }





  // هنا كل الصفحات اللي هتظهر داخل الـ body
  // final List<Widget> _pages = [
  //   const HomeScreen(),
  //   const CartPage(),
  //   const WishlistPage(),
  //    EquipmentListsScreen(),
  // ];

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ====== BODY ======
      body:  IndexedStack( // ⭐️ استخدم IndexedStack بدل الليست عشان يحافظ على حالة كل صفحة
        index: _selectedIndex,
        children: [
          HomeScreen(
           // initialSearch: pending, // ⭐️ Key مهم عشان Flutter يعرف الصفحة
           // onSearchRequested: _navigateToHomeWithSearch, // ⭐️ هنضيف خاصية جديدة
          ),
          const CartPage(),
          const WishlistPage(),
           EquipmentListsScreen(
             onSearchRequested: _navigateToHomeWithSearch, // ⭐️ هنمرر نفس الدالة للـ Equipment
           ),
        ],
      ),
      // ====== BOTTOM NAVIGATION BAR ثابت ======
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF0A69C3),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wishlist"),
          BottomNavigationBarItem(icon: Icon(Icons.devices), label: "Equipment"),
        ],
      ),
    );
  }
}