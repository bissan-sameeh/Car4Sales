import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class CustomNotFound extends StatelessWidget {
  const CustomNotFound(
      {super.key,
      this.width = 200,
      this.image = 'assets/images/notFoundData.json',
      this.text});

  final double width;
  final String? image;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
        child: Lottie.asset(
          image!,
          width: width.h,
          height: width.h,
          fit: BoxFit.contain,
        ),
      ),
      SizedBox(
        height: 20.h,
      ),
      Center(
        child: Text(
          text.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(color: CupertinoColors.inactiveGray, fontSize: 18.sp),
        ),
      ),
    ]);
  }
}
