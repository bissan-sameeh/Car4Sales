import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/core/utils/snckbar.dart';
import 'package:carmarketapp/screens/Widgets/custom_button.dart';
import 'package:carmarketapp/screens/Widgets/rate_section/rate_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer/reviews/review_provider.dart';
import '../../Widgets/my_text_field.dart';

class CompleteOrderScreen extends StatefulWidget {
  const CompleteOrderScreen({super.key});

  @override
  State<CompleteOrderScreen> createState() => _CompleteOrderScreenState();
}

class _CompleteOrderScreenState extends State<CompleteOrderScreen>
    with ShowSnackBar {
  int rate = 0;
  late final TextEditingController commentController;

  int? carId;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    carId = args?['carId'];
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 400;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 24,
              vertical: 20,
            ),
            child: Container(
              padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
              decoration: BoxDecoration(
                color: kLightBlackColor,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Success Icon
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.2),
                          Theme.of(context)
                              .primaryColor
                              .withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 56,
                    ),
                  ),

                  /// Title
                  Text(
                    "Order Completed! 🎉",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 24 : 28,
                      fontWeight: FontWeight.w700,
                      color: kWhite,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Thank you for your purchase. We hope you enjoy your new car!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// Rating Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Rate Your Experience",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: kWhite,
                          ),
                        ),
                        const SizedBox(height: 16),
                        RateSection(
                          rate: rate,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                          onRateSelected: (value) {
                            setState(() => rate = value);
                          },
                        ),
                        if (rate > 0) ...[
                          const SizedBox(height: 12),
                          Text(
                            _getRatingText(rate),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Comment Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                    child: MyTextField(
                      controller: commentController,
                      prefixIcon: Icons.edit_outlined,
                      hint: "Tell us about your experience... (Optional)",
                      textInputType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      topContentPadding: 16,
                      bottomContentPadding: 16,
                      isOutlinedBorder: true,
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// Submit Button
                  CustomButton(
                    title: "Submit Feedback",
                    loading:
                    context.watch<ReviewsProvider>().isLoading,
                    onTap: () async {
                      final provider =
                      context.read<ReviewsProvider>();

                      if (provider.isLoading) return;

                      if (carId == null || carId! <= 0) {
                        showSnackBar(
                          context,
                          message:
                          "Something went wrong. Please try again.",
                          error: true,
                        );
                        return;
                      }

                      if (rate == 0) {
                        showSnackBar(
                          context,
                          message:
                          "Please select a rating before submitting.",
                          error: true,
                        );
                        return;
                      }



                      final comment =
                      commentController.text.trim();
                      if (comment.isEmpty) {
                        showSnackBar(
                          context,
                          message:
                          "Please write a comment before submitting.",
                          error: true,
                        );
                        return;
                      }

                      await provider.addReview(
                        carId: carId!,
                        rate: rate,
                        comment:  comment,
                      );

                      if (!context.mounted) return;

                      if (provider.addReviewResponse.status ==
                          ApiStatus.COMPLETED) {
                        showSnackBar(
                          context,
                          message:
                          "Thank you! Your review has been submitted ⭐",
                        );
                        await Future.delayed(
                            const Duration(milliseconds: 400));
                        NavigationRoutes().pushUntil(
                          context,
                          Routes.ordersScreen,
                        );
                      } else if (provider.addReviewResponse.status ==
                          ApiStatus.ERROR) {
                        showSnackBar(
                          context,
                          message: provider
                              .addReviewResponse.message
                              .toString(),
                          error: true,
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () {
                      NavigationRoutes().jump(
                        context,
                        Routes.customerMainScreen,
                        replace: true,
                      );
                    },
                    child: const Text(
                      "Skip for now",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getRatingText(int rate) {
    switch (rate) {
      case 1:
        return "Poor";
      case 2:
        return "Fair";
      case 3:
        return "Good";
      case 4:
        return "Very Good";
      case 5:
        return "Excellent!";
      default:
        return "";
    }
  }
}
