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
import '../../core/utils/snckbar.dart';
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
    with MyShowBottomSheet,ShowSnackBar,MyShowDialog,ImageHelper {
  late TextEditingController searchController;
  late TextEditingController addBrandController;
  bool isPressed = false;
  List<BrandModel> brandsNames = [];
  List<BrandModel> searchedBrands = [];

  List<BrandModel> get listToReadBrands =>
      searchController.text.isNotEmpty ? searchedBrands : brandsNames;


  @override
   initState()  {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController();
    addBrandController = TextEditingController();

     init();
  }
  init() async {

    await getBrands;
  }
 Future<void> get getBrands async{

    var list=await BrandsDbController().read();
    /// print(list);
    if(mounted){
    Provider.of<BrandNamesProvider>(context,listen: false).setBrands(list);
    }

 }

  Future<void> addBrand() async {
    final brandProvider = Provider.of<BrandNamesProvider>(context, listen: false);
    String newBrandName = addBrandController.text.trim();
    ///check if exit in provider or database
    bool? exists = brandProvider.brands.any((brand) =>
        brand.brandName.toLowerCase() == addBrandController.text.toLowerCase());
    List<BrandModel>? brandsList=await BrandsDbController().show(addBrandController.text);
    //check if brand exit previously
    if (exists|| brandsList!=null ) {
      if(mounted){

      showWarningDialog(context,text:'Brand Exits!');
      }

    } else {
      var result = await BrandsDbController().create(BrandModel(brandName: newBrandName));
      print(result);
      if (result) {
        //add to provider
        brandProvider.addBrand(newBrandName);
        ///get index of new brand to make it selected after add it
        int newIndex = brandProvider.brands.indexWhere((brand) =>
            brand.brandName.toLowerCase() == newBrandName.toLowerCase());

        if (newIndex != -1) {
          brandProvider.toggleSelectedBrandManager(newIndex, isSelected: true);
        }

        addBrandController.clear();
        if (mounted) {
          NavigationRoutes().pop(context);
        }
      }
    }
  }

 bool get checkBrandTextField=> addBrandController.text.isNotEmpty;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
    addBrandController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
           CustomAppBar(text: "Brands",action: InkWell(
               onTap: () => addNewBrad,
               child: appSvgImage(path: 'add_car',height: 30,width: 30,color: Theme.of(context).primaryColor)),),
          CustomSearchBar(
            searchController: searchController,
            isBrandScreen: true,
            hint: 'Brand Name',
            onChanged: (value) {
              searchedBrands.clear();
              for (var brand in brandsNames) {
                setState(() {
                  if (brand.brandName
                      .toUpperCase()
                      .contains(value.toUpperCase())) {
                    searchedBrands.add(brand);
                  }
                });
              }
            },
          ),
          SizedBox(
            height: 12.h,
          ),
          Expanded(child: Consumer<BrandNamesProvider>(
            builder: (BuildContext context, BrandNamesProvider brandProvider,
                Widget? child) {
              brandsNames = brandProvider.brands;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child:  listToReadBrands.isEmpty? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomNotFound(image: 'assets/images/search_not_found.json',width: 450,text: "No result Found!",),
                    ],
                  ): Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children:listToReadBrands.map((brand) {

                      return  CustomChip(
                          brandName: brand.brandName,
                          isPressed: brand.isSelected ,
                          onPressed: () {
                             setState(() {
                              int? index = brandProvider.brands.indexOf(brand);
                              print(index);
                              brandProvider.setSelectedIndex(index: index);
                              brandProvider.toggleSelectedBrandManager(index, isSelected: brandProvider.selectedCarType == index);


                             });
                             setState(() {

                             });
                          });
                    }).toList(),

                 ) ,
                ),
              );
            },
          )),
          // Spacer(),
      searchController.text.isNotEmpty && listToReadBrands.isEmpty? SizedBox.shrink() :  Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.h),
            child: CustomButton(
              onTap: () {



                setState(() {

                });
                NavigationRoutes().pop(context);
              },
              title: 'Select',
            ),
          )
        ],
      ),
    ));
  }

  get addNewBrad {
    return showSheet(
        context,
        height: 400,
        StatefulBuilder(
          builder:(context, setState) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0.h, right: 16.h, top: 16),
                  child: Text(
                    'Add new brand',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kWhite,fontSize:18.sp ),
                  ),
                ),
                CustomSearchBar(
                  searchController: addBrandController,
                  isBrandScreen: true,
                  hint: 'Brand Name',
                  onChanged: (p0) {
                    setState(() {});
                  },
                ),
                // Spacer(),

                Padding(
                    padding: EdgeInsets.only(left: 16.0.w, right: 16.w, top: 24.h,bottom: 16.h),
                    child: CustomButton(
                        title: 'Add new brand',
                        color: checkBrandTextField ==false?kGrayColor:Theme.of(context).primaryColor,

                        onTap: () async {

                           await  _performAdd;
                        }


                    ))
              ],
            );
          }

        ));
  }

Future<void> get _performAdd async{
  if(_checkData){
    await _add;
  }else{
    showWarningDialog(context,text:'Brand Name is Empty!!');

  }
}
bool get _checkData{
    if(checkBrandTextField){
     return true;
    } else{
      return false;

    }
}
Future<void> get _add async {
 await addBrand();

}

}
