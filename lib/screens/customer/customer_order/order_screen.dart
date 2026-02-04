import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/providers/customer/orders/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/image_helper.dart';
import '../../Widgets/custom_loading_widget.dart';
import '../../../core/helpers/routers/router.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with ImageHelper {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => context.read<OrdersProvider>().fetchAllOrders(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersProvider>(
      builder: (context, ordersProvider, _) {
        final response = ordersProvider.fetchAllOrdersResponse;
        final status = response.status;
        final orders = response.data;
        final message = response.message;

        return CustomScrollView(
          slivers: [
            // ================= AppBar =================
            SliverAppBar(
              title: const Text(
                'My Orders',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              pinned: true,
              floating: true,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(decoration:  BoxDecoration(gradient: kGradient)),
              ),
            ),

            // ================= Loading =================
            if (status == ApiStatus.LOADING)
              const SliverFillRemaining(
                child: Center(child: CustomLoadingWidget(width: 400)),
              ),

            // ================= Error =================
            if (status == ApiStatus.ERROR)
              SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 60),
                        const SizedBox(height: 16),
                        const Text(
                          'Error Loading Orders',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          message ?? 'An error occurred',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => ordersProvider.fetchAllOrders(),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // ================= Empty =================
            if (status == ApiStatus.COMPLETED && (orders == null || orders.isEmpty))
              SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag_outlined,
                            color: Colors.grey.shade400, size: 80),
                        const SizedBox(height: 16),
                        const Text(
                          'No Orders Yet',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'You haven\'t placed any orders yet.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => NavigationRoutes().jump(
                            context,
                            Routes.customerHomeView,
                            replace: true,
                          ),
                          child: const Text('Browse Cars'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // ================= Completed =================
            if (status == ApiStatus.COMPLETED && orders != null && orders.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final order = orders[index];
                      final car = order.car;
                      if (car == null) return const SizedBox();

                      return Card(
                        elevation: 4,
                        color: kLightBlackColor,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                  child: appShimmerImage(
                                    car.coverImage ?? '',
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Completed',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Content
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          car.brand ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        '\$${order.totalPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Order #${order.id} • ${_formatDate(order.createdAt.toString())}',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: orders.length,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateString;
    }
  }
}
