import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRateRow extends StatelessWidget with ImageHelper {
  const CustomRateRow({super.key, required this.evalutedStars,  this.isComment=false,  this.totalReviews});
  final num evalutedStars;
  final int? totalReviews;
  final bool? isComment;

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(evalutedStars==0?Icons.star_border:Icons.star,size:20.h,color: Theme.of(context).primaryColor,),
        SizedBox(width: 4.w,),
        Text(evalutedStars.toString(),style:salesStyle ,),
        SizedBox(width: 4.w,),
        isComment== false ? Text('($totalReviews review)',style: TextStyle(fontSize: 9.sp,color: kWhite,fontWeight: FontWeight.w100),):const SizedBox.shrink(),

      ],
    );
  }
}
