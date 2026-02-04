import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/constants.dart';

class CustomFilterBtn extends StatelessWidget {
  const CustomFilterBtn({
    super.key, required this.text, this.color, this.onTap,
  });
  final String text;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(15.r),
              color: color ?? Theme.of(context).hintColor),
          alignment: Alignment.center,
          child: Text(
          text,
            style: TextStyle(color: kWhite, fontSize: 16.sp),
          ),
        ),
      ),
    );
  }
}
