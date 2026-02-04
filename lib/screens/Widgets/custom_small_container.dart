import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/constants.dart';
class CustomSmallContainer extends StatefulWidget {
  const CustomSmallContainer(
      {super.key,
      required this.text,
      required this.index,
      this.width,
      this.height = 90,
      this.color, required this.onTap, required this.selectedIndex});

  final String text;
  final int index;
  final double? width;
  final double? height;
  final Color? color;
  final Function(int) onTap;
  final int selectedIndex;

  @override
  State<CustomSmallContainer> createState() => _CustomSmallContainerState();
}

class _CustomSmallContainerState extends State<CustomSmallContainer> {

  @override
  Widget build(BuildContext context) {

    final bool selectedContainer= widget.index ==widget.selectedIndex;
    return InkWell(
      onTap: () =>widget.onTap(widget.index),
      child: Container(
        height: widget.height?.h,
        // constraints:BoxConstraints() ,
        width: widget.width?.w ?? double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: widget.color ?? Theme.of(context).hintColor,
            border: selectedContainer
                ? Border.all(
                    color: widget.color == Theme.of(context).primaryColor
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Theme.of(context).primaryColor,
                    width: 1)
               : null
        ),
        child: Text(
          widget.text,
          style: TextStyle(color: kWhite, fontSize: 14.sp),
        ),
      ),
    );
  }
}
