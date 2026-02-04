import 'package:carmarketapp/screens/Widgets/custom_info_car.dart';
import 'package:flutter/material.dart';

class CustomCarDetails extends StatelessWidget {
  const CustomCarDetails({super.key, required this.seatsNum, required this.transmission, required this.fuelType});
  final String seatsNum;
  final String transmission;
  final String fuelType;


  @override
  Widget build(BuildContext context) {
    return                 Row(

      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: CustomInfoCar(
              path: 'seat',
              carInfo: '$seatsNum seats'),
        ),
        Flexible(
          child: CustomInfoCar(
              path: 'transmission_car',
              carInfo:  transmission),
        ),
        Flexible(
          child: CustomInfoCar(
              path: 'fuel',
              carInfo: fuelType),
        ),
      ],
    )
    ;
  }
}
