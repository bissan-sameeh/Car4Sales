import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/core/utils/currency_helper.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/core/utils/style_helper.dart';
import 'package:carmarketapp/screens/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/shimmer_helper.dart';
import '../../../core/helpers/api_helpers/api_response.dart';
import '../../../core/shimmer/shimmer_offer_screen.dart';
import '../../../core/strings/failure.dart';
import '../../../providers/Dealer/cars_provider/cars_provider.dart';
import '../../Widgets/custom_error_widget.dart';
import '../../Widgets/custom_not_found.dart';
import '../../Widgets/offer_card_widget.dart';

class OfferScreen extends StatefulWidget {
const OfferScreen({super.key});


@override
State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> with ImageHelper ,StyleHelper,CurrencyHelper,ShimmerHelper {
  late TextEditingController searchController;


  @override
  void initState() {
// TODO: implement initState
    super.initState();
    searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => Provider.of<CarsProvider>(context,listen: false).fetchAllCars());
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(text: "Offers"),

              ///Search Bar
             //  CustomSearchBar(searchController: searchController),
             //  SizedBox(height: 24.h,),

              ///My offer


              Consumer<CarsProvider>(
                builder: (BuildContext context, CarsProvider allCarsPr,
                    Widget? child) {
                  print('Status: ${allCarsPr.allCars.status}');
                  if (allCarsPr.allCars.status == ApiStatus.LOADING) {
                    return ShimmerOfferScreen();
                  }
                  else
                  if (allCarsPr.allCars.status == ApiStatus.COMPLETED) {
                    if(allCarsPr.allCars.data!.isEmpty){
                      return CustomNotFound(width: 450,text: 'No Offer Yet , Please Add one!',);
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                          left: 16.0.w,right: 16.w, top: 0.h,bottom: 16.h),

                      itemBuilder: (context, index) {
                        return CarDetailsCard(isOfferScreen: true,isImage: true,
                          onTap: () {
                            final carId = allCarsPr.allCars.data![index]!.id;

                            if (carId != null) {
                              print("SSSSSSSSSSS $carId");

                              NavigationRoutes().jump(
                                context,
                                Routes.showCarDetails,
                                arguments: {
                                  'carId': carId,
                                  'isOfferScreen': true,
                                },
                              );

                            }
                          },
                          offerCar: allCarsPr.allCars.data![index],);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 16.h,);
                      },
                      itemCount: allCarsPr.allCars.data?.length ?? 0,
                    );
                  }
                  else if(allCarsPr.allCars.status == ApiStatus.ERROR){
                   return CustomErrorWidget(
                     isInternetConnection: allCarsPr.allCars.message == OFFLINE_FAILURE_MESSAGE,

                       text:  allCarsPr.allCars.message ?? 'Error fetching data',onTap:() => allCarsPr.fetchAllCars());

                }return SizedBox();
                  //   return CustomNoData(
                  //     text: allCarsPr.allSoldCars.message, icon: 'no_car_image',);
                  // }   else{
                  //   return CustomNoData(
                  //     text: 'No Offer Founded , Add One!', icon: 'no_car_image',);
                  // }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
