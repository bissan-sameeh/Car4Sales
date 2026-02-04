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
import '../../../models/api/cars/sold_car_model.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    int monthIndex = getMonthIndex(selectedMonth);
    final provider = Provider.of<StatisticsProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>   provider.getTopBrand(month: monthIndex));
  }

  String selectedMonth = 'January';

  final List<int> soldCars = [];
  final List<int> unsoldCars = [];
  final List<String> months = [];

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
        child:
            Consumer<StatisticsProvider>(builder: (context, provider, child) {
          if (provider.getAllStatistics.status == ApiStatus.LOADING) {
            return CustomLoadingWidget(width: 450,);
          } else if (provider.getAllStatistics.status == ApiStatus.ERROR) {
            return CustomErrorWidget(
              isInternetConnection: provider.getAllStatistics.message == OFFLINE_FAILURE_MESSAGE,

              text:  provider.getAllStatistics.message ?? 'Error fetching data',onTap:() =>  provider.getMonthsStatistics(),);

              Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 50),
                  SizedBox(height: 10.h),
                  Text(
                    provider.getAllStatistics.message ?? "Error fetching data",
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor) ),
                    onPressed: () => provider.getMonthsStatistics(),
                    child:  Text("Retry",style: TextStyle(color: kWhite),),
                  ),
                ],
              ),
            );
          } else {
            final response = provider.getAllStatistics.data;
            if (response == null || response.data.isEmpty) {

              return  CustomNotFound(
                    image:'assets/images/linearchart.json',

                width: 450,text: 'No Sales Yet !',);

            }
            List<int> soldCars = [];
            List<int> unsoldCars = [];
            List<String> months = [];
            for (var monthData in response.data) {
              months.add(monthData.month);
            }

            int totalSold = 0;
            int totalUnsold = 0;

            for (var sold in response.data) {
              totalSold =
                  sold.cars.fold(0, (sum, car) => sum + car.quantitySold!);
              totalUnsold =
                  sold.cars.fold(0, (sum, car) => sum + car.quantityInStock!);

              soldCars.add(totalSold);
              unsoldCars.add(totalUnsold);
              print(months);
              print(soldCars);
              print("uns $unsoldCars");
            }
            // for(int i=0;i<response.data.length;i++){
            // for (var car in response.data[i].cars) {
            //   totalSold += car.quantitySold!;
            //   totalUnsold += car.quantityInStock!;
            // }}

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.0.w, vertical: 16.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildLegendItem(
                            color: Theme.of(context).primaryColor,
                            text: 'Cars Unsold'),
                        SizedBox(
                          width: 10.w,
                        ),
                        _buildLegendItem(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            text: 'Cars Sold'),
                      ],
                    ),
                  ),

                  ///Bar char
                  _buildBarChart(
                      soldCars: soldCars,
                      unsoldCars: unsoldCars,
                      months: months),
                  SizedBox(
                    height: 24.h,
                  ),

                  ///Pie Chart
                   getTopBrand(),
                  SizedBox(
                    height: 16.h,
                  ),

                  ///most car
                  _getTopCarSales
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  Widget getTopBrand() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Row(
            children: [
              Text(
                "Most Popular Brands",
                style: TextStyle(color: kWhite, fontSize: 14.sp),
              ),
              const Spacer(),
              Theme(
                data: Theme.of(context).copyWith(
                    popupMenuTheme: PopupMenuThemeData(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        color: Theme.of(context).hintColor)),
                child: PopupMenuButton<String>(
                  onSelected: (value) => setState(() {
                    selectedMonth = value;
                    _fetchData();
                  }),
                  style: const ButtonStyle(
                      animationDuration: Duration(seconds: 1)),
                  itemBuilder: (context) => monthsList
                      .map(
                        (month) => PopupMenuItem(
                            value: month,
                            child: Text(
                              month,
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.white),
                            )),
                      )
                      .toList(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        selectedMonth,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 30.r,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Consumer<StatisticsProvider>(
          builder: (context, provider, child) {
            if (provider.topBrand.status == ApiStatus.LOADING) {
              return CustomLoadingWidget();
            }

            if (provider.topBrand.status == ApiStatus.ERROR) {
              return CustomErrorWidget(text:  provider.topBrand.message ?? 'Error fetching data',onTap:() =>  provider.getTopBrand(month: getMonthIndex(selectedMonth)));

              // return Center(
              //   child: Text(
              //     provider.topBrand.message!,
              //     style: TextStyle(color: Colors.white, fontSize: 16.sp),
              //   ),
              // );
            }

            final topBrands = provider.topBrand.data;
            // print('Top Brands: ${provider.topBrand.data!.soldCar?[0].brand}');
            print("map $topBrands");

            if (topBrands!.soldCar!.isEmpty) {
              return CustomNotFound(width: 450, text: 'Sorry, No Sales Yet !',);}
            print("map $topBrands");
            return BrandsPieChart(
              data: provider.topBrand.data,
            );
          },
        ),
      ],
    );
  }

  Widget get _getTopCarSales {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: Column(
        children: [
          MyListTile(context: context, title: '🏆 Top Car Sales'),
          SizedBox(
            height: 16.h,
          ),

           Consumer<StatisticsProvider>(
    builder: (context, provider, child) {
      if (provider.topBrand.status == ApiStatus.LOADING) {
        return CustomLoadingWidget();
      }

      if (provider.topBrand.status == ApiStatus.ERROR) {
        return Center(
          child: Text(
            provider.topBrand.message!,
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
        );
      }

      final topBrands = provider.topBrand.data;
      print("map $topBrands");

      if (topBrands!.soldCar!.isEmpty) {
       return CustomNotFound(width: 450, text: 'Sorry, No Sales Yet !',);

    }
      print("map $topBrands");
      return  ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 16.h),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            SoldCarModel sold = topBrands.soldCar![index];

            return  Column(
              children: sold.cars!.map((car) {
                return  Padding(
                  padding:  EdgeInsets.symmetric(vertical: 8.0.h),
                  child: CarSalesCard(
                    isStatisticScreen: true,
                    soldCar: sold,
                    onTap: () {
                      final carId = car.id;
                      if(mounted) {
                        if (carId != null) {
                          print("SSSSSSSSSSS $carId");

                          NavigationRoutes().jump(
                              context, Routes.showCarDetails,
                              arguments: {
                                'carId': carId, 'isOfferScreen': false,
                                'review': car.averageRating,
                                'totalBuyer': sold.totalBuyers,
                                'totalReview': car.reviewCount
                              });
                        }
                      }
                    },
                    car: car,
                  ),
                );
              },).toList());



          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 4.h,
            );
          },
          itemCount: topBrands.soldCar?.length?? 0,
        );
    })],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String text}) {
    return Row(children: [
      CircleAvatar(radius: 8.r, backgroundColor: color),
      SizedBox(
        width: 4.w,
      ),
      Text(text),
    ]);
  }

  List<BarChartGroupData>  _chartGroups (
      {required List<int> soldCars, required List<int> unsoldCars,required int length}){
    return List.generate(
     length,

      (index) {
        return BarChartGroupData(

            x: index,
            barRods: [
              BarChartRodData(
                  toY: unsoldCars[index].toDouble(),
                  color: Theme.of(context).primaryColor,
                  width: 10),
              BarChartRodData(
                  toY: soldCars[index].toDouble(),
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  width: 10),
            ],
            barsSpace: 0.w);
      },
    );
  }

  Widget _buildBarChart({
    required List<int> soldCars,
    required List<int> unsoldCars,
    required List<String> months,
  }) {
    if (soldCars.isEmpty || unsoldCars.isEmpty || months.isEmpty) {
      return const Center(child: Text("No Data Available"));
    }

    double maxY = soldCars.isNotEmpty
        ? (soldCars.reduce((a, b) => a > b ? a : b) + 10).toDouble()
        : 60;

    return Container(
      height: 400.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: BarChart(

        BarChartData(
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: (maxY / 5).ceilToDouble(),
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    );
                  },
                ),
              ),
              rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Transform.rotate(
                      angle: -0.9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          months[value.toInt()],
                          style:
                          const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                  reservedSize: 30,
                ),
              ),
            ),
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(enabled: true),
          maxY: maxY,
          barGroups: _chartGroups( soldCars: soldCars, unsoldCars: unsoldCars,length:months.length)),
            // return BarChartGroupData(
            //   x: index,
            //   barRods: [
            //     BarChartRodData(
            //       toY: unsoldCars[index].toDouble(),
            //       color: Theme.of(context).primaryColor,
            //       width: 10,
            //     ),
            //     BarChartRodData(
            //       toY: soldCars[index].toDouble(),
            //       color: Theme.of(context).primaryColor.withOpacity(0.5),
            //       width: 10,
            //     ),
            //   ],
            // );
          // }),

        ),
      );

  }

