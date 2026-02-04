import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/core/utils/snckbar.dart';
import 'package:carmarketapp/providers/Dealer/cars_provider/cars_provider.dart';
import 'package:carmarketapp/providers/customer/cart/quantity_provider.dart';
import 'package:carmarketapp/screens/Widgets/custom_button.dart';
import 'package:carmarketapp/screens/Widgets/custom_error_widget.dart';
import 'package:carmarketapp/screens/Widgets/custom_loading_widget.dart';
import 'package:carmarketapp/stripe_payment/payment_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Widgets/custom_no_data.dart';
import '../../Widgets/custom_order_widgets/car_header_section.dart';

class CustomerPlaceOrder extends StatefulWidget with ImageHelper {
  const CustomerPlaceOrder({super.key});

  @override
  State<CustomerPlaceOrder> createState() => _CustomerPlaceOrderState();
}

class _CustomerPlaceOrderState extends State<CustomerPlaceOrder>
    with ShowSnackBar {
  int? carId;
  int? cartId;
  bool _locked = false;
  bool _initialized = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_initialized) return;

      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args == null || args['carId'] == null) return;

      carId = args['carId'];
      cartId = args['cartId'];
      _initialized = true;

      context.read<CarsProvider>().fetchSingleCar(carId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade500,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Consumer<CarsProvider>(
                builder: (context, carsProvider, child) {
                  if (carsProvider.singleCar.status == ApiStatus.LOADING) {
                    return const Center(
                      child: CustomLoadingWidget(
                        width: 400,
                      ),
                    );
                  } else if (carsProvider.singleCar.status == ApiStatus.ERROR) {
                    return Padding(
                      padding: EdgeInsets.all(20.w),
                      child: CustomErrorWidget(
                        text: carsProvider.singleCar.message.toString(),
                        onTap: () async {
                          await carsProvider.fetchSingleCar(carId.toString());
                        },
                      ),
                    );
                  } else {
                    final car = carsProvider.singleCar.data;
                    if (car == null) {
                      return const CustomNoData(
                        text: 'Car not found',
                      );
                    }

                    final quantity =
                    context.watch<QuantityProvider>().getQuantity(car.id!);
                    final unitPrice = car.price ?? 0;
                    final totalPrice = unitPrice * quantity;

                    return Column(
                      children: [
                        // Car Header Section
                        CarHeaderSection(car: car),
                        SizedBox(height: 120.h),

                        // Car Details Section - ألوان غامقة مع نص فاتح
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: kLightBlackColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Car Specifications',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[100],
                                ),
                              ),
                              SizedBox(height: 12.h),
                              _buildDetailRow('Brand', car.brand ?? 'N/A'),
                              SizedBox(height: 8.h),
                              _buildDetailRow('Type', car.carType ?? 'N/A'),
                              SizedBox(height: 8.h),
                              _buildDetailRow(
                                'Climate',
                                car.climate == true ? 'Available' : 'Not Available',
                              ),
                              SizedBox(height: 8.h),
                              _buildDetailRow('Battery', '${car.battery ?? 0}%'),
                              SizedBox(height: 8.h),
                              _buildDetailRow('Location', car.country ?? 'N/A'),
                              SizedBox(height: 8.h),
                              _buildDetailRow(
                                'Car ID',
                                car.id?.toString() ?? 'N/A',
                              ),
                            ],
                          ),
                        ),

                        // Order Summary Section - ألوان غامقة مع نص فاتح
                        Container(
                          margin: EdgeInsets.all(16.w),
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: kLightBlackColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Summary',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[100],
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Unit Price:',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  Text(
                                    '\$${car.price?.toStringAsFixed(2) ?? '0.00'}',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[100],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Quantity:',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  Text(
                                    quantity.toString(),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[100],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey[700],
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Amount:',
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[100],
                                    ),
                                  ),
                                  Text(
                                    '\$${totalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                      color: kAmberColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Checkout Button
                        Container(
                          margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                          child: CustomButton(
                            onTap: () async {
                              if (_locked) return;
                              setState(() => _locked = true);

                              try {
                                final paymentResult =
                                await PaymentManager.makePayment(
                                  carId: car.id!,
                                  totalPrice: totalPrice,
                                  quantity: quantity,
                                );


                                if (paymentResult.isSuccess) {
                                  if (context.mounted) {
                                    NavigationRoutes().pushUntil(
                                      context,
                                      Routes.pendingOrderScreen,
                                      arguments: {
                                        "carId": carId,
                                        "cartId": cartId
                                      },
                                    );
                                  }
                                } else if (paymentResult.isCanceled) {
                                  if (context.mounted) {
                                    showSnackBar(
                                      context,
                                      message: 'Payment cancelled',
                                      error: true,
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    NavigationRoutes().jump(
                                      context,
                                      Routes.paymentFailedScreen,
                                      arguments: {
                                        'errorMessage':
                                        paymentResult.message ?? 'Unknown error',
                                        'amount': car.price!,
                                        'carName': car.brand ?? 'Unknown Car',
                                      },
                                    );
                                  }
                                }
                              } catch (_) {
                                if (context.mounted) {
                                  showSnackBar(
                                    context,
                                    message:
                                    'An error occurred during payment. Please try again.',
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() => _locked = false);
                                }
                              }
                            },
                            title: "Proceed to Checkout",
                            loading: _locked,
                            color: kAmberColor,
                          ),
                        ),

                        // Safe area padding
                        SizedBox(
                            height: MediaQuery.of(context).padding.bottom),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[400],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey[200],
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}