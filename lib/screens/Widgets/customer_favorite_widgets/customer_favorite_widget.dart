import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/screens/Widgets/customer_home_widgets/custom_name_price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/currency_helper.dart';
import '../custom_info_car.dart';
import '../customer_home_widgets/custom_car_details.dart';
import '../favorite_btn.dart';

class CustomerFavoriteWidget extends StatelessWidget
    with ImageHelper, CurrencyHelper {
  const CustomerFavoriteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: buildBoxDecoration(borderRadius: 15, isBorderSide: false),
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.only(
                            topStart: Radius.circular(15.r),
                            topEnd: Radius.circular(15.r))),
                    child: appShimmerImage(
                        "https://th.bing.com/th/id/OIP.eSy7tiv60DzvytIKPICE4AHaEo?cb=iwc2&rs=1&pid=ImgDetMain")),
                PositionedDirectional(
                  top: 10,
                  end: 10,
                  child:FavoriteBtn(icon: Icons.favorite,color: Colors.red,)
                ),

                PositionedDirectional(
                  start: 10,
                  top: 10,
                  child:FavoriteBtn(icon: 'whatsapp')
                ),
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Column(
                children: [
                  CustomNamePriceWidget(
                    name: 'Honda',
                    price: '3000',
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  CustomCarDetails(
                    seatsNum: '6',
                    transmission: 'Manual',
                    fuelType:
                    'jjjjjjjjjjjjjjjjjjjdklzfffffffffffffffffffffffffffffffl',
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  // Row(
                  //   children: [
                  //     Row(
                  //       children: [
                  //
                  //         SizedBox(width: 4.w,),
                  //         Text("connect")
                  //       ],
                  //     ),
                  //         Spacer(),
                  //
                  //
                  //
                  //   ],
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
