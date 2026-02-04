import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/helpers/api_helpers/api_response.dart';
import '../../../core/helpers/routers/router.dart';
import '../../../core/helpers/routers/routes.dart';
import '../../../providers/customer/cart/cart_provider.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_error_widget.dart';
import '../../Widgets/custom_loading_widget.dart';
import '../../Widgets/custom_no_data.dart';
import '../../Widgets/customer_cart_widgets/customer_cart_list.dart';

class CustomerCartScreen extends StatefulWidget {
  const CustomerCartScreen({super.key});

  @override
  State<CustomerCartScreen> createState() => _CustomerCartScreenState();
}

class _CustomerCartScreenState extends State<CustomerCartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => context.read<CartProvider>().fetchAllCart(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(text: "Cart"),

            /// 👇 Expanded ثابت
            Expanded(
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  if (cartProvider.allCartItems.status ==
                      ApiStatus.ERROR) {
                    return CustomErrorWidget(
                      text:
                      cartProvider.allCartItems.message.toString(),
                      onTap: () async {
                        await cartProvider.fetchAllCart();
                      },
                      isInternetConnection: cartProvider
                          .allCartItems.message
                          .toString()
                          .toLowerCase()
                          .contains("internet"),
                    );
                  }

                  if (cartProvider.allCartItems.status ==
                      ApiStatus.LOADING) {
                    return CustomLoadingWidget(width: 400);
                  }

                  final cart =
                      cartProvider.allCartItems.data ?? [];

                  if (cart.isEmpty) {
                    return Center(
                      child: CustomNoData(
                        text:
                        'Didn\'t find your favorite car?',
                        subtitle:
                        'Try searching or browsing the categories.',
                        showActionButton: true,
                        icon: "empty_cart",
                        actionText: 'View Cars',
                        onActionPressed: () =>
                            NavigationRoutes().jump(
                              context,
                              Routes.customerHomeView,
                            ),
                      ),
                    );
                  }

                  return CustomerCartList(cart: cart);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
