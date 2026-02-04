import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/helpers/api_helpers/api_response.dart';
import '../../../core/helpers/routers/routes.dart';
import '../../../core/utils/constants.dart';
import '../../../providers/customer/cart/cart_provider.dart';
import '../../../providers/customer/cart/quantity_provider.dart';
import '../../../providers/customer/orders/orders_provider.dart';
import '../../Widgets/custom_error_widget.dart';
import '../../Widgets/custom_loading_widget.dart';

class PendingOrderScreen extends StatefulWidget {
  const PendingOrderScreen({super.key});

  @override
  State<PendingOrderScreen> createState() => _PendingOrderScreenState();
}

class _PendingOrderScreenState extends State<PendingOrderScreen> {
  int? carId;
  int? cartId;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_initialized) return;

      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args == null || args['carId'] == null || args['cartId'] == null) {
        return;
      }

      carId = args['carId'];
      cartId = args['cartId'];
      _initialized = true;

      context.read<OrdersProvider>().confirmOrder(
        carId: carId!,
        cartItemId: cartId!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OrdersProvider>(
        builder: (context, provider, _) {
          final status = provider.confirmOrderResponse.status;

          switch (status) {
            case ApiStatus.LOADING:
            case ApiStatus.INITIAL:
              return _loadingUI();

            case ApiStatus.COMPLETED:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;

                context
                    .read<CartProvider>()
                    .removeFromCartLocal(cartId.toString());

                context
                    .read<QuantityProvider>()
                    .resetQuantity(carId!);

                Navigator.pushReplacementNamed(
                  context,
                  Routes.completeOrderScreen,
                  arguments: {
                    "carId": carId,
                  },
                );
              });

              return const SizedBox.shrink();

            case ApiStatus.ERROR:
              return CustomErrorWidget(
                text: provider.confirmOrderResponse.message.toString(),
                onTap: () {
                  context.read<OrdersProvider>().confirmOrder(
                    carId: carId!,
                    cartItemId: cartId!,
                  );
                },
              );

            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _loadingUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CustomLoadingWidget(width: 300),
        SizedBox(height: 24),
        Text(
          "Confirming your order...",
          style: TextStyle(color: kWhite, fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          "Please don’t close the app",
          style: TextStyle(color: kLightGray, fontSize: 13),
        ),
      ],
    );
  }
}
