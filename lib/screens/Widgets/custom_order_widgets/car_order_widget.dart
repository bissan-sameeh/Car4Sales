import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderCompletedCard extends StatelessWidget with ImageHelper {
  final Map<String, dynamic> order;

  const OrderCompletedCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final car = order['car'] as Map<String, dynamic>;
    final seller = car['seller'] as Map<String, dynamic>;
    final createdAt = DateTime.parse(order['createdAt']);

    return GestureDetector(
      onTap: () => NavigationRoutes().jump(
          context,
          Routes.showCarDetails,
          arguments: {"carId": car['id']}
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: kAmberColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة السيارة
              Stack(
                children: [
                  Container(
                    height: 180.h,
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        topRight: Radius.circular(15.r),
                      ),
                    ),
                    child: appShimmerImage(car['coverImage'] ?? ''),
                  ),

                  // بادج حالة الطلب
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: kGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: kAmberColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'مكتمل',
                        style: TextStyle(
                          color: kWhite,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  // معلومات سريعة
                  Positioned(
                    bottom: 12.h,
                    left: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: kAmberColor,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            DateFormat('dd/MM/yyyy').format(createdAt),
                            style: TextStyle(
                              color: kWhite,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // تفاصيل الطلب
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العلامة التجارية والسعر
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          car['brand']?.toString() ?? '',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: kWhite,
                          ),
                        ),
                        Text(
                          '\$${order['totalPrice']?.toString() ?? '0'}',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: kAmberColor,
                            shadows: [
                              Shadow(
                                color: kAmberColor.withOpacity(0.5),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    // معلومات السيارة
                    Row(
                      children: [
                        _buildCarDetail(
                          Icons.directions_car,
                          car['carType']?.toString() ?? '',
                        ),
                        SizedBox(width: 16.w),
                        _buildCarDetail(
                          Icons.speed,
                          '${car['speed']?.toString() ?? '0'} km/h',
                        ),
                        SizedBox(width: 16.w),
                        _buildCarDetail(
                          Icons.event_seat,
                          '${car['seats']?.toString() ?? '0'} مقاعد',
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    // معلومات الطلب
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: kAmberColor.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          // معلومات الطلب
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildOrderDetail('رقم الطلب', '#${order['id']}'),
                              _buildOrderDetail('الكمية', '${order['quantity']}'),
                            ],
                          ),

                          SizedBox(height: 8.h),

                          Divider(
                            height: 1,
                            color: kAmberColor.withOpacity(0.3),
                          ),

                          SizedBox(height: 8.h),

                          // معلومات البائع
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16.r,
                                backgroundColor: kAmberColor.withOpacity(0.2),
                                child: Icon(
                                  Icons.person,
                                  size: 18.sp,
                                  color: kAmberColor,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'البائع',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  Text(
                                    seller['username']?.toString() ?? '',
                                    style: TextStyle(
                                      color: kWhite,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              if (seller['whatsapp'] != null)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.green.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.wash_sharp,
                                        color: Colors.green,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'واتساب',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // تفاصيل إضافية
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        if (car['country'] != null)
                          _buildFeatureChip('📍 ${car['country']}'),
                        if (car['transmission'] != null)
                          _buildFeatureChip('🚗 ${car['transmission']}'),
                        if (car['fuelType'] != null)
                          _buildFeatureChip('⛽ ${car['fuelType']}'),
                        if (car['climate'] == true)
                          _buildFeatureChip('❄️ مكيف'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: kAmberColor,
          size: 16.sp,
        ),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            color: kWhite,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: kAmberColor.withOpacity(0.3),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[300],
          fontSize: 12.sp,
        ),
      ),
    );
  }
}