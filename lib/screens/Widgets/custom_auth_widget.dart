import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_app_bar.dart';

class CustomAuthWidget extends StatelessWidget {
  const CustomAuthWidget({
    super.key,
    required this.path,
    required this.text,
    required this.title,
  });

  final String path;
  final String text;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// App Bar Title
        CustomAppBar(text: title),

        SizedBox(height: 32.h),

        /// Illustration
        Image.asset(
          path,
          height: 250.h,
          fit: BoxFit.cover,
        ),

        SizedBox(height: 28.h),

        /// Description Text
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,              // أكبر وواضح
              fontWeight: FontWeight.w500,  // نص رئيسي
              height: 1.6,
              color: Colors.white.withOpacity(0.85),
            ),
          ),

        ),

        SizedBox(height: 36.h),
      ],
    );
  }
}
