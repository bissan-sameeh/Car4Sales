import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.text, this.widget, this.action});
  final String text;
  final Widget? widget;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.only(bottom: 18.0.h),
      child: Container(
        color: kBlackColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
                onTap: () => NavigationRoutes().pop(context),
                child: Icon(Icons.arrow_back_ios,color:kWhite,size: 30.h,)),
             Padding(
               padding:  EdgeInsets.only(left: 32.0.w),
               child: Center(child: Text(text,style: TextStyle(fontSize: 20.sp,color:  kWhite,),)),
             ),
            action !=null?Spacer():SizedBox.shrink(),
            action !=null  ?   Padding(
              padding:  EdgeInsets.only(right: 16.0.w),
              child: action!,
            ) : SizedBox.shrink(),

          ],

        ),
      ),
    );
  }
}
