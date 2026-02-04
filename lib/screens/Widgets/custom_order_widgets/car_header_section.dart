import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/models/api/cars/car_api_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'car_specification_icons_row.dart';

class CarHeaderSection extends StatefulWidget {
  const CarHeaderSection({super.key, required this.car});
  final CarApiModel car;
  @override
  State<CarHeaderSection> createState() => _CarHeaderSectionState();
}

class _CarHeaderSectionState extends State<CarHeaderSection>  with SingleTickerProviderStateMixin, ImageHelper{
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 900),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Delay لنعمل تأثير ناعم بعد build
    Future.delayed(Duration(milliseconds: 400), () {
    if (!mounted) return; // تأكد إنه الـWidget لسا على الشاشة
      setState(() => _visible = true);
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * 0.45;
    final imageHeight = screenHeight * 0.28;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: WaveClipperTwo(flip: true),
          child: Container(
            height: headerHeight,
            color: kBlackColor,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 50.h),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => NavigationRoutes().pop(context),
                      child: const Icon(Icons.arrow_back_ios, color: kWhite),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Specification",
                      style: TextStyle(fontSize: 20.sp, letterSpacing: 3),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SpecificationIconsRow(
                  seats: widget.car.seats.toString(),
                  speed: widget.car.speed.toString(),
                  transmission: widget.car.transmission.toString(),
                ),
              ],
            ),
          ),
        ),
        PositionedDirectional(
          top: headerHeight * 0.60,
          start: 20.w,
          end: 20.w,
          child: AnimatedOpacity(
            opacity: _visible ? 1 : 0,
            duration: const Duration(milliseconds: 700),
            child: SlideTransition(
              position: _offsetAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: appShimmerImage(
                  widget.car.images?[0] ?? '',
                  height: imageHeight,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}


