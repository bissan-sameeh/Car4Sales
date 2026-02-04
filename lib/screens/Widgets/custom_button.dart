import 'package:carmarketapp/core/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/style_helper.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({super.key, required this.title, this.onTap, this.color, this.loading=false, });
  final String title;
  final Function()? onTap;
  final Color? color;
  final bool loading;


  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: InkWell(
        onTap:widget.loading?null:widget.onTap ,
        child: AnimatedOpacity(
          opacity: widget.loading ? 0.8: 1,
          duration: Duration(milliseconds: 400),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 900),
            child: Container(
              width: widget.loading ? 40.w :double.infinity,
              padding: EdgeInsets.symmetric(vertical: widget.loading ? 8.h:12.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:widget.loading ?Colors.grey.shade400: widget.color ??Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(widget.loading ? 50.r :15.r),
                // border: Border.all(color :Theme.of(context).hintColor,width: 1)

              ),
              child:widget.loading? StyleHelper.progressSpinkit:Text(widget.title,style:TextStyle(fontSize: 14.sp,color: kWhite) ,),
            ),
          ),
        ),
      ),
    );
  }
}
