import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/snckbar.dart';
import '../../providers/customer/cart/quantity_provider.dart';

class IconQuantityButton extends StatelessWidget with ShowSnackBar{
  const IconQuantityButton({
    super.key,
    required this.context,
    required this.iconData,
    required this.converter,
    this.color = const Color(0xFF31363F),
    this.radius = 15,
    required this.maxQuantity, this.carId,
  });

  final BuildContext context;
  final IconData iconData;
  final int converter;
  final Color? color;
  final double? radius;
  final int maxQuantity;
  final int? carId;

  @override
  Widget build(BuildContext context) {
    return Consumer<QuantityProvider>(
      builder: (context, quantityProvider, child) {
        return InkWell(
          onTap: () {
            final count = quantityProvider.getQuantity(carId!);
            if (converter == 1) {
              // إضافة
              if (count >= maxQuantity) {
                showSnackBar(context, message: 'There is no more quantity in stock!', error: true);
              } else {
                print("adddddddddddddd");
                bool result = quantityProvider.increaseQuantity(carId ?? 0 ,maxQuantity);
                if(!result){
                  showSnackBar(context, message: 'There is no more quantity in stock!', error: true);

                }
              }
            } else {
              // إنقاص
              if (count > 0) {
                print("count >0 $count");
                print("kkkkkkkkkkkkkkkkkkkkkkkk");
                final result =quantityProvider.decreaseQuantity( carId: carId ??0,);
                if(!result){
                  showSnackBar(context, message: 'Cannot be less than one!', error: true);

                }
              } else {
                print("count <0 $count");
                print("kkkkkkkkkkkkkkkkkkkkkkkk");
                showSnackBar(context, message: 'Cannot be less than zero!', error: true);
              }
            }
          },
          child: CircleAvatar(
            radius: radius,
            backgroundColor: color,
            child: Icon(
              iconData,
              color: color == kWhite ? Theme.of(context).hintColor : kWhite,
            ),
          ),
        );
      },
    );
  }
}
