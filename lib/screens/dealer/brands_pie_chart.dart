import 'package:carmarketapp/models/api/cars/car_base_response.dart';
import 'package:carmarketapp/models/api/cars/sold_car_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandsPieChart extends StatelessWidget {
  final CarBaseResponse? data;

  const BrandsPieChart({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final soldCars = data?.soldCar ?? [];

    if (soldCars.isEmpty) {
      return Center(
        child: Text(
          "No Sales Yet!",
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      );
    }

    final salesPerBrand = _calculateSoldPerBrand(soldCars);
    final chartSections = _buildSections(salesPerBrand);

    return SizedBox(
      height: 400.h,
      child: PieChart(
        PieChartData(
          sections: chartSections,
          sectionsSpace: 2,
          centerSpaceRadius: 70,
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  /// ================= Calculate =================
  Map<String, int> _calculateSoldPerBrand(
      List<SoldCarModel> cars) {
    final Map<String, int> result = {};

    for (final car in cars) {
      final brand = car.brand ?? 'Unknown';
      result[brand] = (result[brand] ?? 0) + 1;
    }

    return result;
  }

  /// ================= Sections =================
  List<PieChartSectionData> _buildSections(
      Map<String, int> brandSales) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.amber,
    ];

    int index = 0;

    return brandSales.entries.map((entry) {
      final section = PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${entry.key}\n${entry.value}',
        color: colors[index % colors.length],
        radius: 70,
        titleStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
      index++;
      return section;
    }).toList();
  }
}
