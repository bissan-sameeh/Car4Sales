import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/screens/Widgets/custom_container.dart';
import 'package:carmarketapp/screens/Widgets/my_list_tile.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../../../core/strings/failure.dart';
import '../../../providers/Dealer/revenue_prvider/revenue_provider.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_error_widget.dart';
import '../../Widgets/custom_loading_widget.dart';
import '../../Widgets/custom_not_found.dart';

class RevenueScreen extends StatelessWidget {
  const RevenueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Column(children: [
            CustomAppBar(text: 'Revenue'),
            // SizedBox(height: 90.h),

            Consumer<RevenueProvider>(
                builder: (context, revenueProvider, child) {
              final revenues = revenueProvider.revenueValues;
              final months = revenueProvider.monthsList;
              final double totalRevenue = revenueProvider.totalRevenue;

              if (revenueProvider.revenueMonthly.status == ApiStatus.LOADING) {
                return CustomLoadingWidget(width: 450);
              } else if (revenueProvider.revenueMonthly.status == ApiStatus.ERROR) {
                return CustomErrorWidget(
                    isInternetConnection: revenueProvider.revenueMonthly.message == OFFLINE_FAILURE_MESSAGE,

                    text:  revenueProvider.revenueMonthly.message ?? 'Error fetching data',onTap:() =>  revenueProvider.fetchMonthlyRevenue());
              } else if (revenueProvider.revenueMonthly.status == ApiStatus.COMPLETED) {
                if (revenues.isEmpty) {
                  return CustomNotFound(
                   image:'assets/images/linearchart.json',
                    width: 450,
                    text: 'Sorry, No Sales Yet !',
                  );

                  print(totalRevenue);
                  print(months);
                  print(revenues);
                  return const CircularProgressIndicator();
                }

                return Column(
                  children: [
                    SizedBox(
                        width: double.infinity,
                        child: CustomContainer(
                          title: "Total Revenue",
                          preTileIcon: 'revenue',
                          widget: Text(
                            '$totalRevenue' ,
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w400),
                          ),
                        )),
                    SizedBox(
                      height: 50.h,
                    ),
                    MyListTile(
                      title: "Monthly Revenue",
                      context: context,
                    ),
                    SizedBox(
                      height: 100.h,
                    ),
                    AspectRatio(
                      aspectRatio: 1.9,
                      child: _lineChart(revenues, months, context),
                    ),
                  ],
                );
              }

              return SizedBox();
            })
          ]),
        ),
      ),
    );
  }

  Widget _lineChart(
      List<double> revenues, List<String> months, BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: months.length - 1,
        minY: revenues.reduce((a, b) => a < b ? a : b) - 5000,
        maxY: revenues.reduce((a, b) => a > b ? a : b) + 5000,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(revenues.length,
                (index) => FlSpot(index.toDouble(), revenues[index])),
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 4.w,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).primaryColor.withOpacity(0.4),
            ),
          ),
        ],
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 70,
              interval: 5000,
              getTitlesWidget: (value, meta) {
                if (revenues.contains(value.toDouble())) {
                  print(revenues);
                  return Padding(
                    padding: EdgeInsets.only(right: 8.0.w),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${value.toInt()}',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return Transform.rotate(
                    angle: -0.4,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0.h),
                      child: Text(
                        months[value.toInt()],
                        style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
