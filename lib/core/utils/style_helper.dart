import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

mixin StyleHelper {
  BoxShadow appBoxShadow(BuildContext context){
    return BoxShadow(
      color: const Color(0xffE8E8F7).withOpacity(.3),
      offset: const Offset(0, 3),
      blurRadius: 14

    );
  }
  LinearGradient buildLinearGradient() {
    return const LinearGradient(
        begin: AlignmentDirectional.topEnd,
        end: AlignmentDirectional.bottomStart,
        colors: [
          Color(0XFF1A13DA),
          Color(0XFF01FF90),
        ]);
  }
  LinearGradient appLinearGradient(BuildContext context,{
    double opacity=1 ,Axis axis=Axis.vertical,List<Color>? colors
  }){
    return LinearGradient(
        begin: axis ==Axis.vertical? AlignmentDirectional.topCenter:AlignmentDirectional.centerEnd ,
        end: axis==Axis.vertical ? Alignment.bottomCenter:AlignmentDirectional.centerEnd,


        colors: colors ??[
      Theme.of(context).primaryColor.withOpacity(opacity),
          Theme.of(context).colorScheme.secondary.withOpacity(opacity)
    ]);
  }
  //
  // List<Color> get secondaryGradientColors=> [
  //
  // ];

  static String image = "https://pixy.org/src/20/201310.jpg";
  static const progressSpinkit = SpinKitFadingCircle(
    color: Colors.white,
    size: 30.0,
  );
}
