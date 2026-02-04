import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecificationIconsRow extends StatelessWidget with ImageHelper {
  const SpecificationIconsRow({super.key, required this.seats, required this.speed, required this.transmission});
  final String seats;
  final String speed;
  final String transmission;



  Widget buildSpec(BuildContext context, String path, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40.r,
          backgroundColor: Theme.of(context).hintColor,
          child: appSvgImage(
            path: path,
            color: Theme.of(context).primaryColor,
            height: 40.h,
            width: 40.h,
          ),
        ),
        SizedBox(height: 12.h),
        Text(label, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14.sp))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildSpec(context, 'seat', '$seats seats'),
        buildSpec(context, 'speed', '$speed k/m'),
        buildSpec(context, 'transmission_car', transmission),
      ],
    );
  }
}
