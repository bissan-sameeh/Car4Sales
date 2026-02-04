import 'dart:ui';

import 'package:carmarketapp/core/shimmer/shimmer_offer_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CustomSlideAction extends StatelessWidget {
  const CustomSlideAction({super.key,  required this.color, required this.icon, this.function,
  });
  final Color color;
  final Function(dynamic)? function;
  final   IconData icon;


  @override
  Widget build(BuildContext context) {
      return SlidableAction(
        flex: 9,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h), // 👈 تقليل البادينغ لزيادة الحجم المرئي
      borderRadius: BorderRadius.circular(15),
      onPressed: function,
      icon: icon,
      backgroundColor: color,

    );
  }
}
