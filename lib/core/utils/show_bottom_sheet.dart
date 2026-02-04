import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin MyShowBottomSheet {
  showSheet(BuildContext context, Widget widget, {double? height,Color? color}) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25.r), topLeft: Radius.circular(25.r)),
      ),
      backgroundColor: color??Theme.of(context).hintColor,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SizedBox(
            height: height ?? MediaQuery.of(context).size.height *0.5,
            child: widget);
      },
    );
  }
}
