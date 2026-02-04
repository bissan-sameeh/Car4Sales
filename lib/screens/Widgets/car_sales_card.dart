import 'package:carmarketapp/core/utils/currency_helper.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/models/api/cars/car_api_model.dart';
import 'package:carmarketapp/models/api/cars/sold_car_model.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/constants.dart';
import 'custom_evalute_row.dart';

class CarSalesCard extends StatefulWidget {
  final bool? isStatisticScreen;
  final bool? isRevenue;
  final SoldCarModel? soldCar;
  final CarApiModel? car;
  final Function()? onTap;


  const CarSalesCard(
      {super.key,
      this.isStatisticScreen = false,
      this.isRevenue = false,
      this.soldCar,
      this.car, this.onTap});

  @override
  State<CarSalesCard> createState() => _CarSalesCardState();
}

class _CarSalesCardState extends State<CarSalesCard>
    with ImageHelper, CurrencyHelper {



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        decoration: buildBoxDecoration(
          isBorderSide: false,
          isShadow: true,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            Row(
              children: [
                ///Car Image
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(
                        widget.isRevenue == true ? 150.r : 15.r),
                  ),
                  child: FancyShimmerImage(
                    shimmerBaseColor:   Colors.grey.shade700,
                      shimmerHighlightColor: Colors.grey.shade500,
                      imageUrl: widget.car!.coverImage
                              .toString() ,width: 90.w,
                      boxFit: BoxFit.cover,
                      height: 90.h,
                    errorWidget: Icon(Icons.close,color: Colors.redAccent,)
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
                          Text(
                            widget.car!.brand.toString(),
                            style: TextStyle(color: kWhite, fontSize: 14.sp),
                          ),
                          const Spacer(),
                          Flexible(
                            child: Text(
                              convertCurrency(
                                  widget.car?.price ??
                                      5000000),
                              overflow: TextOverflow.ellipsis,  // استخدم fade لتلاشي النص عند تجاوزه


                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14.sp),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                          EvaluateRow(peopleNum:widget.soldCar?.totalBuyers ??0,
totalReviews: widget.car?.reviewCount ??0,
                          starsNum: widget.car?.averageRating ??0,
                          ),
                      SizedBox(
                        height: 12.h,
                      ),


                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            height: 8.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: kGrayColor),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: LinearProgressIndicator(
                                  value: widget.soldCar!.totalSold! / 50,
                                  backgroundColor: Colors.transparent,
                                  color: Theme.of(context).primaryColor,
                                )),
                          )),
                          const Spacer(),
                          Text(
                                 '${widget.car?.quantityInStock} of ${widget.soldCar!.totalSold} cars Sold'
                              ,
                            style: TextStyle(
                                fontSize: 9.sp,
                                color: kWhite,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
