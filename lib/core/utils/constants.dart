import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';

// ============= COLORS CONSTS ==============
const Color kLightBlueColor = Color(0xff2DAFE2);
// const Color kBlackColor = Color(0xFF222831);
const Color kBlackColor = Color(0xFF222831);
const Color kTextSecondary = Color(0xFFB0B3B8);
const Color kSurfaceColor = Color(0xFF2D333B);
const Color kTextPrimary = Color(0xFFEEEEEE);
const Color kBorderColor = Color(0xFF393E46);
const Color kWhite = kTextPrimary;
const Color kGrayColor =    Color(0xFF8C98A8);
const Color kPrimaryBlueColor = Color(0xFFFFFFFF);
const Color kOrangeColor = Color(0xFFF69808);
// const Color kOrangeColor = Color(0xFFF69808);
 const Color kLightGray = Color(0xFFB0B0B0);

const Color kGray = Color(0xFFf7f7f7);
const Color kPinkColor = Color(0xffE65D8D);
 // const Color kAmberColor = Color(0xffe5a11f);
 const Color kAmberColor = Color(0xFFCC8F1A);
// const Color kGreenColor = Color(0xFF1B6E6A);
// const Color kWhite = Color(0xfffffff);
// const Color kGreenKKColor = Color(0xFF1B6E6A);
// const Color kDarkBlueColor = Color(0xff223263);
//const Color kLightBlackColor = Color(0xFF31363F);
const Color kLightBlackColor = Color(0xFF31363F);
// const Color kMediumBlackColor = Color(0xff1A182E);


LinearGradient kGradient =   LinearGradient(
colors: [
Colors.orange.shade800,
Colors.amber.shade600,],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,);

// ============= TEXT STYLES CONSTS ==============

TextStyle buildAppBarTextStyle(
        {Color color = kLightBlueColor,
        double fontSizeController = 18,
        double letterSpacing = 1.5}) =>
    TextStyle(
        color: color,
        letterSpacing: letterSpacing,
        fontSize: fontSizeController);



TextStyle salesStyle = const TextStyle(
  color: kWhite,
  fontSize: 14,
);

// ============= TextFieldBorder ==============


OutlineInputBorder buildOutLinedInputBorder({required Color color}) {
  return OutlineInputBorder(
    borderSide: BorderSide( color: color ),
  );
}


OutlineInputBorder buildOutlineInputBorderTextField(
    {bool? isHasColorBorder = false,bool isFocused=false}) {
  return OutlineInputBorder(

      borderRadius: BorderRadius.circular(8.r),  borderSide: isHasColorBorder !=true ? BorderSide.none :BorderSide(color:isFocused ==true? Color(0xFFCC8F1A):kGrayColor.withOpacity(0.2),
  ),);
}


BoxDecoration buildBoxDecoration({bool isBorderSide=true,double borderRadius=15,bool isShadow=false}) {
  return  BoxDecoration(
      color: kLightBlackColor,
      borderRadius: BorderRadius.circular(borderRadius.r),
boxShadow:isShadow==true? [
   BoxShadow(color:  Colors.black.withOpacity(0.4),blurRadius: 8,offset: const Offset(0,1)
   
   )
]:null,
      border:isBorderSide==true?  Border.all(  color: kAmberColor):null);
}

///Brands screen style
TextStyle kBrandTextStyle=TextStyle(
  fontSize: 12.sp,
  color: kWhite
);
// TextStyle kTextFieldTextStyle = GoogleFonts.poppins(
//     fontSize: 12.sp,
//     letterSpacing: 0.4000000059604645,
//     color: kMediumGreyColor);

// ============= ApiEndpoints ============== //

/* public */
const String baseUrl = "https://backend-grad-hlvr.onrender.com/api";

/* private */
//ADD NEw car//
const String addNewCarUrl='$baseUrl/cars';
const String allOfferCars='$baseUrl/users/cars';
const String allSellerCars='$baseUrl/users/sold-cars';
const String statisticsUrl='$addNewCarUrl/statistics';
const String topStatisticsUrl='$statisticsUrl/top';
const String revenueUrl='$baseUrl/orders/revenue';
const String topStatistics='$addNewCarUrl/statistics/top';
const String showCarDetailsUrl='$addNewCarUrl/';
const String deleteCarUrl='$addNewCarUrl/';
const String updateCarUrl='$addNewCarUrl/';
const String sellerUrl='$addNewCarUrl/seller';
const String auth='$baseUrl/auth/';
const String loginUrl='$auth/login';
const String registerUrl='$auth/register';
const String forgetPasswordUrl='$auth/request-otp';
const String verifyOtpUrl='$auth/verify-otp';
const String resetPasswordUrl='$auth/reset-password';
const String getCustomersCarsUrl='$baseUrl/cars';
const String updateProfileUrl='$baseUrl/users';
/* Favorite */
const String addFavoriteUrl='$baseUrl/favorites';
const String deleteFavoriteUrl='$baseUrl/favorites/';
/* Cart */
const String cartUrl='$baseUrl/carts';
const String deleteCartUrl='$baseUrl/carts/';
// const String cartUrl='$baseUrl/cart';
/*Payment */
const String paymentUrl='$baseUrl/orders/payment-intent';

/*Orders*/
const String ordersUrl = '$baseUrl/orders/buyer';
const String confirmOrderUrl = '$baseUrl/orders/confirm';


/*comments*/
const String addReviewUrl = '$baseUrl/reviews';



// utils //
const  List<String> shortedMonths = [
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
];



const  List<String> monthsList = [
  "January", "February", "March", "April", "May", "January",
  "July", "August", "September", "October", "November", "December"
];
