import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key,  this.width=200});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/images/animation.json', // ملف Lottie
        width: width.h,
        height: width.h,
        fit: BoxFit.cover,
      ),
    );
  }
}
