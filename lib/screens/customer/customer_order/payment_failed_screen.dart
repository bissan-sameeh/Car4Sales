import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/screens/Widgets/custom_button.dart';
import 'package:flutter/material.dart';

class PaymentFailedScreen extends StatelessWidget {
  const PaymentFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String errorMessage =
        args?['errorMessage']?.toString() ?? 'Payment failed. Please try again.';
    final double amount =
    (args?['amount'] is num) ? (args!['amount'] as num).toDouble() : 0.0;
    final String carName =
        args?['carName']?.toString() ?? 'Unknown vehicle';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.15),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                  size: 64,
                ),
              ),

              const SizedBox(height: 32),

              // Title
              const Text(
                "Payment Failed",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kWhite,
                ),
              ),

              const SizedBox(height: 12),

              // Error Message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Transaction Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Vehicle",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          carName,
                          style: const TextStyle(
                            color: kWhite,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Amount",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "\$${amount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Tips
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.blueAccent,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Tips to try:",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    _TipItem("Check your card details"),
                    _TipItem("Ensure sufficient balance"),
                    _TipItem("Verify 3D Secure authentication"),
                    _TipItem("Contact your bank if needed"),
                  ],
                ),
              ),

              const Spacer(),

              // Buttons
              Column(
                children: [
                  CustomButton(
                    title: "Try Again",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      NavigationRoutes()
                          .pushUntil(context, Routes.customerMainScreen);
                    },
                    child: const Text(
                      "Back to Home",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;

  const _TipItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
