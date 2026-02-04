import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/helpers/api_helpers/api_response.dart';
import '../../../core/helpers/routers/router.dart';
import '../../../providers/customer/favorite/favorite_provider.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_error_widget.dart';
import '../../Widgets/custom_loading_widget.dart';
import '../../Widgets/custom_no_data.dart';
import '../../Widgets/customer_favorite_widgets/customer_favorite_list.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<FavoriteProvider>();
      provider.isFavScreen(true);
      provider.fetchAllFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(text: 'Favorite'),
            SizedBox(height: 24.h),

            /// 👇 هنا التعديل المهم
            Expanded(
              child: Consumer<FavoriteProvider>(
                builder: (context, value, child) {
                  if (value.allFavorites.status == ApiStatus.ERROR) {
                    return CustomErrorWidget(
                      text: value.allFavorites.message.toString(),
                      onTap: () async {
                        await value.fetchAllFavorites();
                      },
                      isInternetConnection: value.allFavorites.message
                          .toString()
                          .toLowerCase()
                          .contains("internet"),
                    );
                  }

                  if (value.allFavorites.status == ApiStatus.LOADING) {
                    return CustomLoadingWidget(width: 400);
                  }

                  final favs = value.allFavorites.data ?? [];

                  if (favs.isEmpty) {
                    return Center(
                      child: CustomNoData(
                        iconSize: 250,
                        text: 'Didn\'t find your favorite car?',
                        subtitle:
                        'Try searching or browsing the categories.',
                        showActionButton: true,
                        icon: "favorite.json",
                        actionText: 'View Cars',
                        onActionPressed: () => NavigationRoutes()
                            .jump(context, Routes.customerHomeView),
                      ),
                    );
                  }

                  return CustomerFavoriteList(favorites: favs);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
