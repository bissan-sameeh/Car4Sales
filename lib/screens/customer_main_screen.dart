import 'package:flutter/material.dart';

import '../models/dashboard_model.dart';
import 'Customer/customer_cart_screens/customer_cart_screen.dart';
import 'Customer/customer_favorite_screens/customer_favorite_screen.dart';
import 'Customer/customer_order/order_screen.dart';
import 'Customer/home/customer_home_view.dart';
import 'Widgets/my_bottom_nav_bar.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key});

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    const CustomerHomeView(),
    const FavoriteScreen(),
    CustomerCartScreen(),
    OrderScreen(),
  ];

  static final List<DashboardModel> _navItems = [
    DashboardModel(icon: Icons.home_filled),
    DashboardModel(icon: Icons.favorite),
    DashboardModel(icon: Icons.shopping_cart),
    DashboardModel(icon: Icons.bookmark_border),
  ];

  void _onTabChanged(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: MyBottomNavBar(
        index: _selectedIndex,
        items: _navItems,
        onTap: _onTabChanged,
      ),
    );
  }
}
