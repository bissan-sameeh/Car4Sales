import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/core/utils/currency_helper.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/core/utils/style_helper.dart';
import 'package:carmarketapp/screens/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/helpers/api_helpers/api_response.dart';
import '../../../core/strings/failure.dart';
import '../../../providers/Dealer/cars_provider/cars_provider.dart';
import '../../Widgets/custom_error_widget.dart';
import '../../Widgets/custom_not_found.dart';
import '../../Widgets/offer_card_widget.dart';
import '../../../core/shimmer/shimmer_offer_screen.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen>
    with ImageHelper, StyleHelper, CurrencyHelper {
  bool _isFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isFetched) {
      context.read<CarsProvider>().fetchAllOffers();
      _isFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<CarsProvider>(
          builder: (context, carsProvider, _) {
            final response = carsProvider.allCars;

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const CustomAppBar(text: "Offers"),

                /// 🔄 Loading
                if (response.status == ApiStatus.LOADING)
                  const ShimmerOfferScreen(),

                /// ❌ Error
                if (response.status == ApiStatus.ERROR)
                  CustomErrorWidget(
                    isInternetConnection:
                    response.message == OFFLINE_FAILURE_MESSAGE,
                    text: response.message ?? 'Failed to load offers',
                    onTap: () => carsProvider.fetchAllOffers(),
                  ),

                /// ✅ Completed
                if (response.status == ApiStatus.COMPLETED)
                  _buildOffersList(response.data),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOffersList(List? cars) {
    if (cars == null || cars.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: CustomNotFound(
          width: 450,
          text: 'No offers available at the moment.',
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: cars.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final car = cars[index];
        if (car == null || car.id == null) {
          return const SizedBox.shrink();
        }

        return CarDetailsCard(
          isOfferScreen: true,
          isImage: true,
          offerCar: car,
          onTap: () {
            NavigationRoutes().jump(
              context,
              Routes.showCarDetails,
              arguments: {
                'carId': car.id,
                'isOfferScreen': true,
              },
            );
          },
        );
      },
    );
  }
}
