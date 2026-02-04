import 'package:carmarketapp/Cache/auth_storage.dart';
import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/core/utils/data_checker.dart';
import 'package:carmarketapp/core/utils/snckbar.dart';
import 'package:carmarketapp/providers/customer/cart/cart_provider.dart';
import 'package:carmarketapp/providers/customer/customer_cars_provider/customer_cars_provider.dart';
import 'package:carmarketapp/providers/customer/favorite/favorite_provider.dart';
import 'package:carmarketapp/screens/Widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/auth/auth_provider.dart';
import '../Widgets/my_text_field.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ShowSnackBar {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isHide = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: SingleChildScrollView(

            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Title
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Welcome to Car",
                        style: TextStyle(
                          color: kTextPrimary,
                          fontWeight: FontWeight.w600, // أخف من bold
                          fontSize: 22.sp,
                        ),
                        children: [
                          TextSpan(
                            text: "4",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: "Sales"),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  Center(
                    child: Image.asset(
                      "assets/images/car4sale.png",
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: 32.h),

                  /// ================= EMAIL =================
                  Text(
                    "Email Address",
                    style:  TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  MyTextField(
                    hint: 'example@email.com',
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    isOutlinedBorder: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email is required";
                      } else if (!RegExp(
                          r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}")
                          .hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 18.h),

                  /// ================= PASSWORD =================
                  Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  MyTextField(
                    hint: '••••••••',
                    suffixIcon: "eye",
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    obscured: isHide,
                    isOutlinedBorder: true,
                    onTapSuffix: () {
                      setState(() => isHide = !isHide);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password is required";
                      } else if (value.length < 6) {
                        return "At least 6 characters";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20.h),

                  /// Forget password
                  InkWell(
                    onTap: () => NavigationRoutes()
                        .jump(context, Routes.resendPassword),
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  SizedBox(height: 28.h),

                  /// Login Button
                  CustomButton(
                    title: "Login",
                    loading:    Provider.of<AuthProvider>(context,).login.status == ApiStatus.LOADING,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final provider =
                        Provider.of<AuthProvider>(context, listen: false);

                        await provider.loginUser(
                          email: emailController.text,
                          password: passwordController.text,
                        );

                        final result = provider.login;

                        if (result.status == ApiStatus.ERROR) {
                          showSnackBar(
                            context,
                            message: result.message ?? "Error",
                            error: true,
                          );
                        } else {
                          showSnackBar(
                            context,
                            message: "Logged in successfully",
                          );

                          final isSeller = result.data?.user.isSeller == true;

                          if (isSeller) {
                            NavigationRoutes().jump(
                              context,
                              Routes.dealerMainScreen,
                              replace: true,
                            );
                          } else {
                            await context
                                .read<CustomerCarsProvider>()
                                .fetchSellerCars();

                            final favProvider = context.read<FavoriteProvider>();
                            final cartProvider = context.read<CartProvider>();

                            await favProvider.fetchAllFavorites();
                            await cartProvider.fetchAllCart();

                            favProvider.syncLocalWithServer();
                            cartProvider.syncLocalWithServer();

                            NavigationRoutes().jump(
                              context,
                              Routes.customerMainScreen,
                              replace: true,
                            );
                          }
                        }
                      }
                    },
                  ),

                  SizedBox(height: 20.h),

                  /// Register
                  Row(
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: kTextSecondary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      InkWell(
                        onTap: () {
                          NavigationRoutes()
                              .jump(context, Routes.registerScreen);
                        },
                        child: Text(
                          "Create one",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
