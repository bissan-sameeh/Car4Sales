import 'package:carmarketapp/Cache/cache_controller.dart';
import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/providers/customer/cart/cart_provider.dart';
import 'package:carmarketapp/screens/Widgets/custom_error_widget.dart';
import 'package:carmarketapp/screens/Widgets/customer_home_widgets/customer_home_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/enums.dart';
import '../../../providers/auth/auth_provider.dart';
import '../../../providers/customer/customer_cars_provider/customer_cars_provider.dart';
import '../../../providers/customer/favorite/favorite_provider.dart';
import '../../Widgets/custom_customer_home.dart';
import '../../Widgets/custom_loading_widget.dart';
import '../../Widgets/custom_not_found.dart';

class CustomerHomeView extends StatefulWidget {
  const CustomerHomeView({super.key});

  @override
  State<CustomerHomeView> createState() => _CustomerHomeViewState();
}

class _CustomerHomeViewState extends State<CustomerHomeView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     Provider.of<FavoriteProvider>(context,listen: false).isFavScreen(false);
     Provider.of<CartProvider>(context,listen: false).isCartScreen(false);
   },);

  }


  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Padding(
          padding:  EdgeInsets.only(top: 16.0.h),
          child: Row(
            children: [
              Text("Hello ${context.watch<AuthProvider>().username ?? ''}",style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),
              Spacer(),
             PopupMenuButton(
               color:Theme.of(context).hintColor,

                     child: Icon(
                       Icons.more_vert_outlined,color: Theme.of(context).hintColor,),

                 itemBuilder: (context) => [
                   PopupMenuItem(
                       onTap: () {
                         NavigationRoutes().jump(context, Routes.updateScreen);

                       },
                       child: ListTile( title: Text("Update",style: TextStyle(color: kWhite),),leading: Icon(Icons.person,color: kWhite,),)),

                   PopupMenuItem(
onTap: () async {
  await CacheController().logout();
  if(context.mounted){

  context.read<FavoriteProvider>().clear();
  context.read<CartProvider>().clear();
  NavigationRoutes().pushUntil(context, Routes.loginScreen);
  }

},
                   child: ListTile( title: Text("Logout",style: TextStyle(color: kWhite),),leading: Icon(Icons.logout,color: Colors.redAccent,),)),
             ],

          ),
        ]),),
       flexibleSpace: Container(
        decoration: BoxDecoration(
        gradient: kGradient,
    ),
      ),

    ),
    body: SingleChildScrollView(
      child: Column(
            children:
            [
              CustomCustomerHome(),

              SizedBox(height: 16.h,),
        Consumer<CustomerCarsProvider>(
          builder: (context, sellerCarProvider, child) {
            if (sellerCarProvider.allSellerCars.status == ApiStatus.LOADING) {
              return CustomLoadingWidget(width: 400);
            }

            if (sellerCarProvider.allSellerCars.status == ApiStatus.ERROR) {
              return CustomErrorWidget(
                text: sellerCarProvider.allSellerCars.message.toString(),
                onTap: () async {
                  await sellerCarProvider.fetchSellerCars();
                },
              );
            }

            final cars = sellerCarProvider.cars;

            /// 🔍 حالة  بدون نتائج
            if (cars.isEmpty) {
             return CustomNotFound(image: 'assets/images/search_not_found.json',width: 450,text: "No cars found",);

            }

            ///  الحالة الطبيعية
            return CustomerHomeList(carList: cars);
          },
        )
         ])));




  }}
