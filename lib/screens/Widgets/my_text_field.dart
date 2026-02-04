import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({
    super.key,
    this.onTap,
    required this.hint,
    this.suffixIcon,
    this.onChanged,
    this.textInputAction = TextInputAction.done,
    this.textInputType = TextInputType.text,
    this.prefixIcon,
    required this.controller,
    this.startContentPadding = 4,
    this.isOutlinedBorder = false,
    this.topContentPadding = 0,
    this.bottomContentPadding = 4,
    this.isPassword = false,
    this.obscured = false,
    this.prefixColor=Colors.white30,
    this.isFill=true, this.validator, this.onTapSuffix,



  });

  final Function()? onTap;
  final Function(String)? onChanged;
  final String? hint;
  final dynamic suffixIcon;
  final dynamic prefixIcon;
  final bool? isOutlinedBorder;
  final Color prefixColor;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final TextEditingController controller;
  final double? startContentPadding;
  final double? topContentPadding;
  final double? bottomContentPadding;
  final bool? isPassword;
  final bool? obscured;
  final bool? isFill;
  final String? Function(String?)? validator;
  final VoidCallback? onTapSuffix;



  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> with ImageHelper {
  late FocusNode focusNode;

  bool isFocused = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode = FocusNode()
      ..addListener(
        () {
          setState(() => isFocused = focusNode.hasFocus);
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return     TextFormField(
      obscureText: widget.obscured!,
      controller: widget.controller,
      onTap: widget.onTap,

      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      cursorColor: Theme.of(context).primaryColor,
      style:  TextStyle(
        color: Colors.white.withOpacity(0.85),
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      validator: widget.validator,
      enableSuggestions: widget.isPassword == true ? false : true,
      autocorrect: widget.isPassword  == true ? false : true,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        filled: widget.isFill,
        fillColor: Theme.of(context).hintColor,


        contentPadding: EdgeInsetsDirectional.only(
            start: widget.startContentPadding!.w,
            top: widget.topContentPadding!.h,
            bottom: widget.bottomContentPadding!.h),
        suffixIcon: widget.suffixIcon != null
            ? widget.isPassword == true
                ? widget.obscured == true
                    ? InkWell(
            onTap: widget.onTapSuffix,
            child: Icon(Icons.visibility,color: Colors.white30))
                    : InkWell(
            onTap: widget.onTapSuffix,
            child: Icon(Icons.visibility_off,color: Colors.white30))
                : widget.suffixIcon.runtimeType == String
                    ? Padding(
                        padding: EdgeInsets.only(top: 18.0.h),
                        child: InkWell(
                          onTap:widget.onTapSuffix,
                          child: Text(widget.suffixIcon,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14.sp)),
                        ),
                      )
                    : InkWell(
          onTap:widget.onTapSuffix,
                      child: Icon(
                          widget.suffixIcon,
                          color: Theme.of(context).primaryColor,
                        ),
                    )
            // appSvgImage(path: widget.suffixIcon ?? '')

            : null,
        prefixIconConstraints: const BoxConstraints(),
        prefixIcon: widget.prefixIcon != null
            ? widget.prefixIcon.runtimeType == String
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: appSvgImage(
                        path: widget.prefixIcon,
                        color: widget.prefixColor??Theme.of(context).primaryColor,
                        height: 25.h,
                        width: 25.h),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: Icon(
                      widget.prefixIcon,
                      color: widget.prefixColor ??Theme.of(context).primaryColor,
                    ),
                  )
            : null,
        hintText: widget.hint.toString(),
        hintStyle: buildTextStyle(),
        enabledBorder: buildOutlineInputBorder(),
        focusedBorder: buildOutlineInputBorder(isFocused: true),
      ),
    );
  }

  TextStyle buildTextStyle() => TextStyle(
      color: const Color(0xfff1f1f1).withOpacity(0.3), fontSize: 12.sp);

  OutlineInputBorder buildOutlineInputBorder({bool isFocused=false}) =>
      buildOutlineInputBorderTextField(
          isHasColorBorder: widget.isOutlinedBorder,isFocused: isFocused);
}
