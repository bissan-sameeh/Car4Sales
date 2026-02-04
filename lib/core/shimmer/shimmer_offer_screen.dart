import 'package:carmarketapp/core/utils/shimmer_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerOfferScreen extends StatelessWidget with ShimmerHelper{
  const ShimmerOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: verticalListShimmer(
         height: 120, separator: 12,count: 8, child: Shimmer.fromColors(
        baseColor: Colors.grey.shade700,
        highlightColor: Colors.grey.shade500,
        child: Column(
          mainAxisSize: MainAxisSize.min, // تأكد من التحكم في الحجم
          children: [
            // الرأس
            Container(
              height: 120.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15.r),
                  topLeft: Radius.circular(15.r),
                ),
              ),
              child: Stack(
                fit: StackFit.loose,
                children: [
                  PositionedDirectional(
                    top: 10,
                    end: 10,
                    child: Container(
                      height: 5.h,
                      width: 5.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 10,
                    end: 50,
                    child: Container(
                      height: 5.h,
                      width: 5.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // المحتوى الداخلي
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 8.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: color,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Container(
                          height: 8.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(3, (index) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 6.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
      ),
    );
  }
}
