import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_image.dart';
import 'my_text_field.dart';

class CustomContainer extends StatefulWidget {
  const CustomContainer({
    super.key,
    this.controller,
    required this.title,
    this.suffixIcon,
    this.preTileIcon,
    this.hint,
    this.widget,
    this.height,
    this.isClimate = false,
    this.iconWidth,
    this.iconHeight,
    this.trailing,
  });

  final TextEditingController? controller;
  final String title;
  final String? hint;
  final String? preTileIcon;
  final dynamic suffixIcon;
  final Widget? widget;
  final double? height;
  final bool? isClimate;
  final double? iconWidth;
  final double? iconHeight;
  final Widget? trailing;

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> with ImageHelper {
  // التحقق إذا كان الرابط من الإنترنت
  bool get isNetworkImage =>
      widget.preTileIcon!.startsWith('http') ||
      widget.preTileIcon!.startsWith('https');

  // التحقق إذا كان ملف محلي
  bool get isLocalFile => File(widget.preTileIcon.toString()).existsSync();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 204,
      padding: EdgeInsets.only(
          top: 16.h,
          right: widget.isClimate == true ? 0 : 16.w,
          left: 16.w,
          bottom: 16.h),
      decoration: buildBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              widget.preTileIcon != null
                  ? isLocalFile || isNetworkImage
                      ? Padding(
                          padding: EdgeInsetsDirectional.only(end: 4.0.w),
                          child: CustomImage(
                            path: widget.preTileIcon.toString(),
                            height: widget.iconHeight ?? 24,
                            width: widget.iconWidth ?? 24,
                          ),
                        )
                      : appSvgImage(
                          path: widget.preTileIcon.toString(),
                          color: Theme.of(context).primaryColor,
                          height: 24,
                          width: 24)
                  : const SizedBox.shrink(),
              SizedBox(
                width: 4.w,
              ),
              Text(
                widget.title,
                style: TextStyle(
                  color: kWhite,
                  fontSize: 14.sp,
                ),
              ),
              widget.trailing != null
                  ? const Spacer()
                  : const SizedBox.shrink(),
              widget.trailing != null
                  ? widget.trailing!
                  : const SizedBox.shrink()
            ],
          ),
          SizedBox(
            height: widget.isClimate == false ? 12.h : 50.h,
          ),
          widget.hint != null
              ? MyTextField(
                  hint: widget.hint,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.number,
                  suffixIcon: widget.suffixIcon,
                  controller: widget.controller!,
                  startContentPadding: 6,
                )
              : widget.widget!,
        ],
      ),
    );
  }
}
