import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/screens/Widgets/my_list_tile.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/helpers/routers/router.dart';
import '../../../providers/customer/customer_cars_provider/customer_cars_provider.dart';
import 'custom_filter_btn.dart';

class CustomFilterDialog extends StatefulWidget {
  const CustomFilterDialog({super.key});

  @override
  State<CustomFilterDialog> createState() => _CustomFilterDialogState();
}

class _CustomFilterDialogState extends State<CustomFilterDialog> {


  @override
  Widget build(BuildContext context) {
    return Dialog(

      backgroundColor: kBlackColor,
      insetPadding:  EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              "Filter",
              style: TextStyle(
                  color: kWhite,
                  fontWeight: FontWeight.w900,
                  fontSize: 18.sp,
                  letterSpacing: 10),
            )),
            SizedBox(
              height: 12.h,
            ),
            Text(
              "Country",
              style: TextStyle(
                  fontSize: 16.sp, color: kWhite, fontWeight: FontWeight.w300),
            ),
            InkWell(
              onTap: () {
                showCountryPicker(
                    context: context,
                    countryListTheme: CountryListThemeData(
                      flagSize: 25,
                      backgroundColor: Theme.of(context).hintColor,
                      textStyle: const TextStyle(fontSize: 16, color: kWhite),
                      bottomSheetHeight: MediaQuery.of(context).size.height / 2,

                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),

                      //Optional. Styles the search field.
                      inputDecoration: InputDecoration(
                          labelText: 'Search',
                          hintText: 'Start typing to search',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Theme.of(context).primaryColor,
                          ),
                          focusColor: Theme.of(context).primaryColor,
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          focusedBorder: buildOutLinedInputBorder(
                              color: Theme.of(context).primaryColor),
                          border: buildOutLinedInputBorder(
                              color: kGrayColor.withOpacity(0.2))),
                    ),
                    onSelect: (Country country) => setState(() {
                      context.read<CustomerCarsProvider>().changeCountry( country.name);
                          // print('Select country: ${country.displayName}');
                        }));
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 16.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Theme.of(context).hintColor,
                ),
                child: MyListTile(
                  colorTextTitle: kWhite,
                  context: context,
                  title:  context.watch<CustomerCarsProvider>().selectedCountry ??"",
                  isLocate: true,
                  preIcon: 'arrow',
                  suffixIcon: Icons.add_location,
                  fountSize: 12.5,
                  suffixSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
              "Transmission Type",
              style: TextStyle(
                  fontSize: 16.sp, color: kWhite, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 12.h,
            ),
            GestureDetector(


              onTapDown: (TapDownDetails details) async {

                final selected = await showMenu<String>(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                  ),
                  color: Theme.of(context).hintColor,
                  items: [
                    PopupMenuItem<String>(
                      value: 'Transmission',

                      child: Text('Transmission',style: TextStyle(color: kWhite),),
                    ),
                    PopupMenuItem<String>(
                      value: 'Manual',
                      child: Text('Manual',style: TextStyle(color: kWhite),),
                    ),
                  ],
                );

                if (selected != null) {
                  // TODO: handle selection
                  print('Selected: $selected');
                  context.read<CustomerCarsProvider>().changeTransmission( selected);

                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Theme.of(context).hintColor,
                ),
                child: MyListTile(
                  colorTextTitle: kWhite,
                  context: context,
                  title: context.watch<CustomerCarsProvider>().selectedTransmission ??'Manual' ,
                  suffixIcon: Icons.arrow_drop_down,
                  fountSize: 12.5,
                ),
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Text(
              "Price",
              style: TextStyle(
                  fontSize: 16.sp, color: kWhite, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 12.h,
            ),
            GestureDetector(
              onTapDown: (TapDownDetails details) async {

                final selected = await showMenu<String>(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                  ),
                  color: Theme.of(context).hintColor,
                  items: [
                    PopupMenuItem<String>(
                      value: 'low',

                      child: Text('Lowest to highest',style: TextStyle(color: kWhite),),
                    ),
                    PopupMenuItem<String>(
                      value: 'high',
                      child: Text('Highest to lowest',style: TextStyle(color: kWhite),),
                    ),
                  ],
                );

                if (selected != null) {
                  // TODO: handle selection
                  print('Selected: $selected');
                  context.read<CustomerCarsProvider>().changePrice(selected);

                }
              },

              child: Container(
                width: double.infinity,
                // margin: EdgeInsets.symmetric(vertical: 16.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Theme.of(context).hintColor,
                ),
                child: MyListTile(
                  colorTextTitle: kWhite,
                  context: context,
                  title: context.watch<CustomerCarsProvider>().selectedPriceSort ??'low' ,
                  suffixIcon: Icons.arrow_drop_down,
                  fountSize: 12.5,
                ),
              ),
            ),
            SizedBox(
              height: 24.w,
            ),
            Row(
              children: [
                CustomFilterBtn(text: 'Reset',
                onTap: () {
                  context.read<CustomerCarsProvider>().resetFilters();
                  Navigator.pop(context);
                },
                ),

                SizedBox(
                  width: 6.w,
                ),
                CustomFilterBtn(text: 'Apply',color: Theme.of(context).primaryColor,
                  onTap:  () {
                    context.read<CustomerCarsProvider>().applyFilters(
                      country:     context.read<CustomerCarsProvider>().selectedCountry !=  "Local"?  context.read<CustomerCarsProvider>().selectedCountry  : null,
                      transmission: context.read<CustomerCarsProvider>().selectedTransmission  != 'Transmission' ?  context.read<CustomerCarsProvider>().selectedTransmission  : null,
                      priceSort: context.read<CustomerCarsProvider>().selectedPriceSort,
                    );
                    Navigator.pop(context);
                  }

                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

