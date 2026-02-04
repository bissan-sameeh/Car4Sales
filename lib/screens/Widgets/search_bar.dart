import 'package:carmarketapp/screens/Widgets/customer_home_widgets/custom_filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'my_text_field.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.searchController, this.isBrandScreen=false, this.hint, this.onChanged,
  });
  final Function(String)? onChanged;
  final bool? isBrandScreen;
  final String? hint;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 24.h),
          child: Row(
              children:
              [
                Expanded(
                  child: MyTextField(
                    hint:hint?? 'Car Type!',
                    prefixIcon: "search",
                    controller: searchController,
                    textInputAction: TextInputAction.send,
                    onChanged: onChanged,
                    prefixColor: Colors.white30,

                    isOutlinedBorder: true,
                    bottomContentPadding: 16,
                    topContentPadding: 16,
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(context: context, builder: (context) {

                      return  CustomFilterDialog();
                    },);
                  },
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
                    child: Image.asset('assets/icons/filter.png',color: Theme.of(context).hintColor,),
                  ),
                )
              ]),
        ),
        // !isBrandScreen!  ?Divider(
        //     thickness: 1, height: 20, color: kGrayColor.withOpacity(0.2)):SizedBox.shrink(),
      ],
    );
  }
}
