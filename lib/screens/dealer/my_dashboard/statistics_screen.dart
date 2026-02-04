import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/core/utils/converter_helper.dart';
import 'package:carmarketapp/screens/Widgets/car_sales_card.dart';
import 'package:carmarketapp/screens/Widgets/custom_loading_widget.dart';
import 'package:carmarketapp/screens/Widgets/my_list_tile.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/helpers/routers/router.dart';
import '../../../core/strings/failure.dart';
import '../../../core/utils/constants.dart';
import '../../../providers/Dealer/statistics_provider/statistics_provider.dart';
import '../../Widgets/custom_error_widget.dart';
import '../../Widgets/custom_not_found.dart';
import '../brands_pie_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with ConverterHelper {

  String selectedMonth = 'January';

  @override
  void initState() {
    super.initState();
    _fetchTopBrands();
  }

  void _fetchTopBrands() {
    final provider = Provider.of<StatisticsProvider>(context, listen: false);
    final monthIndex = getMonthIndex(selectedMonth);
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => provider.getTopBrand(month: monthIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => NavigationRoutes().pop(context),
          child: Icon(
            Icons.arrow_back_ios_sharp,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: const Text(
          'Statistics',
          style: TextStyle(fontWeight: FontWeight.bold, color: kWhite),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Consumer<StatisticsProvider>(
          builder: (context, provider, child) {
            if (provider.getAllStatistics.status == ApiStatus.LOADING) {
              return const CustomLoadingWidget(width: 450);
            }

            if (provider.getAllStatistics.status == ApiStatus.ERROR) {
              return CustomErrorWidget(
                isInternetConnection:
                provider.getAllStatistics.message ==
                    OFFLINE_FAILURE_MESSAGE,
                text: provider.getAllStatistics.message ??
                    'Error fetching data',
                onTap: provider.getMonthsStatistics,
              );
            }

            final response = provider.getAllStatistics.data;
            if (response == null || response.data.isEmpty) {
              return const CustomNotFound(
                image: 'assets/images/linearchart.json',
                width: 450,
                text: 'No Sales Yet !',
              );
            }

            /// 🔹 حساب الإحصائيات (مُصلّح)
            final List<int> soldCars = [];
            final List<int> unsoldCars = [];
            final List<String> months = [];

            for (var monthData in response.data) {
              months.add(monthData.month);

              final soldCount = monthData.cars.fold<int>(
                0,
                    (sum, car) => sum + (car.quantitySold ?? 0),
              );

              final unsoldCount = monthData.cars.fold<int>(
                0,
                    (sum, car) => sum + (car.quantityInStock ?? 0),
              );

              soldCars.add(soldCount);
              unsoldCars.add(unsoldCount);
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 16.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildLegendItem(
                          color: Theme.of(context).primaryColor,
                          text: 'Cars Unsold',
                        ),
                        SizedBox(width: 10.w),
                        _buildLegendItem(
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.5),
                          text: 'Cars Sold',
                        ),
                      ],
                    ),
                  ),

                  _buildBarChart(
                    soldCars: soldCars,
                    unsoldCars: unsoldCars,
                    months: months,
                  ),

                  SizedBox(height: 24.h),
                  getTopBrand(),
                  SizedBox(height: 16.h),
                  _getTopCarSales,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// ================= Top Brands =================
  Widget getTopBrand() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Text(
                "Most Popular Brands",
                style: TextStyle(color: kWhite, fontSize: 14.sp),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                onSelected: (value) {
                  setState(() => selectedMonth = value);
                  _fetchTopBrands();
                },
                itemBuilder: (_) => monthsList
                    .map(
                      (month) => PopupMenuItem(
                    value: month,
                    child: Text(
                      month,
                      style:
                      TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                  ),
                )
                    .toList(),
                child: Row(
                  children: [
                    Text(
                      selectedMonth,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down,
                        color: Theme.of(context).primaryColor),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Consumer<StatisticsProvider>(
          builder: (_, provider, __) {
            if (provider.topBrand.status == ApiStatus.LOADING) {
              return const CustomLoadingWidget();
            }

            if (provider.topBrand.status == ApiStatus.ERROR) {
              return CustomErrorWidget(
                text: provider.topBrand.message ??
                    'Error fetching data',
                onTap: () => provider.getTopBrand(
                  month: getMonthIndex(selectedMonth),
                ),
              );
            }

            final data = provider.topBrand.data;
            if (data == null || data.soldCar!.isEmpty) {
              return const CustomNotFound(
                width: 450,
                text: 'Sorry, No Sales Yet !',
              );
            }

            return BrandsPieChart(data: data);
          },
        ),
      ],
    );
  }

  /// ================= Top Car Sales =================
  Widget get _getTopCarSales {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          MyListTile(context: context, title: '🏆 Top Car Sales'),
          SizedBox(height: 16.h),
          Consumer<StatisticsProvider>(
            builder: (_, provider, __) {
              if (provider.topBrand.status == ApiStatus.LOADING) {
                return const CustomLoadingWidget();
              }

              if (provider.topBrand.status == ApiStatus.ERROR) {
                return Text(
                  provider.topBrand.message ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                );
              }

              final data = provider.topBrand.data;
              if (data == null || data.soldCar!.isEmpty) {
                return const CustomNotFound(
                  width: 450,
                  text: 'Sorry, No Sales Yet !',
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.soldCar!.length,
                separatorBuilder: (_, __) => SizedBox(height: 4.h),
                itemBuilder: (_, index) {
                  final sold = data.soldCar![index];
                  return Column(
                    children: sold.cars!.map((car) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: CarSalesCard(
                          isStatisticScreen: true,
                          soldCar: sold,
                          car: car,
                          onTap: () {
                            if (!mounted || car.id == null) return;
                            NavigationRoutes().jump(
                              context,
                              Routes.showCarDetails,
                              arguments: {
                                'carId': car.id,
                                'isOfferScreen': false,
                                'review': car.averageRating,
                                'totalBuyer': sold.totalBuyers,
                                'totalReview': car.reviewCount,
                              },
                            );
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// ================= Chart =================
  Widget _buildLegendItem({required Color color, required String text}) {
    return Row(
      children: [
        CircleAvatar(radius: 8.r, backgroundColor: color),
        SizedBox(width: 4.w),
        Text(text),
      ],
    );
  }

  List<BarChartGroupData> _chartGroups({
    required List<int> soldCars,
    required List<int> unsoldCars,
  }) {
    return List.generate(soldCars.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: unsoldCars[index].toDouble(),
            color: Theme.of(context).primaryColor,
            width: 10,
          ),
          BarChartRodData(
            toY: soldCars[index].toDouble(),
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            width: 10,
          ),
        ],
      );
    });
  }

  Widget _buildBarChart({
    required List<int> soldCars,
    required List<int> unsoldCars,
    required List<String> months,
  }) {
    if (soldCars.isEmpty || months.isEmpty) {
      return const Center(child: Text("No Data Available"));
    }

    final maxSold = soldCars.reduce((a, b) => a > b ? a : b);
    final maxUnsold = unsoldCars.reduce((a, b) => a > b ? a : b);

    final maxY = (maxSold > maxUnsold ? maxSold : maxUnsold).toDouble() + 10;

    return SizedBox(
      height: 400.h,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barGroups:
          _chartGroups(soldCars: soldCars, unsoldCars: unsoldCars),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final index = value.toInt();
                  if (index < 0 || index >= months.length) {
                    return const SizedBox();
                  }
                  return Transform.rotate(
                    angle: -0.9,
                    child: Text(
                      months[index],
                      style:
                      const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
