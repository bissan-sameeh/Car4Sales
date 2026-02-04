import 'package:carmarketapp/DB/db_settings.dart';
import 'package:carmarketapp/providers/Dealer/brands_provider/brands_names_provider.dart';
import 'package:carmarketapp/providers/Dealer/cars_provider/cars_provider.dart';
import 'package:carmarketapp/providers/Dealer/revenue_prvider/revenue_provider.dart';
import 'package:carmarketapp/providers/Dealer/seller_provider/seller_provider.dart';
import 'package:carmarketapp/providers/Dealer/statistics_provider/statistics_provider.dart';
import 'package:carmarketapp/providers/auth/auth_provider.dart';
import 'package:carmarketapp/providers/customer/cart/cart_provider.dart';
import 'package:carmarketapp/providers/customer/cart/quantity_provider.dart';
import 'package:carmarketapp/providers/customer/customer_cars_provider/customer_cars_provider.dart';
import 'package:carmarketapp/providers/customer/favorite/favorite_provider.dart';
import 'package:carmarketapp/providers/customer/orders/orders_provider.dart';
import 'package:carmarketapp/providers/customer/reviews/review_provider.dart';
import 'package:carmarketapp/providers/profile/profile_provider.dart';
import 'package:carmarketapp/screens/Customer/customer_order/place_order_screen.dart';
import 'package:carmarketapp/screens/auth/forget_password_screen.dart';
import 'package:carmarketapp/screens/customer/customer_order/complete_order_screen.dart';
import 'package:carmarketapp/screens/customer/customer_order/payment_failed_screen.dart';
import 'package:carmarketapp/screens/customer/customer_order/pending_order_screen.dart';
import 'package:carmarketapp/screens/dealer/show_car_detailes.dart';
import 'package:carmarketapp/screens/dealer/show_car_detailes.dart';
import 'package:carmarketapp/screens/splash_screen.dart';
import 'package:carmarketapp/stripe_payment/stripe_key.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Cache/cache_controller.dart';
import 'core/helpers/routers/route_helper.dart';
import 'core/helpers/routers/routes.dart';
import 'core/utils/constants.dart';
import 'core/utils/restart_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //if u want to run anything before run app
  // بتفصل بين النيتف والفلتر => بكون في نيتف شاشة بتشتغل بالاول
  await CacheController().initCache();
  Stripe.publishableKey=ApiKeys.publishableKey;
  await Stripe.instance.applySettings();

  ///Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  ///Notifications
  // await FbNotifications.initNotifications();

  ///Topic (firebase messaging)
  // await FirebaseMessaging.instance.subscribeToTopic(
  //     "Delivery"); //هيسجل الدفايس تبعي في توبيك اسمه اتش تي سي
  ///FCM
  // var fcm = await FirebaseMessaging.instance.getToken();
  // print(fcm);

  ///DataBase
  await DbSettings().initDb();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RestartApp(
      child: ScreenUtilInit(
        designSize: const Size(357, 812),
        builder: (context, child) {
          return MultiProvider(providers: [
            ChangeNotifierProvider<RevenueProvider>(
                create: (context) => RevenueProvider()),
            ChangeNotifierProvider<CarsProvider>(
                create: (context) => CarsProvider()),
            ChangeNotifierProvider<StatisticsProvider>(
                create: (context) => StatisticsProvider()),
            ChangeNotifierProvider<BrandNamesProvider>(
                create: (context) => BrandNamesProvider()),
            ChangeNotifierProvider<AuthProvider>(
                create: (context) => AuthProvider()),
            ChangeNotifierProvider<CustomerCarsProvider>(
                create: (context) => CustomerCarsProvider()),
            ChangeNotifierProvider<ProfileProvider>(
                create: (context) => ProfileProvider()),
            ChangeNotifierProvider<FavoriteProvider>(
                create: (context) => FavoriteProvider()),
            ChangeNotifierProvider(
              create: (_) => QuantityProvider(),
            ),

            ChangeNotifierProxyProvider<QuantityProvider, CartProvider>(
              create: (context) =>
                  CartProvider(context.read<QuantityProvider>()),
              update: (context, quantityProvider, previous) =>
              previous ?? CartProvider(quantityProvider),
            ),

            ChangeNotifierProvider<SellerProvider>(
                create: (context) => SellerProvider()..fetchSellerData()
            ),
            ChangeNotifierProvider<OrdersProvider>(
                create: (context) => OrdersProvider()

            ),   ChangeNotifierProvider<ReviewsProvider>(
                create: (context) => ReviewsProvider()

            ),
          ], child: const MyMaterialApp());
        },
      ),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: kAmberColor,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          scaffoldBackgroundColor: kBlackColor,
          hintColor: kLightBlackColor,
          textTheme: TextTheme(
            bodyMedium: TextStyle(
                fontSize: 14.sp, color: kWhite, fontWeight: FontWeight.bold),
          ),
          fontFamily: 'Pippins'),
      routes: {
        Routes.showCarDetails: (context) => ShowCarDetails(),
        Routes.customerPlaceOrder: (context) => CustomerPlaceOrder(),
        Routes.resendPassword: (context) =>  ResendPasswordScreen(),
        Routes.completeOrderScreen: (context) =>  CompleteOrderScreen(),
        Routes.paymentFailedScreen: (context) =>  PaymentFailedScreen(),
        Routes.pendingOrderScreen: (context) =>  PendingOrderScreen(),
      },
      onGenerateRoute: generateRoute,
      home: SplashScreen(),
    );
  }
}
