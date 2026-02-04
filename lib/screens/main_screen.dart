import 'package:carmarketapp/screens/Widgets/my_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../models/dashboard_model.dart';
import 'dealer/bnb/add_car_view.dart';
import 'dealer/bnb/home_view.dart';
import 'dealer/bnb/seller_profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, Duration? duration});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  List<DashboardModel> get dashboardNavBar => [
        DashboardModel(
          icon: 'Home',
        ),
        DashboardModel(icon: 'add_car'),
        // DashboardModel(icon: 'Notification'),
        DashboardModel(icon: 'user_icon'),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: [
          const HomeView(),
          const AddUpdateCarView(),
          // const NotificationsView(),
           SellerProfile()
        ][selectedIndex],
        bottomNavigationBar: MyBottomNavBar(
            index: selectedIndex,
            onTap: (int newPosition) =>
                setState(() => selectedIndex = newPosition),
            items: dashboardNavBar));
  }
}
