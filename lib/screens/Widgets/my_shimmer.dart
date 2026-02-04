// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shimmer/shimmer.dart';
//
// class MyShimmer extends StatefulWidget {
//   final double height;
//   final double width;
//   final double radius;
//   final double startMargin;
//   final double endMargin;
//   final double topMargin;
//   final double bottomMargin;
//
//   const MyShimmer(
//       {super.key,
//       required this.height,
//       this.width = double.infinity,
//       this.radius = 5,
//       this.startMargin = 0,
//       this.endMargin = 0,
//       this.topMargin = 0,
//       this.bottomMargin = 0});
//
//   @override
//   State<MyShimmer> createState() => _MyShimmerState();
// }
//
// class _MyShimmerState extends State<MyShimmer> {
//   @override
//   Widget build(BuildContext context) {
//     return Shimmer(
//         gradient: LinearGradient(colors: [
//           Colors.grey.shade800,
//           Colors.grey.shade500,
//           Colors.grey.shade800,
//           Colors.grey.shade700
//         ]),
//         child: Container(
//           height: widget.height.h,
//           width: widget.width.w,
//           margin: EdgeInsetsDirectional.only(
//             top: widget.topMargin.h,
//             end: widget.endMargin.w,
//             start: widget.startMargin.w,
//             bottom: widget.bottomMargin.h,
//           ),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(widget.radius.r)),
//         ));
//   }
// }
