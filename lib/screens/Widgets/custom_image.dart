import 'dart:io';

import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/constants.dart';

class CustomImage extends StatelessWidget with ImageHelper {
  const CustomImage({
    super.key,
    required this.path,
    this.width = 45,
    this.height = 45,
    this.marginLeft,
  });

  final String path;
  final double? width;
  final double? height;
  final double? marginLeft;

  // التحقق إذا كان الرابط من الإنترنت
  bool get isNetworkImage =>
      path.startsWith('http') || path.startsWith('https');

  // التحقق إذا كان ملف محلي
  bool get isLocalFile => File(path.toString()).existsSync();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: marginLeft?.w ?? 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          border: const Border.symmetric(
              horizontal: BorderSide(color: kWhite, width: 2),
              vertical: BorderSide(color: kWhite, width: 2)),
        ),
        child: isNetworkImage
            ? ClipOval(
                child: appCacheImage(
                path.toString(),
                height: height?.h,
                width: width?.h,


              ))
            : Image.file(
                File(path.toString()),
                height: 25.h,
                width: 25.h,
              ));
  }
}
