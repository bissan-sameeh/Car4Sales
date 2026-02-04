import 'package:carmarketapp/core/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSmallText extends StatelessWidget {
  const CustomSmallText({super.key,required this.title, required this.subTitle, this.fontSize=10});
  final String title;
  final String subTitle;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return   Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

      Text(title, style: TextStyle(fontSize: fontSize?.sp,color: kWhite),),

  Padding(
    padding:  EdgeInsetsDirectional.only(start: 4.w),
    child: Text(subTitle.toString(),style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w500,color: kGrayColor))),
    ]);
  }
}
