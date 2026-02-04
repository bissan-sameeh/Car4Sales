import 'package:carmarketapp/core/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyOtpTextField extends StatelessWidget {
  const MyOtpTextField({
    Key? key,
    required this.textEditingController,
    required this.focusNode,
    required this.onChanged,
    this.autoFocus = false,
  }) : super(key: key);
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final bool? autoFocus;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65.h,
      width: 65.h,
      child: TextField(
        onChanged: onChanged,
        focusNode: focusNode,
        maxLength: 1,

        autofocus: autoFocus!,
        textAlign: TextAlign.center,
        controller: textEditingController,
        cursorColor: Theme.of(context).primaryColor,
        cursorHeight: 30,
        style: TextStyle(color: kWhite,fontSize: 18.sp),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 4.h),
            hintStyle:
            TextStyle(color: Colors.white, fontSize: 30.sp),
            counter: const SizedBox.shrink(),
            fillColor: Theme.of(context).hintColor,
            filled: true,

            focusedBorder: buildOutlineInputBorder(isFocus: Theme.of(context).primaryColor),
            enabledBorder: buildOutlineInputBorder()),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder({Color? isFocus}) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(width: 0.7.w, color: isFocus?? Color(0xFF50555E)));
  }
}
