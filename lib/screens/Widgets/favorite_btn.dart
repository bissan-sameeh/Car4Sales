
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteBtn extends StatelessWidget {
  const FavoriteBtn({
    super.key, required this.icon, this.color, this.onTap,
  });

 final dynamic icon;
 final Color? color;
 final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: buildBoxDecoration(isBorderSide: false),
          padding:
          EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
          child: icon.runtimeType ==IconData? Icon(
            icon,
            color: color??kWhite,
            size: 30.r,
          ) :Image.asset( "assets/icons/whatsapp.png",
            width: 24.w,
            height: 30.h,)),
    );
  }
}
