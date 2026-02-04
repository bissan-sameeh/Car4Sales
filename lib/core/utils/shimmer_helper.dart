import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Screens/Widgets/my_shimmer.dart';


mixin ShimmerHelper {
  Widget horizontalListShimmer(
      {required double height,
      required double width,
      required double separator,
      double startPadding = 20,
      double bottomPadding = 0,
      double radius = 5,
      int count = 0}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
          start: startPadding.w, bottom: bottomPadding.h),
      child: SizedBox(
        height: height.h,
        child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container();
              //   MyShimmer(
              //   height: height,
              //   width: width,
              //   radius: radius,
              // );
            },
            separatorBuilder: (context, index) => SizedBox(
                  width: separator.w,
                ),
            itemCount: count),
      ),
    );
  }

  Widget verticalListShimmer(
      {required double height,
      double width = double.infinity,
      required double separator,
      double startPadding = 16,

        double bottomPadding = 0,
        required Widget child,
      double radius = 5,
      int count = 0}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
          start: startPadding.w, bottom: bottomPadding.h),
      child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,

          itemBuilder:  (context, index) => child //
          ,
          separatorBuilder: (context, index) => SizedBox(
                height: separator.w,
              ),
          itemCount: count),
    );
  }
}
