import 'package:carmarketapp/Screens/Widgets/my_text_field.dart';
import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/core/utils/snckbar.dart';
import 'package:carmarketapp/providers/auth/auth_provider.dart';
import 'package:carmarketapp/screens/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Widgets/custom_button.dart';
import '../Widgets/custom_phone_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with ShowSnackBar {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController whatsappController;
  late TextEditingController passwordController;



  bool isPasswordHidden = true;
  String selectedRole = 'seller';
  String fullWhatsappNumber = '';

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    whatsappController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    whatsappController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// ---------- Label Widget ----------
  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.85),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// App Bar
                const CustomAppBar(text: 'Register'),

                SizedBox(height: 12.h),

                /// Image
                Center(
                  child: Image.asset(
                    'assets/images/car4sale.png',
                    height: 180.h,
                  ),
                ),

                SizedBox(height: 24.h),

                /// ---------- Name ----------
                _label('Full Name'),
                MyTextField(
                  hint: 'Enter your name',
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.person_outline,
                  isOutlinedBorder: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    }
                    if (value.length > 30) {
                      return "Name cannot be longer than 30 characters";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 18.h),

                /// ---------- Email ----------
                _label('Email Address'),
                MyTextField(
                  hint: 'example@email.com',
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  isOutlinedBorder: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}")
                        .hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 18.h),

                /// ---------- WhatsApp ----------
                _label('WhatsApp Number'),
                PhoneInputSeparated(
                  phoneController: whatsappController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "WhatsApp number is required";
                    }
                    return null;
                  },
                  onChangedFullPhone: (value) {
                    // You can handle the full phone number here if needed
                    fullWhatsappNumber = value;
                  },
                ),

                SizedBox(height: 18.h),

                /// ---------- Password ----------
                _label('Password'),
                MyTextField(
                  hint: '••••••••',
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.visiblePassword,
                  obscured: isPasswordHidden,
                  prefixIcon: Icons.lock_outline,
                  isOutlinedBorder: true,
                  isPassword: true,
                  suffixIcon: isPasswordHidden
                      ? Icons.visibility_off
                      : Icons.visibility,
                  onTapSuffix: () {
                    setState(() {
                      isPasswordHidden = !isPasswordHidden;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    if (!RegExp(
                        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z\d]).+$')
                        .hasMatch(value)) {
                      return "Password must contain letters, numbers & symbols";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 22.h),

                /// ---------- Role ----------
                _label('Register As'),
                Row(
                  children: [
                    Radio<String>(
                      value: 'seller',
                      groupValue: selectedRole,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) {
                        setState(() => selectedRole = value!);
                      },
                    ),
                    Text(
                      'Seller',
                      style: TextStyle(
                        color: selectedRole == 'seller'
                            ? Theme.of(context).primaryColor
                            : Colors.white70,
                        fontSize: 15.sp,
                        fontWeight: selectedRole == 'seller'
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Radio<String>(
                      value: 'customer',
                      groupValue: selectedRole,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) {
                        setState(() => selectedRole = value!);
                      },
                    ),
                    Text(
                      'Customer',
                      style: TextStyle(
                        color: selectedRole == 'customer'
                            ? Theme.of(context).primaryColor
                            : Colors.white70,
                        fontSize: 15.sp,
                        fontWeight: selectedRole == 'customer'
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 28.h),

                /// ---------- Login ----------
                Center(
                  child: InkWell(
                    onTap: () => NavigationRoutes()
                        .jump(context, Routes.loginScreen),
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                        children: [
                          TextSpan(
                            text: "Log in",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                /// ---------- Button ----------
                CustomButton(
                  title: "Sign Up",
                  loading: provider.register.status == ApiStatus.LOADING,
                  onTap: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final response = await provider.registerUser(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      username: nameController.text.trim(),
                      whatsapp: fullWhatsappNumber.trim(),
                      isSeller: selectedRole == 'seller',
                    );

                    final result = provider.register;

                    if (!context.mounted) return;

                    if (result.status == ApiStatus.ERROR) {
                      showSnackBar(
                        context,
                        message: result.message ?? "Something went wrong",
                        error: true,
                      );
                    } else {
                      showSnackBar(
                        context,
                        message: "Account created successfully",
                      );
                    }
                  },
                ),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
