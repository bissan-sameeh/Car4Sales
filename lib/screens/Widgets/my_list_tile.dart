import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/constants.dart';

class MyListTile extends StatelessWidget with ImageHelper {
   const MyListTile({
    super.key,
    required this.context,
    required this.title,
    this.trailing,
    this.preIcon,
    this.suffixIcon,
    this.isLocate = false,
    this.fountSize =16, this.colorTextTitle = Colors.white,this.trailingAction, this.suffixSize
  });

  final BuildContext context;
  final String title;
  final String? trailing;
  final String? preIcon;
  final Color? colorTextTitle;
  final dynamic suffixIcon;
  final bool? isLocate;
  final double? fountSize;
  final double? suffixSize;
  final Function()? trailingAction;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: fountSize?.sp,color: colorTextTitle),

            ),
            isLocate == false
                ? SizedBox(
                    width: 2.h,
                  )
                : const SizedBox.shrink(),
            preIcon != null
                ? appSvgImage(
                    path: preIcon.toString(),
                    height: 16.h,
                    width: 20.w,
                    color: kWhite)
                : const SizedBox.shrink(),
          ],
        ),

        // isLocate == false ? const Spacer() : const SizedBox.shrink(),
        Expanded(
          child: InkWell(
            onTap: trailingAction,
            child: Row(

               mainAxisAlignment: MainAxisAlignment.end,
              children: [
            trailing != null
                ? Text(
                    trailing.toString(),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 14.sp),
                  )
                : const SizedBox.shrink(),
            SizedBox(width: 4.w,),
            suffixIcon != null
                ? suffixIcon.runtimeType == String
                    ? appSvgImage(
                        path: suffixIcon.toString(),
                        width: 16.w,
                        height: 16.w,
                        color: Theme.of(context).primaryColor)
                    : Icon(
                        suffixIcon,
                        color: Theme.of(context).primaryColor,
              size: suffixSize ??30,
                      )
                : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
