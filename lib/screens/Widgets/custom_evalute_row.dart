import 'package:carmarketapp/screens/Widgets/rate_section/custom_rate_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/constants.dart';

class EvaluateRow extends StatelessWidget {
  final num? starsNum;
  final int? totalReviews;
  final int? peopleNum;

  const EvaluateRow({
    super.key, this.starsNum, this.peopleNum, this.totalReviews,
  });


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         CustomRateRow(evalutedStars: starsNum ??0, totalReviews: totalReviews ??0,),
        const Spacer(),
        Row(
          children: [
            Icon(Icons.person,color: kGray,size: 20.h,),
            SizedBox(width: 2.w,),
            Text('${peopleNum ??0} ' ,style: TextStyle(color:kGray,fontSize: 12.h,fontWeight: FontWeight.w300),)
          ],
        ),






      ],
    );
  }
}
