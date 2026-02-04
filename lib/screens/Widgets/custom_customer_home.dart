import 'package:carmarketapp/Screens/Widgets/my_text_field.dart';
import 'package:carmarketapp/screens/Widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/utils/constants.dart';
import '../../providers/customer/customer_cars_provider/customer_cars_provider.dart';

  class CustomCustomerHome extends StatefulWidget {
  const CustomCustomerHome({
    super.key,
  });

  @override
  State<CustomCustomerHome> createState() => _CustomCustomerHomeState();
}

class _CustomCustomerHomeState extends State<CustomCustomerHome> {
  late TextEditingController searchController;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController=TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
             margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
                gradient: kGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35.r),
                  bottomRight: Radius.circular(35.r),
                )),
          ),
          CustomSearchBar(searchController: searchController,
            onChanged: (query) {
              context.read<CustomerCarsProvider>().searchCars(query);

            },

          )


        ],
      ),
    );
  }
}
