
import 'package:carmarketapp/core/utils/currency_helper.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/models/api/cars/car_api_model.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Dealer/bnb/add_car_view.dart';
import 'custom_evalute_row.dart';
import 'custom_info_car.dart';
import 'custom_small_text.dart';
import 'delete_dialog_widget.dart';

class CarDetailsCard extends StatelessWidget with CurrencyHelper, ImageHelper {
  const CarDetailsCard(
      {super.key, this.isOfferScreen = false, this.offerCar, this.onTap, this.isImage=false, this.review, this.totalReview, this.totalBuyer});

  final CarApiModel? offerCar;
  final double? review;
  final int? totalReview;
  final int? totalBuyer;

  final bool? isOfferScreen;
  final bool? isImage;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).hintColor,
              borderRadius: BorderRadius.circular(20.r)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: (isImage ?? false),

                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15.r),
                          topLeft: Radius.circular(15.r)),
                    ),
                    child: Stack(
                      // fit: StackFit.loose,
                      children: [
                        FancyShimmerImage(
                            shimmerBaseColor:   Colors.grey.shade700,
                            shimmerHighlightColor: Colors.grey.shade500,
                            boxFit: BoxFit.cover,
                            errorWidget: Icon(Icons.close,color: Colors.redAccent,),

                            imageUrl:offerCar!.coverImage!,
                            height: 150, width: double.infinity),
                        PositionedDirectional(
                            top: 10,
                            end: 10,
                            child: InkWell(
                              onTap: () {
                                deleteDialog(context, postId: offerCar!.id!);
                              },
                              child: Icon(
                                Icons.delete,
                                color: Theme.of(context).primaryColor,
                                size: 30,
                              ),
                            )),
                        PositionedDirectional(
                            top: 10,
                            end: 50,
                            child: InkWell(
                              // onTap: () => NavigationRoutes().jump(context, Routes.addCarScreen,
                              //arguments:
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddUpdateCarView(
                                    car: offerCar,
                                  ),
                                ));
                              },
                              // [CarModel(carBrand: "Bwm", carType: "electric", color: Colors.white38, quantity: 3, speed: 100, battery: 70, range: 100, price: 500000, climate: 'Climate', transmissionType: 'Automatic', carImages: carImages, carCoverImage: File(''), seats: 3)]),

                              child: Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
                                size: 30,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomSmallText(
                            title: offerCar?.brand.toString() ?? "Honda",
                            subTitle: offerCar?.year.toString() ?? '2010',
                            fontSize: 14,
                          ),
                          const Spacer(),
                          Text(
                            convertCurrency(offerCar?.price ?? 0),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: !(isOfferScreen ?? false),
                        child: SizedBox(height: 16.h),
                      ),
                      if(isOfferScreen==true) SizedBox(height:12.h ,),
                      isOfferScreen==true? SizedBox.shrink(): EvaluateRow(starsNum: review,totalReviews: totalReview,peopleNum: totalBuyer,),

                      Visibility(
                          visible: !(isOfferScreen ?? false),
                          child: SizedBox(
                            height: 16.h,
                          )),
                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomInfoCar(
                                path: 'seat',
                                carInfo: '${offerCar?.seats ?? 5} seats'),
                          ),
                          Expanded(
                            flex: 1,
                            child: CustomInfoCar(
                                path: 'transmission_car',
                                carInfo: offerCar?.transmission ?? 'Manual'),
                          ),
                      Expanded(
                        flex: 1,

                        child: CustomInfoCar(
                            path: 'fuel',
                            carInfo: offerCar?.fuelType ?? 'Petrol'),
                      ),
                        ],
                      ),

                    ],
                  ),
                ),
              ]),
        ));
  }

  deleteDialog(BuildContext context, {required int postId}) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteDialogWidget(
          id: postId,
        );
        // return Consumer<PostsProvider>(builder: (context, postPro, child) {
        //   if(postPro.deletePostStatus.status==ApiStatus.LOADING){
        //     return const LoadingWidget();
        //   } else if(postPro.deletePostStatus.status==ApiStatus.COMPLETED){
        //     // return show;
        //   } if(postPro.deletePostStatus.status==ApiStatus.ERROR){
        //     return  CustomErrorWidget(errorMessage: postPro.deletePostStatus.message.toString());
        //   } return const LoadingWidget();
        // },);
      },
    );
  }
}
