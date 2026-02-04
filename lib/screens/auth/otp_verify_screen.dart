import 'dart:async';
import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/core/utils/snckbar.dart';
import 'package:carmarketapp/screens/Widgets/custom_auth_widget.dart';
import 'package:carmarketapp/screens/Widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/auth/auth_provider.dart';
import '../Widgets/my_otp_text_field.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> with ShowSnackBar {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  Timer? _timer;
  int secondsRemaining = 60;
  String? email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    email ??= ModalRoute.of(context)?.settings.arguments as String?;
  }

  @override
  void initState() {
    super.initState();

    controllers =
        List.generate(6, (_) => TextEditingController());
    focusNodes =
        List.generate(6, (_) => FocusNode());

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() => secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime =
        '00:${secondsRemaining.toString().padLeft(2, '0')}';

    final isTimerFinished = secondsRemaining == 0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              children: [
                /// Header
                const CustomAuthWidget(
                  path: 'assets/images/email.png',
                  title: "Verify OTP",
                  text:
                  "Enter the 6-digit code we sent to your email",
                ),

                SizedBox(height: 12.h),

                /// OTP Fields
                Row(
                  children: List.generate(6, (index) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: MyOtpTextField(
                          textEditingController: controllers[index],
                          focusNode: focusNodes[index],
                          autoFocus: index == 0,
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              focusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              focusNodes[index - 1].requestFocus();
                            }
                          },
                        ),
                      ),
                    );
                  }),
                ),

                SizedBox(height: 28.h),
                if (!isTimerFinished)

                /// Timer
                Text(
                  "Resend code in $formattedTime",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),

                SizedBox(height: 6.h),

                /// Resend
                if (isTimerFinished)
                  GestureDetector(
                    onTap: () async {
                      final provider =
                      context.read<AuthProvider>();

                      await provider.forgetPassword(
                          email: email ?? '');

                      setState(() {
                        secondsRemaining = 60;
                      });
                      _startTimer();

                      final response =
                          provider.forgetPassResponse;

                      if (response.status ==
                          ApiStatus.ERROR) {
                        if(context.mounted){

                        showSnackBar(
                          context,
                          message:
                          response.message.toString(),
                          error: true,
                        );
                        }
                      } else {
                        if(context.mounted){

                        showSnackBar(
                          context,
                          message:
                          response.data.toString(),
                        );
                        }
                      }
                    },
                    child: Text(
                      "Didn’t receive the code? Resend",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade400,
                        decoration:
                        TextDecoration.underline,
                      ),
                    ),
                  ),

                SizedBox(height: 32.h),

                /// Submit Button
                CustomButton(
                  loading: Provider.of<AuthProvider>(context,).verifyOtpResponse.status == ApiStatus.LOADING,
                  title: "Verify",
                  onTap: () async {
                    final provider = context.read<AuthProvider>();

                    final otp = controllers.map((e) => e.text).join();

                    if (otp.length < 6) {
                      showSnackBar(
                        context,
                        message: "Please enter the complete 6-digit code",
                        error: true,
                      );
                      return;
                    }

                    final response = await provider.verifyOtp(otp: otp);

                    final result = provider.verifyOtpResponse;

                    if (result.status == ApiStatus.ERROR) {
                      if(context.mounted){

                      showSnackBar(
                        context,
                        message: result.message.toString(),
                        error: true,
                      );
                      }
                    } else {
                      if(context.mounted) {
                        showSnackBar(
                          context,
                          message: result.data.toString(),
                        );
                        NavigationRoutes().jump(
                          context,
                          Routes.createPasswordScreen,
                        );
                      }
                    }
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
