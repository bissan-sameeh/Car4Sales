import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/screens/Widgets/custom_error_widget.dart';
import 'package:carmarketapp/screens/Widgets/custom_loading_widget.dart';
import 'package:carmarketapp/screens/Widgets/rate_section/rate_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/failure.dart';
import '../../../providers/Dealer/seller_provider/seller_provider.dart';

class SellerProfile extends StatelessWidget with ImageHelper {


   SellerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SellerProvider>(
      builder: (BuildContext context, sellerPro, Widget? child) {
        if(sellerPro.seller.status ==ApiStatus.LOADING){
          return SafeArea(
            child: Column(
              children: [
                Text("Seller Info",style: TextStyle(fontSize: 24.h),),
                SizedBox(height: 12.h,),
                CustomLoadingWidget(width:450),
              ],
            ),
          );
        } else if(sellerPro.seller.status ==ApiStatus.ERROR){
          return CustomErrorWidget(text: sellerPro.seller.message.toString(),onTap:() async =>  await Provider.of<SellerProvider>(context,listen: false).fetchSellerData(),
            isInternetConnection: sellerPro.seller.message == OFFLINE_FAILURE_MESSAGE,
          );
        } if(sellerPro.seller.status ==ApiStatus.COMPLETED){
          var seller=sellerPro.seller.data;
          return SafeArea(
            child: Column(
              children: [

                Text("Seller Info",style: TextStyle(fontSize: 24.h),),
                SizedBox(height: 12.h,),

                CircleAvatar(
                  radius: 50.r,
                  backgroundColor: Theme.of(context).hintColor,
                  child: appSvgImage(path: 'user_icon'),
                ),
                SizedBox(height: 24.h,),

                Card(
                  color: Theme.of(context).hintColor,
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                          seller!.username.toString(),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.email, color: Colors.blue, size: 18),
                                  SizedBox(width: 5),
                                  Text(seller.email.toString(), style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.phone, color: Colors.green, size: 18),
                                  SizedBox(width: 5),
                                  Text(seller.whatsapp ??'059', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                                ],
                              ),
                              SizedBox(height: 5),
                              RateSection(rate: seller.averageStars?? 2,color: Theme.of(context).primaryColor,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox();
      },

    );
  }
}
