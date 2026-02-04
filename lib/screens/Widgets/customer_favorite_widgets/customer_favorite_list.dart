import 'package:carmarketapp/models/api/favorite/favorite_model.dart';
import 'package:carmarketapp/screens/Widgets/customer_home_widgets/customer_home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CustomerFavoriteList extends StatelessWidget {
  const CustomerFavoriteList({
    super.key,
    required this.favorites,
  });

  final List<Favorites> favorites;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final car = favorites[index].car;
        if (car == null) {
          return const SizedBox.shrink();
        }
        return CustomerHomeWidget(
          key: ValueKey(favorites[index].id),
          carItem: car,
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
    );
  }
}
