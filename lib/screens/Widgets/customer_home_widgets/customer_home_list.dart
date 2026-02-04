import 'package:carmarketapp/core/shimmer/shimmer_offer_screen.dart';
import 'package:carmarketapp/models/api/cars/car_api_model.dart';
import 'package:carmarketapp/screens/Widgets/customer_home_widgets/customer_home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/customer/favorite/favorite_provider.dart';

class CustomerHomeList extends StatelessWidget {
  const CustomerHomeList({super.key, required this.carList});
  final List<CarApiModel> carList;

  @override
  Widget build(BuildContext context) {

    return  ListView.separated(

        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 0),
        itemBuilder: (context, index) {
      return CustomerHomeWidget(carItem: carList[index],);
    }, separatorBuilder:(context, index) => SizedBox(height: 16.h,), itemCount: carList.length);
  }

}
