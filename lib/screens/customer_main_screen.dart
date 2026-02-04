import 'package:carmarketapp/screens/Customer/home/customer_home_view.dart';
import 'package:carmarketapp/screens/Widgets/my_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../models/dashboard_model.dart';
import 'Customer/customer_cart_screens/customer_cart_screen.dart';
import 'Customer/customer_favorite_screens/customer_favorite_screen.dart';
import 'Customer/customer_order/order_screen.dart';
import 'dealer/bnb/seller_profile.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key, Duration? duration});

  @override
  State<CustomerMainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<CustomerMainScreen> {
  int selectedIndex = 0;

  List<DashboardModel> get dashboardNavBar => [
    DashboardModel(
      icon: Icons.home_filled,
    ),
    DashboardModel(icon: Icons.favorite),
    DashboardModel(icon: Icons.shopping_cart),
    DashboardModel(icon: Icons.bookmark_border),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: [
          const CustomerHomeView(),
          const FavoriteScreen(),
          // const NotificationsView(),
          CustomerCartScreen(),
          OrderScreen()
        ][selectedIndex],
        bottomNavigationBar: MyBottomNavBar(
            index: selectedIndex,
            onTap: (int newPosition) =>
                setState(() => selectedIndex = newPosition),
            items: dashboardNavBar));
  }
}
