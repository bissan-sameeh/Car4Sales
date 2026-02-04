import 'package:carmarketapp/models/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/utils/constants.dart';

typedef NavBar = Function(int);

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar(
      {super.key,
      required this.index,
      required this.onTap,
      required this.items});

  final int index;
  final NavBar onTap;
  final List<DashboardModel> items;

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60.h,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 20),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Theme.of(context).hintColor,
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.items.map(
            (item) {
              int index = widget.items.indexOf(item);
              bool selected = widget.index == index;
              return InkWell(
                onTap: () => widget.onTap(index),
                child: Container(
                  padding: selected
                      ? EdgeInsetsDirectional.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        )
                      : null,
                  decoration: selected
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          gradient: kGradient)
                      : null,
                  child:item.icon.runtimeType==String ? SvgPicture.asset(
                    'assets/icons/${item.icon}.svg',
                    colorFilter:
                        const ColorFilter.mode(kWhite, BlendMode.srcIn),
                    width:selected ? 35.h :25.h,
                    height: selected?35.h:25.h,
                  ):Icon(item.icon,color: kWhite,size: 30.r,),
                ),
              );
            },
          ).toList()),
    );
  }
}
