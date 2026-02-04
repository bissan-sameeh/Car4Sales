import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin ShowSnackBar {
  showSnackBar(BuildContext context,
      {required String message, bool error = false, int duration = 2}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,style:TextStyle(fontSize: 14.sp) ,),
      margin: const EdgeInsets.all(14),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: duration),
      backgroundColor: error == true ? Colors.red : Colors.green,
    ));
  }
}
