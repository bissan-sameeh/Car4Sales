import 'package:carmarketapp/core/utils/shimmer_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerSoldCarsScreen extends StatelessWidget with ShimmerHelper{
  const ShimmerSoldCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Colors.red;

    return verticalListShimmer(

        height: 120, separator: 12,count: 8, child: Shimmer.fromColors(
      baseColor: Colors.grey.shade700,
      highlightColor: Colors.grey.shade500,
      child: Column(

        children: [
          Row(
            children: [
              ///Car Image
              Container(
                width: 90.w,
                height: 90.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(
                    15.r),
                  color: color
                ),

              ),

              SizedBox(
                width: 12.w,
              ),

              ///Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Brand car Name and price

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: 10.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(
                                    15.r),
                                color: color
                            ),

                          ),
                        ),
                         SizedBox(width: 10.w,),
                        Expanded(
                          child: Container(
                            height: 10.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(
                                    15.r),
                                color: color
                            ),

                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 10.h,
                          width: MediaQuery.of(context).size.width /10.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.circular(
                                  15.r),
                              color: color
                          ),

                        ),
                        SizedBox(width: 4.w,),

                        Container(
                          height: 10.h,
                          width: MediaQuery.of(context).size.width /10.w,

                          decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.circular(
                                  15.r),
                              color: color
                          ),

                        ),
                        Spacer(),
                        Container(
                          height: 10.h,
                          width: MediaQuery.of(context).size.width /10.w,

                          decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.circular(
                                  15.r),
                              color: color
                          ),

                        ),
                      ],
                    ),

                    SizedBox(
                      height: 18.h,
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: 10.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(
                                    15.r),
                                color: color
                            ),

                          ),
                        ),
                        SizedBox(width: 10.w,),
                        Expanded(
                          child: Container(
                            height: 10.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(
                                    15.r),
                                color: color
                            ),

                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    )
    );
  }
}
