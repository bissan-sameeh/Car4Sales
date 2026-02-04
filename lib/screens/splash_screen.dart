import 'package:carmarketapp/Cache/auth_storage.dart';
import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/providers/customer/customer_cars_provider/customer_cars_provider.dart';
import 'package:carmarketapp/providers/customer/favorite/favorite_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth/auth_provider.dart';
import '../providers/customer/cart/cart_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key,});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthStorage auth;
  Future<void> loadInitialData() async {
    final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
    final carProvider = Provider.of<CustomerCarsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    await favoriteProvider.loadFavoriteFromStorage();
    await cartProvider.loadCartsFromStorage();
    await favoriteProvider.isFavScreen(false);
    await carProvider.fetchSellerCars();
  }
  @override
  void initState() {
    super.initState();
    auth = AuthStorage();

    Future.delayed(const Duration(milliseconds: 800), () async {
      if (!mounted) return;

      final isLoggedIn = auth.getToken().isNotEmpty;
      final isSeller = auth.getRole();

      if (isLoggedIn) {
        context.read<AuthProvider>().loadUserFromStorage();

        if (!isSeller) {
          await loadInitialData();
          NavigationRoutes().jump(
            context,
            Routes.customerMainScreen,
            replace: true,
          );
        } else {
          NavigationRoutes().jump(
            context,
            Routes.dealerMainScreen,
            replace: true,
          );
        }
      } else {
        NavigationRoutes().jump(
          context,
          Routes.loginScreen,
          replace: true,
        );
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/car4sale.png",fit: BoxFit.cover,)
        ],
      ),
    );
  }
}
