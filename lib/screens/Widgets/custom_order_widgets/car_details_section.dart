import 'package:carmarketapp/core/utils/currency_helper.dart';
import 'package:carmarketapp/models/api/cars/car_api_model.dart';
import 'package:carmarketapp/providers/customer/cart/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/constants.dart';

class CarDetailsSection extends StatelessWidget with CurrencyHelper {
  const CarDetailsSection({super.key, required this.brandName, required this.climate, required this.battery, required this.location, required this.price, required this.type, required this.id});
 final String brandName;
 final String climate;
 final String battery;
 final String location;
 final double price;
 final String type;
 final int id;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 110.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: TextStyle(color: kBlackColor, fontSize: 18.sp)),
          SizedBox(height: 10.h),
          Text(
            'The $brandName Car is $type car , climate is $climate , $battery % battery in $location ...',
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                Provider.of<QuantityProvider>(context,listen: false).getQuantity(id).toString(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
              Text(
                convertCurrency(  (price*Provider.of<QuantityProvider>(context,listen: false).getQuantity(id)) )  ,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
