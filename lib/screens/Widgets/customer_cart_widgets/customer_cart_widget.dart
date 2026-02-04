import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/core/utils/snckbar.dart';
import 'package:carmarketapp/providers/customer/cart/cart_provider.dart';
import 'package:carmarketapp/providers/customer/cart/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/currency_helper.dart';

import '../../../models/api/cart/cart_model.dart';
import 'add_remove_btn.dart';
import 'custom_slide_action.dart';

class CustomerCartWidget extends StatelessWidget with ShowSnackBar,CurrencyHelper,ImageHelper
  {
  const CustomerCartWidget({super.key, required this.cart});
  final Cart cart;

  double calculateTotalPrice(BuildContext context) {
    final quantity =
    context.watch<QuantityProvider>().getQuantity(cart.carId);

    final rawPrice = cart.car?.price;

    final parsedPrice = rawPrice ??0;

    return parsedPrice * quantity;
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit=false;

    final car=cart.car;
    return GestureDetector(

        onTap: () async {
         await NavigationRoutes().jump(context,Routes.customerPlaceOrder,arguments:{ 'carId':cart.carId,
           "cartId":cart.id


          }


          );
             Provider.of<QuantityProvider>(context, listen: false).resetAll();
        },


        child: Slidable(

          endActionPane: ActionPane(
            extentRatio: 0.6,
            dragDismissible: true,
            motion: const ScrollMotion(),
            children: [
            SizedBox(
            width: 8.w,
          ),
              CustomSlideAction(

              icon: Icons.delete,
              color: Colors.redAccent,
              function: (check) async {
                    Provider.of<CartProvider>(context,listen: false).deleteCart(carId: cart.id);
                    Provider.of<CartProvider>(context,listen: false).removeFromCartLocal( car!.id.toString());
              Provider.of<CartProvider>(context,listen: false).fetchAllCart();
              }),
              SizedBox(
                width: 8.w,
              ),
              CustomSlideAction(
              icon: Icons.edit,
              color: Colors.indigo,
              function: (check) async {

             final provider= Provider.of<CartProvider>(context,listen: false);
               final quantityProvider= Provider.of<QuantityProvider>(context,listen: false);

             await  provider.updateCart(carId: cart.carId, quantity: quantityProvider.getQuantity(cart.carId) );
             quantityProvider.setQuantityWithCarId(carId: cart.carId, value:quantityProvider.getQuantity(cart.carId) ,updateOriginal: true);


             if(provider.addCartItem.status==ApiStatus.ERROR){
              if(context.mounted){

              showSnackBar(context,message: provider.addCartItem.message.toString(),error: true);
              }
            }else{

            if(context.mounted){
              showSnackBar(
                context,
                message: "Cart quantity updated successfully",
              );
              Provider.of<CartProvider>(context,listen: false).fetchAllCart();

            }

            }


              }),




              ]),

          child: Container(
            decoration: buildBoxDecoration(borderRadius: 15, isBorderSide: false),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
              width: 90.w,
                height: 90.w,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(15.r)),
                child: appShimmerImage(cart.car?.images![0] ?? '')),
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 16.0.w,vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Name && order
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(car?.brand ??'honda',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.sp),)),
                          Icon(Icons.arrow_forward,color: Colors.grey,)
                        ],
                      ),
                      SizedBox(height: 18.h,),
                      //counter $ price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        AddRemoveBtn(countInStock: car?.quantityInStock ?? 0,carId:car?.id ?? 0 ,),
                        Flexible(child:
                        Text(convertCurrency(calculateTotalPrice(context)),
                          style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w400,color: Colors.grey),
                         overflow: TextOverflow.ellipsis,
                        ),


                        ),
                      ],)
                    ],
                  ),
                ),
              ),


                    ],
                  )
          ),
        ),

    );
  }
}
