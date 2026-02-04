import 'package:carmarketapp/core/utils/currency_helper.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/core/utils/shimmer_helper.dart';
import 'package:carmarketapp/models/api/cars/sold_car_model.dart';
import 'package:carmarketapp/screens/Widgets/car_sales_card.dart';
import 'package:carmarketapp/screens/Widgets/custom_app_bar.dart';
import 'package:carmarketapp/screens/Widgets/custom_not_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/helpers/api_helpers/api_response.dart';
import '../../../core/helpers/routers/router.dart';
import '../../../core/shimmer/shimmer_sold_cars.dart';
import '../../../core/strings/failure.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/sort.dart';
import '../../../providers/Dealer/cars_provider/cars_provider.dart';
import '../../Widgets/custom_error_widget.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen>
    with ImageHelper, CurrencyHelper, ShimmerHelper {
  int selectedOrder = 0;
  bool _isFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isFetched) {
      context.read<CarsProvider>().fetchAllSoldCars();
      _isFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<CarsProvider>(
          builder: (context, provider, _) {
            final response = provider.allSoldCars;

            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              children: [
                const CustomAppBar(text: "Sales"),
                _salesBar,

                /// 🔄 Loading
                if (response.status == ApiStatus.LOADING)
                  const ShimmerSoldCarsScreen(),

                /// ❌ Error
                if (response.status == ApiStatus.ERROR)
                  CustomErrorWidget(
                    isInternetConnection:
                    response.message == OFFLINE_FAILURE_MESSAGE,
                    text: response.message ?? 'Failed to load sales',
                    onTap: () => provider.fetchAllSoldCars(),
                  ),

                /// ✅ Completed
                if (response.status == ApiStatus.COMPLETED)
                  _buildSalesList(response.data),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 🔽 Sorting Bar
  Widget get _salesBar {
    return Align(
      alignment: Alignment.centerRight,
      child: DropdownButton<int>(
        value: selectedOrder,
        borderRadius: BorderRadius.circular(8.r),
        dropdownColor: Theme.of(context).hintColor,
        style: TextStyle(fontSize: 14.sp, color: kWhite),
        items: const [
          DropdownMenuItem(
            value: 0,
            child: Text('Latest first'),
          ),
          DropdownMenuItem(
            value: 1,
            child: Text("Oldest first"),
          )
        ],
        onChanged: (value) {
          if (value == null) return;
          setState(() => selectedOrder = value);
        },
      ),
    );
  }

  /// 🧾 Sales List
  Widget _buildSalesList(List<SoldCarModel>? sales) {
    if (sales == null || sales.isEmpty) {
      return const CustomNotFound(
        image: 'assets/images/linearchart.json',
        width: 450,
        text: 'No sales yet.',
      );
    }

    /// 🔥 Sorting ONCE (not inside itemBuilder)
    for (final sold in sales) {
      if (sold.cars != null) {
        sortByCreatedAt(
          sold.cars!,
              (car) => car.createdAt!,
          selectedOrder == 0,
        );
      }
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sales.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final sold = sales[index];

        if (sold.cars == null || sold.cars!.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: sold.cars!.map((car) {
            if (car.id == null) return const SizedBox.shrink();

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: CarSalesCard(
                soldCar: sold,
                car: car,
                onTap: () {
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
  }
}
