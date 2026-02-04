import 'package:carmarketapp/providers/customer/cart/quantity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../custom_icon_quantity_button.dart';

class AddRemoveBtn extends StatefulWidget {
  AddRemoveBtn({super.key, required this.countInStock, this.carId});

  int countInStock;

  final int? carId;

  @override
  State<AddRemoveBtn> createState() => _AddRemoveBtnState();
}

class _AddRemoveBtnState extends State<AddRemoveBtn> {
  late int count = widget.countInStock;
  late int maxStock = widget.countInStock;



  @override
  Widget build(BuildContext context) {
    return Consumer<QuantityProvider>(
      builder: (BuildContext context, QuantityProvider provider, Widget? child) {
        final count = context.watch<QuantityProvider>().getQuantity(widget.carId ??0 );
        return Row(
          children: [
            IconQuantityButton(
              context: context,
              maxQuantity: maxStock,
              iconData: Icons.add,
              converter: 1,
              color: Colors.white30,
              carId: widget.carId ,

            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Text(
                count.toString(),
              ),
            ),
            IconQuantityButton(
              context: context,
              iconData: Icons.remove,
              color: Theme.of(context).primaryColor,
              converter: 0,
              maxQuantity: maxStock,
              carId: widget.carId ,
            ),
          ],
        );
      },
    );
  }
}
