import 'package:carmarketapp/core/utils/currency_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNamePriceWidget extends StatelessWidget with CurrencyHelper{
  const CustomNamePriceWidget({super.key, required this.name,  this.price});

  final String name;
  final String? price;


  @override
  Widget build(BuildContext context) {
    return   Row(
      children: [
        Expanded(child: Text(name,style: TextStyle(fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,)),
        // Spacer(),
        price!=null ? Text(convertCurrency(price),style: TextStyle(color:Theme.of(context).primaryColor,fontWeight: FontWeight.w300),):SizedBox()
      ],
    );
  }
}
