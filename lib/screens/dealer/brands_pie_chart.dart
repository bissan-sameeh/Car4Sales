import 'package:carmarketapp/models/api/cars/car_base_response.dart';
import 'package:carmarketapp/models/api/cars/sold_car_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class BrandsPieChart extends StatefulWidget {
  final CarBaseResponse? data;

  const BrandsPieChart({super.key, this.data});

  @override
  State<BrandsPieChart> createState() => _BrandsPieChartState();
}

class _BrandsPieChartState extends State<BrandsPieChart> {
  List<Map<String, dynamic>> topBrands = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }





  @override
  Widget build(BuildContext context) {

        if(widget.data!.soldCar!.isEmpty){
         return Center(
            child: Text(
              "No Sales Yet !",
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          );


        } return _buildPieChart;

  }

  Widget get _buildPieChart {

        return SizedBox(
          height: 400.h,
          child: PieChart(
            PieChartData(
              sections: _getSections(widget.data!.soldCar!.toSet().toList()),
              sectionsSpace: 2,
              centerSpaceRadius: 70,
              borderData: FlBorderData(show: false),
              startDegreeOffset: 0,
              pieTouchData: PieTouchData(
                touchCallback: (p0, p1) => setState(() {}),
              ),
            ),
          ),
        );


  }
  List<PieChartSectionData> _getSections(List<SoldCarModel>? topBrands) {
    final List<Color> colors = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple];

    return topBrands!.asMap().entries.map((entry) {
      int index = entry.key;
      SoldCarModel brandData = entry.value;

      print("in $index");

      // print(brandData);
      return PieChartSectionData(
        value: brandData.totalSold?.toDouble() ??0.0,
        title: '${brandData.brand}\n${brandData.totalSold}',
        color: colors[index % colors.length],
        radius: 70,
        titleStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
      );
    }).toList();
  }
}
