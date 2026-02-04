import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/screens/Widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/helpers/routers/router.dart';
typedef Focus=Function(String);

class YearScrollView extends StatefulWidget {
  const YearScrollView({Key? key, required this.focus}) : super(key: key);
  final Focus focus;

  @override
  State<YearScrollView> createState() => _YearScrollViewState();
}

class _YearScrollViewState extends State<YearScrollView> {
  List<int> years = List.generate(
    126,
    (index) => 1900 + index,
  );
  int  _focusedItem=0 ;

  @override
  Widget build(BuildContext context) {
    return Column(
// mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.h),
          child: Text(
            "Release",
            style: TextStyle(fontSize: 16.sp, color: kWhite),
          ),
        ),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: years.length,
          
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    _focusedItem = index;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child: Container(
                    padding: index == _focusedItem
                        ? EdgeInsets.symmetric(horizontal: 20.h)
                        : null,
                    decoration: index == _focusedItem
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: Colors.grey)
                        : null,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${years[index]}',
                          style: TextStyle(
                              fontSize: _focusedItem == index ? 20.sp : 14.sp,
                              fontWeight: _focusedItem == index
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: kWhite),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          
            scrollDirection: Axis.vertical,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 4.h,
              );
            }, // Adjust item height as needed
          
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        // const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: CustomButton(title: 'Select',onTap: () { widget.focus(years[_focusedItem].toString());
          NavigationRoutes().pop(context);
            } , ),
        )
      ],
    );
  }
}
