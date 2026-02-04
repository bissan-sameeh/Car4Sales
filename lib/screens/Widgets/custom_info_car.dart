import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInfoCar extends StatelessWidget with ImageHelper {
  const CustomInfoCar(
      {super.key,
      required this.carInfo,
      this.isSpeed = false,
      this.measurment,
      required this.path, this.onTap});

  final String carInfo;
  final dynamic path;
  final bool? isSpeed;
  final String? measurment;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap ,
      child: Row(

        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
       path. runtimeType ==String ?  appSvgImage(
              path: path,
              height: 18.h,
              width: 18.h,
              color: Theme.of(context).primaryColor) :Icon(path,size: 30.r,color: Theme.of(context).primaryColor,),
          SizedBox(
            width: 4.w,
          ),
          Flexible(
            child: Text(
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              carInfo,
              style: TextStyle(
                  fontSize: 10.sp, fontWeight: FontWeight.w400, color: kWhite),
            ),
          ),
          isSpeed == true
              ? Padding(
                  padding: EdgeInsetsDirectional.only(start: 2.w),
                  child: Text(measurment.toString(),

                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w300,
                      )),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
