import 'package:carmarketapp/DB/Controllers/brands_db_controller.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/screens/Widgets/custom_app_bar.dart';
import 'package:carmarketapp/screens/Widgets/custom_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/helpers/routers/router.dart';
import '../../core/utils/show_bottom_sheet.dart';
import '../../core/utils/show_dialog_helper.dart';
import '../../models/db/brands_model.dart';
import '../../providers/Dealer/brands_provider/brands_names_provider.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_not_found.dart';
import '../Widgets/search_bar.dart';

class AddBrandScreen extends StatefulWidget {
  const AddBrandScreen({super.key});

  @override
  State<AddBrandScreen> createState() => _AddBrandScreenState();
}

class _AddBrandScreenState extends State<AddBrandScreen>
    with MyShowBottomSheet, MyShowDialog, ImageHelper {
  late final TextEditingController _searchController;
  late final TextEditingController _addBrandController;

  List<BrandModel> _searchedBrands = [];

  bool get _isSearching => _searchController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _addBrandController = TextEditingController();
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    final brands = await BrandsDbController().read();
    if (!mounted) return;
    context.read<BrandNamesProvider>().setBrands(brands);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _addBrandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              text: "Brands",
              action: InkWell(
                onTap: _openAddBrandSheet,
                child: appSvgImage(
                  path: 'add_car',
                  height: 30,
                  width: 30,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),

            /// 🔍 Search
            CustomSearchBar(
              searchController: _searchController,
              isBrandScreen: true,
              hint: 'Brand Name',
              onChanged: _onSearchChanged,
            ),

            SizedBox(height: 12.h),

            /// 🏷 Brands List
            Expanded(
              child: Consumer<BrandNamesProvider>(
                builder: (_, provider, __) {
                  final brands =
                  _isSearching ? _searchedBrands : provider.brands;

                  if (brands.isEmpty) {
                    return const CustomNotFound(
                      image: 'assets/images/search_not_found.json',
                      width: 450,
                      text: "No result Found!",
                    );
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(brands.length, (index) {
                        final brand = brands[index];
                        return CustomChip(
                          brandName: brand.brandName,
                          isPressed: brand.isSelected,
                          onPressed: () =>
                              _selectBrand(provider, brand),
                        );
                      }),
                    ),
                  );
                },
              ),
            ),

            /// ✅ Select Button
            if (!_isSearching || _searchedBrands.isNotEmpty)
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: CustomButton(
                  title: 'Select',
                  onTap: () => NavigationRoutes().pop(context),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// ================= Logic =================

  void _onSearchChanged(String value) {
    final provider = context.read<BrandNamesProvider>();
    _searchedBrands = provider.brands
        .where((b) =>
        b.brandName.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  void _selectBrand(BrandNamesProvider provider, BrandModel brand) {
    final index = provider.brands.indexOf(brand);
    provider.toggleSelectedBrandManager(index, isSelected: true);
  }

  /// ================= Add Brand =================

  void _openAddBrandSheet() {
    showSheet(
      context,
      height: 400,
      _AddBrandBottomSheet(
        controller: _addBrandController,
        onAdd: _addBrand,
      ),
    );
  }

  Future<void> _addBrand() async {
    final name = _addBrandController.text.trim();
    if (name.isEmpty) {
      showWarningDialog(context, text: 'Brand Name is Empty!');
      return;
    }

    final provider = context.read<BrandNamesProvider>();

    final existsInProvider = provider.brands
        .any((b) => b.brandName.toLowerCase() == name.toLowerCase());

    final existsInDb = await BrandsDbController().show(name);

    if (existsInProvider || existsInDb != null) {
      showWarningDialog(context, text: 'Brand Exists!');
      return;
    }

    final success =
    await BrandsDbController().create(BrandModel(brandName: name));

    if (!success) return;

    provider.addBrand(name);

    final index = provider.brands
        .indexWhere((b) => b.brandName.toLowerCase() == name.toLowerCase());

    if (index != -1) {
      provider.toggleSelectedBrandManager(index, isSelected: true);
    }

    _addBrandController.clear();
    if (mounted) NavigationRoutes().pop(context);
  }
}

/// ================= Bottom Sheet =================

class _AddBrandBottomSheet extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const _AddBrandBottomSheet({
    required this.controller,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        Text(
          'Add new brand',
          style: TextStyle(color: kWhite, fontSize: 18.sp),
        ),
        SizedBox(height: 16.h),
        CustomSearchBar(
          searchController: controller,
          isBrandScreen: true,
          hint: 'Brand Name',
        ),
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomButton(
            title: 'Add new brand',
            onTap: onAdd,
          ),
        ),
      ],
    );
  }
}
