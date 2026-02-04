import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/screens/Widgets/custom_container.dart';
import 'package:carmarketapp/screens/Widgets/my_list_tile.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/failure.dart';
import '../../../providers/Dealer/revenue_prvider/revenue_provider.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_error_widget.dart';
import '../../Widgets/custom_loading_widget.dart';
import '../../Widgets/custom_not_found.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<RevenueProvider>().fetchMonthlyRevenue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<RevenueProvider>(
          builder: (context, provider, _) {
            final response = provider.revenueMonthly;

            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              children: [
                const CustomAppBar(text: 'Revenue'),

                /// 🔄 Loading
                if (response.status == ApiStatus.LOADING)
                  const CustomLoadingWidget(width: 450),

                /// ❌ Error
                if (response.status == ApiStatus.ERROR)
                  CustomErrorWidget(
                    isInternetConnection:
                    response.message == OFFLINE_FAILURE_MESSAGE,
                    text: response.message ?? 'Failed to load revenue data',
                    onTap: () => provider.fetchMonthlyRevenue(),
                  ),

                /// ✅ Completed
                if (response.status == ApiStatus.COMPLETED)
                  _buildRevenueContent(provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRevenueContent(RevenueProvider provider) {
    final revenues = provider.revenueValues;
    final months = provider.monthsList;
    final totalRevenue = provider.totalRevenue;

    if (revenues.isEmpty || months.isEmpty) {
      return const CustomNotFound(
        image: 'assets/images/linearchart.json',
        width: 450,
        text: 'No sales data available yet.',
      );
    }

    final minRevenue = revenues.reduce((a, b) => a < b ? a : b);
    final maxRevenue = revenues.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomContainer(
          title: "Total Revenue",
          preTileIcon: 'revenue',
          widget: Text(
            totalRevenue.toStringAsFixed(2),
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 32.h),

        MyListTile(
          title: "Monthly Revenue",
          context: context,
        ),
        SizedBox(height: 24.h),

        AspectRatio(
          aspectRatio: 1.9,
          child: _lineChart(
            revenues,
            months,
            minRevenue,
            maxRevenue,
            context,
          ),
        ),
      ],
    );
  }

  Widget _lineChart(
      List<double> revenues,
      List<String> months,
      double minRevenue,
      double maxRevenue,
      BuildContext context,
      ) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (months.length - 1).toDouble(),
        minY: (minRevenue * 0.9).clamp(0, double.infinity),
        maxY: maxRevenue * 1.1,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              revenues.length,
                  (i) => FlSpot(i.toDouble(), revenues[i]),
            ),
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 4.w,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ),
        ],
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxRevenue / 4,
              getTitlesWidget: (value, _) => Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) {
                final index = value.toInt();
                if (index < 0 || index >= months.length) {
                  return const SizedBox.shrink();
                }
                return Transform.rotate(
                  angle: -0.4,
                  child: Text(
                    months[index],
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
