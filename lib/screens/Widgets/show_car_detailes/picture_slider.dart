import 'package:cached_network_image/cached_network_image.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/models/api/cars/car_api_model.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helpers/routers/router.dart';
import '../offer_card_widget.dart';

class PictureSlider extends StatefulWidget {
  const PictureSlider(
      {super.key,
      this.images,
      required this.carModel,
      this.isOffer = false,
      this.review,
      this.totalReview,
      this.totalBuyer});

  final List<String>? images;
  final CarApiModel carModel;
  final bool? isOffer;
  final double? review;
  final int? totalReview;
  final int? totalBuyer;

  @override
  State<PictureSlider> createState() => _PictureSliderState();
}

class _PictureSliderState extends State<PictureSlider> {
  late PageController pageController;

  int selectedPicture = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 380.h,
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              ///picture
              Positioned(
                left: 0,
                right: 0,
                child: Container(
                    width: double.infinity,
                    height: 300.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.only(
                          bottomStart: Radius.circular(20.r),
                          bottomEnd: Radius.circular(20.r)),
                    ),
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: widget.images?.length,
                      onPageChanged: (value) {
                        setState(() {
                          selectedPicture = value;
                        });
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return FancyShimmerImage(
                          shimmerBaseColor: Colors.grey.shade700,
                          shimmerHighlightColor: Colors.grey.shade500,
                          boxFit: BoxFit.cover,
                          width: double.infinity,
                          height: 370.h,
                          imageUrl: widget.images![selectedPicture].toString(),
                        );
                      },
                    )),
              ),
              //arrow back
              Positioned(
                  top: 45.h,
                  right: 20.h,
                  left: 20.h,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              NavigationRoutes().pop(context);
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(16),
                                  color: kLightBlackColor,
                                ),
                                padding: EdgeInsets.only(
                                 left: 16,right: 8,top: 8,bottom: 8),
                                child: Center(
                                  child: const Icon(
                                    Icons.arrow_back_ios,
                                    color: kWhite,
                                    size: 30,
                                  ),
                                )))
                      ])),
              //car card
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 20.0.w,
                    left: 16.w,
                    right: 16.w,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CarDetailsCard(
                        isOfferScreen: widget.isOffer,
                        isImage: false,
                        offerCar: widget.carModel,
                        review: widget.review,
                        totalBuyer: widget.totalBuyer,
                        totalReview: widget.totalReview,
                      ),
                    ],
                  ),
                ),
              ),
              // Positioned(
              //   left: 0,
              //   right: 0,
              //   bottom: 0,
              //   top: 230.h,
              //   child: Padding
              //     (
              //     padding: EdgeInsets.symmetric(horizontal: 0~~~~.0.h),
              //     child: const CarDetailsCard(),
              //   ),
              // ),
            ],
          ),
        ),

        ///slider
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: SizedBox(
            height: 8.h,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                    setState(() {
                      selectedPicture = index;
                    });
                  },
                  child: Container(
                      width: selectedPicture == index ? 15.w : 8.w,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: selectedPicture == index
                              ? Theme.of(context).primaryColor
                              : kWhite,
                          borderRadius: selectedPicture == index
                              ? BorderRadius.circular(15.r)
                              : BorderRadius.circular(100.r))),
                );
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                width: 8.h,
              ),
              itemCount: widget.images!.length,
            ),
          ),
        ),
      ],
    );
  }
}
