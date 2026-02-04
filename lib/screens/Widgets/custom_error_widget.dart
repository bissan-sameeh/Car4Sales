import 'package:carmarketapp/screens/Widgets/custom_not_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/constants.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key, required this.text, this.onTap, this.isInternetConnection=false});
  final String text;
  final Function()? onTap;
  final bool? isInternetConnection;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isInternetConnection==true ? CustomNotFound(image: 'assets/images/no_internet.json',text: text,): Icon(Icons.error, color: Colors.red, size: 50),
          SizedBox(height: 10.h),
          if (isInternetConnection!= true)Text(
            text ,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          ElevatedButton(

            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor) ),
            onPressed: onTap,
            child:  Text("Retry",style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
