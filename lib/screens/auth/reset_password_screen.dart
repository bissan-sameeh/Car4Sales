import 'package:carmarketapp/Screens/Widgets/my_text_field.dart';
import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/core/utils/snckbar.dart';
import 'package:carmarketapp/providers/auth/auth_provider.dart';
import 'package:carmarketapp/screens/Widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/helpers/api_helpers/api_response.dart';
import '../Widgets/custom_app_bar.dart';
import '../Widgets/custom_auth_widget.dart';


class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> with ShowSnackBar {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController emailController;

  bool isPassword = false;
  bool isConfirmation = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    confirmPasswordController = TextEditingController();
    passwordController = TextEditingController();
    emailController = TextEditingController();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    confirmPasswordController.dispose();
    passwordController.dispose();
    emailController.dispose();

  }
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.h),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomAuthWidget(
                      path: "assets/images/lock.png",
                      text: "Please Enter password & confirm password",
                      title: 'Reset password'),
                  SizedBox(
                    height: 50.h,
                  ),
          
                  MyTextField(
                    hint: 'Password',
                    controller: passwordController,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.visiblePassword,
                    obscured: isPassword,
                    onTap: () {
                      isPassword = !isPassword;
                      setState(() {});
                    },
                    prefixIcon: Icons.lock_clock_rounded,
                    isOutlinedBorder: true,
                    isPassword: true,
                    suffixIcon: Icons.remove_red_eye,
                    validator: (value) {
                      // checker.passwordValidator(passwordController.text);
                      if (value!.isEmpty) {
                        return "Password is required !";
                      } else if (passwordController.text.length < 6) {
                        return "Password should be at least 6 character";
                      } else if (!RegExp(
                          "(?=.*?[0-9])(?=.*?[A-Za-z])(?=.*[^0-9A-Za-z]).+")
                          .hasMatch(passwordController.text)) {
                        return "Password must contain at least one character (a-z)/(A-Z) or digit!";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  MyTextField(
                    hint: 'Confirmation',
                    controller: confirmPasswordController,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.visiblePassword,
                    obscured: isConfirmation,
                    onTap: () {
                      isConfirmation = !isConfirmation;
                      setState(() {});
                    },
                    prefixIcon: Icons.lock_clock_rounded,
                    isOutlinedBorder: true,
                    isPassword: true,
                    suffixIcon: Icons.remove_red_eye,
                    validator: (value) {
                      // checker.passwordValidator(passwordController.text);
                      if (value!.isEmpty) {
                        return "Confirmation is required !";
                      } else if (passwordController.text.length < 6) {
                        return "Confirmation should be at least 6 character";
                      } else if (!RegExp(
                          "(?=.*?[0-9])(?=.*?[A-Za-z])(?=.*[^0-9A-Za-z]).+")
                          .hasMatch(passwordController.text)) {
                        return "Password must contain at least one character (a-z)/(A-Z) or digit!";
                      }else if(confirmPasswordController.text !=passwordController.text){
                        return "Password must match Confirmation!";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  CustomButton(title: 'Reset Password',
                    loading: Provider.of<AuthProvider>(context,).resetPasswordResponse.status == ApiStatus.LOADING,

                    onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      final provider =
                      Provider.of<AuthProvider>(context, listen: false);
          
                      await provider.resetPassword(
                          password: passwordController.text);
                      var response = provider.resetPasswordResponse;
                      if (response.status == ApiStatus.ERROR) {
                        if (context.mounted) {
                          showSnackBar(context,
                              message: response.message.toString(),
                              error: true);
                        }
                      } else if (response.status == ApiStatus.COMPLETED) {
                        if (context.mounted) {
                          showSnackBar(context,
                              message: response.data.toString());
                          NavigationRoutes()
                              .jump(context, Routes.loginScreen);
                        }
                      }
                    }
          
                  },)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
