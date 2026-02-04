import 'package:carmarketapp/core/shimmer/shimmer_offer_screen.dart';
import 'package:carmarketapp/screens/Widgets/customer_home_widgets/customer_home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/api/cart/cart_model.dart';
import 'customer_cart_widget.dart';
class CustomerCartList extends StatelessWidget {
  const CustomerCartList({
    super.key,
    required this.cart,
  });

  final List<Cart> cart;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: cart.length,
      itemBuilder: (context, index) {
        return CustomerCartWidget(
          key: ValueKey(cart[index].id),
          cart: cart[index],
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
    );
  }
}
