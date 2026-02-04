import 'package:cached_network_image/cached_network_image.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

mixin ImageHelper {
  Widget appCacheImage(String link,
      {double? height, double? width, BoxFit fit = BoxFit.cover}) {
    return CachedNetworkImage(
      imageUrl: link,
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(color: Colors.grey),),

       errorWidget : (context, url, error) => Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(color: kGrayColor),
          // لون أو أي صورة أخرى
          // child: const Icon(Icons.error, color: Colors.white), // أيقونة خطأ
        ),
    );
  }Widget appShimmerImage(String link,
      {double? height=150, double? width, BoxFit fit = BoxFit.cover}) {
    return                         FancyShimmerImage(
        shimmerBaseColor:   Colors.grey.shade700,
        shimmerHighlightColor: Colors.grey.shade500,
        boxFit: BoxFit.cover,
        errorWidget: Icon(Icons.close,color: Colors.redAccent,),

        imageUrl:link,
        height: height!.h, width: double.infinity);

  }



  Widget appSvgImage(
      {required String path, double? width, double? height, Color? color}) {
    return SvgPicture.asset(
      "assets/icons/$path.svg",
      width: width,
      height: height,
      fit: BoxFit.cover,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }
}
