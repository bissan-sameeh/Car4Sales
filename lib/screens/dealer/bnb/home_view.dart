import 'package:carmarketapp/Cache/auth_storage.dart';
import 'package:carmarketapp/Cache/cache_controller.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/models/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/helpers/routers/router.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/enums.dart';
import '../../../providers/Dealer/revenue_prvider/revenue_provider.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with ImageHelper {
  int navBarSelectedIndex = 0;

  List<DashboardModel> get dashboard => [
        DashboardModel(
          icon: 'sales',
          title: 'Sales',
          color: kLightBlueColor,

        ),
        DashboardModel(
            icon:'car', title: 'Offer', color: kOrangeColor),
        DashboardModel(
            icon:'revenue', title: 'Revenue', color: kAmberColor),
        DashboardModel(
            icon: 'statistics',
            title: 'Statistics',
            color: kPinkColor),
      ];

  List<String> get screens=>[
   '/sales_Screen',
    '/offer_Screen',
     '/revenue_Screen',
     '/statistics_Screen'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Dealer car info
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35, // 20% من الشاشة
                child: Container(
                  margin:EdgeInsets.only(bottom: 40.h) ,
                  padding: EdgeInsetsDirectional.symmetric(
                      vertical: 20.h, horizontal: 16.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(   0xffc77936),
                          Color(0xffe5a11f),
                        ]),
                    borderRadius: BorderRadiusDirectional.only(
                        bottomStart: Radius.circular(70.r)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Hello ${CacheController().getter(User.username ) ??''}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.sp,
                                  color: kWhite),
                            ),
                            const Spacer(),
                            PopupMenuButton<int>(
                              color: Theme.of(context).hintColor,
                              icon: Icon(Icons.more_vert_outlined, color: kWhite, size: 40.r),
                              onSelected: (value) {
                                if (value == 0) {
                                  print("Logging out");
                                  CacheController().logout();
                                  NavigationRoutes().jump(context, Routes.loginScreen);
                                  // هنا يمكن استدعاء دالة تسجيل الخروج مثل:
                                  // AuthProvider().logout();
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 0,
                                  child: Row(
                                    children: [
                                      Icon(Icons.logout, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text("Logout",style: TextStyle(color: kWhite),),
                                    ],
                                  ),
                                ),
                              ],
                            )


                          ],
                        ),
                       const Spacer(),
                        Text(
                          "Today Sales",
                          style: TextStyle(color: kWhite, fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                "\$",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kWhite),
                              ),
                            ),
                            SizedBox(
                              width: 6.w,
                            ),
                            Consumer<RevenueProvider>(
                              builder: (context, revPro, child) {
                                return   Text(
                                  revPro.revenueMonthly.data?.totalRevenue.toString()?? '0.0' ,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kWhite,
                                    fontSize: 30,
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //Dashboard containers
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsetsDirectional.symmetric(
                    vertical: 16.h, horizontal: 16.w),
                itemCount: dashboard.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap:() =>  NavigationRoutes().jump(context,screens[index] ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: Theme.of(context).hintColor,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 50.w,
                                height: 50.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: dashboard[index].color,
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.centerRight,
                                        colors: [
                                          dashboard[index].color!,
                                          dashboard[index].color!.withOpacity(0.5),
                                        ]),
                                    boxShadow: [
                                      BoxShadow(
                                          color: dashboard[index].color!,
                                          blurRadius: 12,
                                          spreadRadius: -5,
                                          offset: const Offset(0, 2))
                                    ]),
                                child: appSvgImage(

                                  color: kWhite,
                                    path: dashboard[index].icon,
                                  width: 26.h,
                                  height: 26.h
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    dashboard[index].title! ?? '',
                                    style: TextStyle(
                                      color: kWhite,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  const Spacer(),
                                  appSvgImage(
                                    color: kWhite,
                                    path: 'arrow',
                                    width: 20,
                                    height: 20,
                                  )
                                ],
                              )
                            ]),
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 4.w, mainAxisSpacing: 8.h),
              ),
              //Bottom Nav Bar
              // Container(
              //   width: double.infinity,
              //   height: 70.h,
              //   margin: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 20),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(16.r),
              //     color: Theme.of(context).hintColor,
              //   ),
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //
              //     shrinkWrap: true,
              //     padding: EdgeInsetsDirectional.symmetric(
              //         horizontal: 4.w, vertical: 10.h),
              //     itemBuilder: (BuildContext context, int index) {
              //       return InkWell(
              //         onTap: () => setState(() => navBarSelectedIndex = index),
              //         child: Container(
              //           padding: checkSelectedNavBar(index)
              //               ? EdgeInsetsDirectional.symmetric(
              //                   horizontal: 20.w,
              //                   vertical: 0.h,
              //                 )
              //               : null,
              //           decoration: checkSelectedNavBar(index)
              //               ? BoxDecoration(
              //                   borderRadius: BorderRadius.circular(16.r),
              //                   gradient: LinearGradient(
              //                       begin: AlignmentDirectional.topStart,
              //                       end: AlignmentDirectional.centerEnd,
              //                       colors: [
              //                         Theme.of(context)
              //                             .primaryColor
              //                             .withOpacity(0.3),
              //                         Theme.of(context).primaryColor
              //                       ]))
              //               : null,
              //           child: Icon(
              //             dashboardNavBar[index].icon,
              //             color: kWhite,
              //             size: 30.h,
              //           ),
              //         ),
              //       );
              //     },
              //     itemCount: dashboardNavBar.length,
              //
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkSelectedNavBar(int index) => navBarSelectedIndex == index;
}

