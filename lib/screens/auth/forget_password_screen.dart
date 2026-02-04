import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/core/utils/snckbar.dart';
import 'package:carmarketapp/providers/auth/auth_provider.dart';
import 'package:carmarketapp/screens/Widgets/custom_auth_widget.dart';
import 'package:carmarketapp/screens/Widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Widgets/my_text_field.dart';

class ResendPasswordScreen extends StatefulWidget {
  const ResendPasswordScreen({super.key});

  @override
  State<ResendPasswordScreen> createState() => _ResendPasswordScreenState();
}

class _ResendPasswordScreenState extends State<ResendPasswordScreen>
    with ShowSnackBar {
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(
      text: Provider.of<AuthProvider>(context, listen: false).email ?? '',
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Header
                  CustomAuthWidget(
                    path: "assets/icons/lock_question.png",
                    title: 'Forget password',
                      text: "Don’t worry — we’ll email you instructions to reset your password."

                  ),

                  SizedBox(height: 32.h),

                  /// Email Label
                  Text(
                    "Email",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  /// Email Field
                  MyTextField(
                    hint: 'example@gmail.com',
                    controller: emailController,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    isOutlinedBorder: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email is required";
                      } else if (!RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+",
                      ).hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 32.h),

                  /// Submit Button
                  CustomButton(
                    title: "Submit",
                    loading: Provider.of<AuthProvider>(context,).forgetPassResponse.status == ApiStatus.LOADING,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final provider =
                        Provider.of<AuthProvider>(context, listen: false);

                        await provider.forgetPassword(
                          email: emailController.text,
                        );

                        final response = provider.forgetPassResponse;

                        if (response.status == ApiStatus.ERROR) {
                          if (context.mounted) {
                            showSnackBar(
                              context,
                              message: response.message.toString(),
                              error: true,
                            );
                          }
                        } else if (response.status ==
                            ApiStatus.COMPLETED) {
                          if (context.mounted) {
                            provider.saveEmail(
                              email: emailController.text,
                            );
                            showSnackBar(
                              context,
                              message: response.data.toString(),
                            );
                            NavigationRoutes().jump(
                              context,
                              Routes.verifyScreen,
                              arguments: emailController.text,
                            );
                          }
                        }
                      }
                    },
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
