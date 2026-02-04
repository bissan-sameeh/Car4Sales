import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/constants.dart';
class CustomChip extends StatelessWidget {
   CustomChip({super.key, required this.brandName,  this.isPressed=false, required this.onPressed});
  final String brandName;
  final Function()? onPressed;
  late bool isPressed;



  @override
  Widget build(BuildContext context) {
    return  RawChip(
      padding: EdgeInsets.symmetric(horizontal: 8.w),

      onPressed: onPressed,
      label: Text(brandName,style: kBrandTextStyle,),
      backgroundColor: isPressed ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
    );

  }
}
