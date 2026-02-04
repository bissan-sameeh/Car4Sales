import 'package:carmarketapp/core/helpers/routers/routes.dart';
import 'package:carmarketapp/screens/Customer/customer_order/order_screen.dart';
import 'package:carmarketapp/screens/Customer/home/customer_home_view.dart';
import 'package:carmarketapp/screens/customer/customer_order/complete_order_screen.dart';
import 'package:carmarketapp/screens/customer/customer_order/pending_order_screen.dart';
import 'package:carmarketapp/screens/dealer/add_brand_screen.dart';
import 'package:carmarketapp/screens/dealer/my_dashboard/revenue_screen.dart';
import 'package:carmarketapp/screens/dealer/my_dashboard/sales_screen.dart';
import 'package:carmarketapp/screens/dealer/my_dashboard/statistics_screen.dart';
import 'package:carmarketapp/screens/dealer/show_car_detailes.dart';
import 'package:carmarketapp/screens/auth/reset_password_screen.dart';
import 'package:carmarketapp/screens/auth/register_screen.dart';
import 'package:carmarketapp/screens/auth/otp_verify_screen.dart';
import 'package:carmarketapp/screens/customer_main_screen.dart';
import 'package:carmarketapp/screens/main_screen.dart';
import 'package:carmarketapp/screens/profile/update_profile.dart';
import 'package:flutter/material.dart';

import '../../../Screens/auth/login_screen.dart';
import '../../../screens/Customer/customer_order/place_order_screen.dart';
import '../../../screens/auth/forget_password_screen.dart';
import '../../../screens/customer/customer_order/payment_failed_screen.dart';
import '../../../screens/dealer/bnb/add_car_view.dart';
import '../../../screens/dealer/bnb/home_view.dart';
import '../../../screens/dealer/my_dashboard/offer_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.mainView:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const MainScreen(
          duration: Duration(seconds: 3),
        ),
      );
    //
    case Routes.homeView:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const HomeView(),
      );
      case Routes.ordersScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const OrderScreen(),
      );
      case Routes.customerPlaceOrder:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const CustomerPlaceOrder(),
      );
      case Routes.addCarScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const AddUpdateCarView(),
      );   case Routes.createPasswordScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const CreatePasswordScreen(),
      ); case Routes.updateScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const UpdateProfile(),
      ); case Routes.customerHomeView:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const CustomerHomeView(),
      );
    case Routes.loginScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const LoginScreen(),
      );  case Routes.verifyScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const VerifyScreen(),
      );
    case Routes.registerScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const RegisterScreen(),
      );
      case Routes.customerMainScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const CustomerMainScreen(),
      );    case Routes.dealerMainScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const MainScreen(),
      );

      case Routes.resendPassword:
      return _getPageRoute(
        routeName: settings.name!,
        screen:  ResendPasswordScreen(),
      ); case Routes.completeOrderScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen:  CompleteOrderScreen(),
      );case Routes.paymentFailedScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen:  PaymentFailedScreen(),
      );
    case Routes.pendingOrderScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen:  PendingOrderScreen(),
      );
    case Routes.offerScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const OfferScreen(),
      );
    case Routes.salesScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const SalesScreen(),
      );
    case Routes.revenueScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const RevenueScreen(),
      );
    case Routes.statisticsScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const StatisticsScreen(),
      );
      case Routes.showCarDetails:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const ShowCarDetails(),
      ); case Routes.addBrandScreen:
      return _getPageRoute(
        routeName: settings.name!,
        screen: const AddBrandScreen(),
      );

    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No Route defined for ${settings.name}'),
          ),
        ),
      );
  }
}

PageRoute _getPageRoute({
  required String routeName,
  required Widget screen,
}) {
  return PageTransition(
    child: screen,
    type: PageTransitionType.rightToLeft,
  );
}

enum PageTransitionType {
  fade,
  rightToLeft,
  leftToRight,
  upToDown,
  downToUp,
  scale,
  rotate,
  size,
  rightToLeftWithFade,
  leftToRightWithFade,
}

class PageTransition extends PageRouteBuilder {
  final Widget child;
  final PageTransitionType type;
  final Curve curve;
  final Alignment alignment;
  final Duration duration;

  PageTransition({
    required this.child,
    this.type = PageTransitionType.downToUp,
    this.curve = Curves.linear,
    this.alignment = Alignment.center,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return child;
          },
          transitionDuration: duration,
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            switch (type) {
              case PageTransitionType.fade:
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              case PageTransitionType.rightToLeft:
                return SlideTransition(
                  transformHitTests: false,
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(-1.0, 0.0),
                    ).animate(secondaryAnimation),
                    child: child,
                  ),
                );

              case PageTransitionType.downToUp:
                return SlideTransition(
                  transformHitTests: false,
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(0.0, -1.0),
                    ).animate(secondaryAnimation),
                    child: child,
                  ),
                );

              case PageTransitionType.rightToLeftWithFade:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(-1.0, 0.0),
                      ).animate(secondaryAnimation),
                      child: child,
                    ),
                  ),
                );

              default:
                return FadeTransition(opacity: animation, child: child);
            }
          },
        );
}