// Widget _buildBarChart(
//     {required List<int> soldCars,
//     required List<int> unsoldCars,
//     required List<String> months}) {
//   if (soldCars.isEmpty || unsoldCars.isEmpty || months.isEmpty) {
//     return Center(child: Text("No Data Available"));
//   }
//   return Container(
//     height: 400.h,
//     padding: EdgeInsets.symmetric(horizontal: 20.w),
//     child: BarChart(
//       BarChartData(
//         maxY: soldCars.isNotEmpty
//             ? (soldCars.reduce((a, b) => a > b ? a : b) + 10).toDouble()
//             : 60,
//         barGroups: List.generate(months.length, (index) {
//           return BarChartGroupData(
//             x: index,
//             barRods: [
//               BarChartRodData(
//                 toY: unsoldCars[index].toDouble(),
//                 color: Theme.of(context).primaryColor,
//                 width: 10,
//               ),
//               BarChartRodData(
//                 toY: soldCars[index].toDouble(),
//                 color: Theme.of(context).primaryColor.withOpacity(0.5),
//                 width: 10,
//               ),
//             ],
//           );
//         }),
//         titlesData: FlTitlesData(
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               interval: 10,
//               getTitlesWidget: (value, meta) {
//                 return Text(value.toInt().toString(),
//                     style: const TextStyle(fontSize: 12, color: Colors.grey));
//               },
//             ),
//           ),
//           rightTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: false,
//             ),
//           ),
//           topTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: false,
//             ),
//           ),
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 return Transform.rotate(
//                   angle: -0.9,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Text(months[value.toInt()],
//                         style: const TextStyle(
//                             fontSize: 10, color: Colors.grey)),
//                   ),
//                 );
//               },
//               reservedSize: 30,
//             ),
//           ),
//         ),
//         gridData: const FlGridData(show: false),
//         borderData: FlBorderData(show: false),
//         barTouchData: BarTouchData(enabled: true),
//       ),
//     ),
//   );
// }
}
