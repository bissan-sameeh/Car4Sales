import 'package:carmarketapp/core/utils/currency_helper.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/core/utils/shimmer_helper.dart';
import 'package:carmarketapp/models/api/cars/sold_car_model.dart';
import 'package:carmarketapp/screens/Widgets/car_sales_card.dart';
import 'package:carmarketapp/screens/Widgets/custom_app_bar.dart';
import 'package:carmarketapp/screens/Widgets/custom_not_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/helpers/api_helpers/api_response.dart';
import '../../../core/helpers/routers/router.dart';
import '../../../core/shimmer/shimmer_sold_cars.dart';
import '../../../core/strings/failure.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/sort.dart';
import '../../../providers/Dealer/cars_provider/cars_provider.dart';
import '../../Widgets/custom_error_widget.dart';
import '../../Widgets/custom_no_data.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen>
    with ImageHelper, CurrencyHelper, ShimmerHelper {
  int selectedOrder = 0;
  late TextEditingController searchController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CarsProvider>().fetchAllSoldCars();
    });    searchController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ListView(
        children: [
          ///CustomSearchBar
          //   CustomSearchBar(searchController: searchController,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.h),
            child: Column(
              children: [
                ///SalesBar
                CustomAppBar(text: "Sales"),
                _salesBar,

                ///Sales cars
                carSalesList
              ],
            ),
          ),

          //_salesCars,
        ],
      ),
    ));
  }

  Row get _salesBar {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DropdownButton(
          value: selectedOrder,
          borderRadius: BorderRadius.circular(5.r),
          dropdownColor: Theme.of(context).hintColor,
          menuWidth: MediaQuery.of(context).size.width / 2 - 25,
          style: TextStyle(fontSize: 14.sp, color: kWhite),
          items: const [
            DropdownMenuItem(
              value: 0, //الاحدث
              child: Text('Latest to Newest '),
            ),
            DropdownMenuItem(
              value: 1, //الاقدم
              child: Text("Newest to Latest"),
            )
          ],
          onChanged: (value) => setState(() => selectedOrder = value!),
        ),
      ],
    );
  }

  Widget get carSalesList {
    return Consumer<CarsProvider>(
        builder: (BuildContext context, CarsProvider allCarsPr, Widget? child) {
      print('Status: ${allCarsPr.allSoldCars.status}');
      if (allCarsPr.allSoldCars.status == ApiStatus.LOADING) {
        return ShimmerSoldCarsScreen();
      } else if (allCarsPr.allSoldCars.status == ApiStatus.COMPLETED) {
        // فرز القائمة حسب تاريخ الإنشاء

        if (allCarsPr.allSoldCars.data!.isEmpty) {
          return CustomNotFound(
            image: 'assets/images/linearchart.json',
            width: 450,
            text: 'No Sales Yet!',
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),

          itemBuilder: (context, index) {
            SoldCarModel sold = allCarsPr.allSoldCars.data![index];
            List<SoldCarModel>? soldCarList = allCarsPr.allSoldCars.data;

            for (var soldCar in soldCarList!) {
              sortByCreatedAt(
                  soldCar.cars!, (car) => car.createdAt!, selectedOrder == 0);
            }

            return Column(
              children: sold.cars!.map((car) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                  child: CarSalesCard(
                    soldCar: sold,
                    onTap: () {
                      final carId = car.id;
                      if (mounted) {
                        if (carId != null) {
                          print("SSSSSSSSSSS $carId");

                          NavigationRoutes()
                              .jump(context, Routes.showCarDetails, arguments: {
                            'carId': carId,
                            'isOfferScreen': false,
                            'review': car.averageRating,
                            'totalBuyer': sold.totalBuyers,
                            'totalReview': car.reviewCount
                          });
                        }
                      }
                    },
                    car: car,
                  ),
                );
              }).toList(),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 4.h,
            );
          },
          // itemCount: 1,
          itemCount: allCarsPr.allSoldCars.data?.length ?? 0,
        );
      } else if (allCarsPr.allSoldCars.status == ApiStatus.ERROR) {
        return CustomErrorWidget(
            isInternetConnection:
                allCarsPr.allCars.message == OFFLINE_FAILURE_MESSAGE,
            text: allCarsPr.allSoldCars.message ?? 'Error fetching data',
            onTap: () => allCarsPr.fetchAllSoldCars());
      }
      return SizedBox();
    });
  }
}
