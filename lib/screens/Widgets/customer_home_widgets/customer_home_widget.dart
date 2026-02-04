import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/core/utils/snckbar.dart';
import 'package:carmarketapp/models/api/cars/car_api_model.dart';
import 'package:carmarketapp/providers/customer/cart/cart_provider.dart';
import 'package:carmarketapp/providers/customer/favorite/favorite_provider.dart';
import 'package:carmarketapp/screens/Widgets/customer_home_widgets/custom_name_price_widget.dart';
import 'package:carmarketapp/screens/Widgets/favorite_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/helpers/routers/router.dart';
import '../../../core/utils/converter_helper.dart';
import '../../../core/utils/currency_helper.dart';
import '../../../core/utils/enums.dart';
import 'custom_car_details.dart';

class CustomerHomeWidget extends StatelessWidget
    with ImageHelper, CurrencyHelper, ShowSnackBar, ConverterHelper {
  const CustomerHomeWidget({super.key, required this.carItem});

  final CarApiModel carItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => NavigationRoutes().jump(context, Routes.showCarDetails,
          arguments: {"carId": carItem.id}),
      child: Container(
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
                      child: appShimmerImage(carItem.images?[0] ?? "")),
                  PositionedDirectional(
                    top: 10,
                    end: 10,
                    child: Row(
                      children: [
                        Consumer<CartProvider>(
                          builder: (context, cartProvider, _) {
                            final carId = carItem.id!.toString();

                            return FavoriteBtn(
                              color: cartProvider.isCart(carId)
                                  ? Theme.of(context).primaryColor
                                  : kWhite,
                              icon: cartProvider.isCart(carId)
                                  ? Icons.shopping_cart
                                  : Icons.add_shopping_cart,
                              onTap: cartProvider.isLoadingCart(carId)
                                  ? null
                                  : () async {
                                      final result =
                                          await cartProvider.toggleCart(
                                        carId: carItem.id ?? 0,
                                        quantity: 1,
                                      );

                                      if (cartProvider
                                              .toggleCartResponse.status ==
                                          ApiStatus.ERROR) {
                                        if (context.mounted) {
                                          showSnackBar(context,
                                              message: cartProvider
                                                  .toggleCartResponse.message
                                                  .toString(),
                                              error: true);
                                        }
                                      } else if (cartProvider
                                              .toggleCartResponse.status ==
                                          ApiStatus.COMPLETED) {
                                        {
                                          if (result) {
                                            if (context.mounted) {
                                              showSnackBar(
                                                context,
                                                message:
                                                    "Added to cart successfully!",
                                              );
                                            }
                                          } else {
                                            if (context.mounted) {
                                              showSnackBar(
                                                context,
                                                message:
                                                    "Delete from cart successfully!",
                                              );
                                            }
                                          }
                                        }

                                        // showSnackBar(context, message: result)

                                        // if (result == ToggleCartResult.added) {
                                        //   showSnackBar(
                                        //     context,
                                        //     message: "تمت إضافة السيارة إلى السلة",
                                        //     error: false,
                                        //   );
                                        // }
                                        // else if (result == ToggleCartResult.alreadyExists) {
                                        //   showSnackBar(
                                        //     context,
                                        //     message: "السيارة موجودة مسبقًا في السلة",
                                        //     error: false,
                                        //   );
                                        // }
                                        // else if (result == ToggleCartResult.error) {
                                        //   showSnackBar(
                                        //     context,
                                        //     message: result,
                                        //     error: true,
                                        //   );
                                        // }
                                      }
                                    },
                            );
                          },
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Consumer<FavoriteProvider>(
                          builder: (context, favProvider, _) {
                            final idStr = carItem.id.toString();
                            final isLoading =
                                favProvider.isLoadingFavorite(idStr) && favProvider.isFavoriteScreen;
                            final isFav = favProvider.isFavorite(idStr);

                            return FavoriteBtn(
                              icon: isLoading
                                  ? Icons.hourglass_top
                                  : isFav
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: isFav ? Colors.red : kWhite,
                              onTap: () async {
                                try {
                                  await favProvider.toggleFavorite(id: carItem.id!);

                                  if (favProvider.toggleFavoriteStatus.status == ApiStatus.ERROR) {
                                    if(context.mounted){

                                    showSnackBar(
                                      context,
                                      message:
                                      favProvider.toggleFavoriteStatus.message?.toString() ??
                                          "Something went wrong",
                                      error: true,
                                    );
                                    }
                                  }
                                } catch (_) {
                                  if(context.mounted){

                                  showSnackBar(
                                    context,
                                    message:
                                    favProvider.toggleFavoriteStatus.message?.toString() ??
                                        "Unexpected error",
                                    error: true,
                                  );
                                  }
                                }
                              },
                            );
                          },
                        ),

                      ],
                    ),
                  ),
                  PositionedDirectional(
                      start: 10,
                      top: 10,
                      child: FavoriteBtn(
                        icon: 'whatsapp',
                        onTap: () async {
                          if (carItem.seller?.whatsapp != null) {
                            await openWhatsApp(
                              phone: carItem.seller!.whatsapp!,
                              message: "Hello, I’m interested in the ${carItem.brand} car.",
                            );
                          } else {
                            showSnackBar(
                              context,
                              message: "Seller contact not available",
                              error: true,
                            );
                          }

                        },
                      )),
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
                      name: carItem.brand.toString(),
                      price: carItem.price.toString(),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    CustomCarDetails(
                      seatsNum: carItem.seats.toString(),
                      transmission: carItem.transmission.toString(),
                      fuelType: carItem.fuelType.toString(),
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
      ),
    );
  }
}
