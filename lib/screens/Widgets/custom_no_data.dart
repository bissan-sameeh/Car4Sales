import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../core/utils/constants.dart';

class CustomNoData extends StatefulWidget {
  final String? text;
  final String? subtitle;
  final String? icon;
  final Color? textColor;
  final Color? subtitleColor;
  final Color? iconColor;
  final double? iconSize;
  final double? spacing;
  final bool showActionButton;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Widget? customIcon;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const CustomNoData({
    super.key,
    this.text,
    this.subtitle,
    this.icon,
    this.textColor,
    this.subtitleColor,
    this.iconColor,
    this.iconSize = 200,
    this.spacing = 20,
    this.showActionButton = false,
    this.actionText,
    this.onActionPressed,
    this.customIcon,
    this.padding,
    this.backgroundColor,
  });

  @override
  State<CustomNoData> createState() => _CustomNoDataState();
}

class _CustomNoDataState extends State<CustomNoData>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIcon() {
    if (widget.customIcon != null) {
      return widget.customIcon!;
    }

    if (widget.icon != null) {
      // الحصول على اسم الملف بدون الامتداد
      final iconName = widget.icon!;

      // التحقق إذا كان الملف ينتهي بـ .json بالفعل
      if (iconName.endsWith('.json')) {
        return Lottie.asset(
          "assets/images/$iconName",
          height: widget.iconSize!.h,
          width: widget.iconSize!.w +500,
          fit: BoxFit.contain,
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward();
          },
        );
      } else {
        // إذا لم يكن .json، فمن المحتمل أنه ملف صورة عادي أو نستخدم .json تلقائياً
        return Lottie.asset(
          "assets/images/$iconName.json",
          height: widget.iconSize!.h,
          width: widget.iconSize!.w,
          fit: BoxFit.contain,
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward();
          },
        );
      }
    }

    // أيقونة افتراضية
    return Icon(
      Icons.shopping_cart_outlined,
      size: widget.iconSize!.h,
      color: widget.iconColor ?? kWhite,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
      color: kLightBlackColor,
        borderRadius: BorderRadius.circular(16)
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: widget.padding ??
              EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 40.h,
              ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Curves.elasticOut,
                  ),
                ),
                child: _buildIcon(),
              ),

              SizedBox(height: widget.spacing!.h),

              // النص الرئيسي
              Text(
                widget.text ?? 'عربة التسوق فارغة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.textColor ?? kWhite,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),

              // النص الفرعي
              if (widget.subtitle != null) ...[
                SizedBox(height: 8.h),
                Text(
                  widget.subtitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.subtitleColor ?? kLightGray,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],

              // زر الإجراء
              if (widget.showActionButton) ...[
                SizedBox(height: 24.h),
                CupertinoButton(
                  onPressed: widget.onActionPressed ?? () {},
                  borderRadius: BorderRadius.circular(12.r),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  color: kAmberColor,
                  child: Text(
                    widget.actionText ?? 'استعرض السيارات',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: kWhite,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}