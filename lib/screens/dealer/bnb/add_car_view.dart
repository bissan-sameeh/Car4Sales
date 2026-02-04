import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/core/utils/converter_helper.dart';
import 'package:carmarketapp/core/utils/show_bottom_sheet.dart';
import 'package:carmarketapp/models/api/cars/car_api_model.dart';
import 'package:carmarketapp/screens/Widgets/custom_info_car.dart';
import 'package:carmarketapp/screens/Widgets/custom_loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/core/utils/picker_helper.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../../core/helpers/routers/router.dart';
import '../../../core/utils/cars_brand_name.dart';
import '../../../core/utils/snckbar.dart';

import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../../../models/car_types_model.dart';
import '../../../providers/Dealer/brands_provider/brands_names_provider.dart';
import '../../../providers/Dealer/cars_provider/cars_provider.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/custom_container.dart';
import '../../Widgets/custom_icon_quantity_button.dart';
import '../../Widgets/custom_small_container.dart';
import '../../Widgets/my_list_tile.dart';
import '../../Widgets/year_scroll_view.dart';

class AddUpdateCarView extends StatefulWidget {
  const
  AddUpdateCarView({super.key, this.car});

  final CarApiModel? car;

  @override
  State<AddUpdateCarView> createState() => _AddUpdateCarViewState();
}

class _AddUpdateCarViewState extends State<AddUpdateCarView>
    with ImageHelper, PickerHelper, MyShowBottomSheet, ShowSnackBar,ConverterHelper {
  int count = 0;
  String selectedCountry = 'Locate';
  int selectedFuelType = 0;

  // int climateDegree = 0;
  int degree = 0;
  int selectedBrandType = -1;
  int selectedBrandName = 0;
  int selectedColor = -1;
  double speedValue = 0.0;
  List<Color> colors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.blue.shade900,
    Colors.green,
    Colors.yellow,
    Colors.deepOrangeAccent,
    Colors.grey.shade500
  ];

  Uint8List? pickCoverImage;

  List<String> transmissionType = ['Manual', 'Automatic'];
  List<String> heatedSeats = ['Yes', 'No'];
  List<CarTypesModel> carsTypes = [
    CarTypesModel(icon: 'sedan_car', title: 'Sedan'),
    CarTypesModel(icon: 'convertible_car', title: 'Convertible'),
    CarTypesModel(icon: 'luxury_car', title: 'luxury'),
    CarTypesModel(icon: 'coupe_car', title: 'Coupe'),
    CarTypesModel(icon: 'suv_car', title: 'SUV'),
    CarTypesModel(icon: 'electric_car', title: 'Electric'),
  ];
  late TextEditingController batteryController;
  late TextEditingController rangeController;
  late TextEditingController seatsController;
  late TextEditingController priceController;

  int selectedIndexTransmission = -1;
  int selectedClimate = -1;
  List<Uint8List> pickedImages = [];
  String selectedRelease = '';
  String? brandName;
   late CarsProvider addCarPr;
   String? carBrandEdited;

  bool get heatedSeatsCondition => selectedClimate == 0;
  List<String> fuelType = [
    'Gasoline',
    'Diesel',
    'Electricity',
    'Hybrid',
    'Hydrogen',
    'Natural Gas',
    'Petroleum Gas',
    'Ethanol'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    batteryController =
        TextEditingController(text: widget.car?.battery.toString() ?? '');
    rangeController =
        TextEditingController(text: widget.car?.range.toString() ?? '');
    seatsController =
        TextEditingController(text: widget.car?.seats.toString() ?? '');
    priceController =
        TextEditingController(text: widget.car?.price.toString() ?? '');
    getEditedData();


  }

  void _checkCarStatus() {
    addCarPr = Provider.of<CarsProvider>(context, listen: false);

    if (widget.car == null) {
      if (addCarPr.addedCar.status == ApiStatus.COMPLETED) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          showSnackBar(context, message:'Add offer successfully');
          resetData();

        });
      } else if (addCarPr.addedCar.status == ApiStatus.ERROR) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          showSnackBar(context, message: addCarPr.addedCar.message.toString(), error: true);
        });
      }
    } else {
      if (addCarPr.updatedCar.status == ApiStatus.COMPLETED) {
        // عند النجاح
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          showSnackBar(context, message: 'Offer updated successfully');
          resetData();



        });

        NavigationRoutes().pop(context);
      } else if (addCarPr.updatedCar.status == ApiStatus.ERROR) {
        // عند الفشل
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          showSnackBar(context, message: addCarPr.addedCar.message.toString(), error: true);
        });
      }
    }
  }

  Future<void> getEditedData() async {

    if(checkEdit) {
       downloadImageAsBytes(widget.car!.coverImage!, isCoverImage: true);
      int index = carsTypes.indexWhere((car) =>
      car.title!.toLowerCase() ==
          widget.car!.carType.toString().toLowerCase());
      if (index != -1 ) {
        selectedBrandType = index;
      }



      speedValue = widget.car?.speed! ?? 0;
      speedValue = widget.car?.speed! ?? 0;
      selectedCountry = widget.car!.country.toString();
      selectedRelease = widget.car!.year.toString();
      selectedClimate = widget.car!.climate == true ? 0 : 1;

      // BrandNamesProvider brandProvider = Provider.of<BrandNamesProvider>(context, listen: false);
      int indexBrand=  CarBrands.carBrands.indexWhere((brand) => brand.brandName.toLowerCase()== widget.car?.brand?.toLowerCase());

      if (indexBrand != -1 && indexBrand < 10 ) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Provider.of<BrandNamesProvider>(context, listen: false).setSelectedIndex(index: indexBrand);});
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Provider.of<BrandNamesProvider>(context, listen: false).toggleSelectedBrandManager( indexBrand);});
      } else {

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Provider.of<BrandNamesProvider>(context, listen: false).setSelectedIndex(index: indexBrand);});
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Provider.of<BrandNamesProvider>(context, listen: false).toggleSelectedBrandManager( indexBrand);});


      }

      String? colorString = widget.car!.color;
      int colorValueFromApi = convertStringToColorIndex(colorString);


      selectedColor = colors
          .indexWhere(
            (color) => color.value == colorValueFromApi,
      );
      count = widget.car!.quantityInStock!;
      selectedIndexTransmission = widget.car!.transmission == 'Manual' ? 0 : 1;
      setState(() => isImagesLoading = true);
      await Future.wait(widget.car!.images!.map((imageUrl) async {
       await  downloadImageAsBytes(imageUrl);
      }));
      setState(() => isImagesLoading = false);
    }

  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    batteryController.dispose();
    rangeController.dispose();
    seatsController.dispose();
    priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    addCarPr = Provider.of<CarsProvider>(context, listen: false);
    return Scaffold(
      body: ListView(children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ///app Bar
                addCarrAppBar,

                ///Car Image
                carModelImage,

                ///Brand Name
                carBrandName,

                ///Brand Type
                carType,

                ///Car fuel
                carFuel,

                ///Car color
                carColor,

                ///Car Quantity
                carQuantity,

                ///  Car Speed
                carSpeed,

                ///Car Battery and car Range
                carBatteryRange,

                ///car location
                carLocation,

                ///carRelease
                carRelease,

                ///car climate
                carSeatsClimate,

                ///
                carTransmissionType,

                ///Images
                carImages,

                ///Year
                addNewCar

                ///
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Column get carSpeed {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 400,
              interval: 50,
              axisLabelStyle: GaugeTextStyle(
                color: kGrayColor, // تغيير لون الأرقام
                fontSize: 14, // التحكم بحجم النص
                fontWeight: FontWeight.bold,
              ),
              ranges: <GaugeRange>[
                GaugeRange(
                  startValue: 0,
                  endValue: 50,
                  color: Colors.green,
                ),
                GaugeRange(
                  startValue: 50,
                  endValue: 100,
                  color: Colors.orange,
                ),
                GaugeRange(
                  startValue: 100,
                  endValue: 150,
                  color: Colors.blue,
                ),
                GaugeRange(
                  startValue: 150,
                  endValue: 200,
                  color: Colors.red,
                ),
                GaugeRange(
                  startValue: 200,
                  endValue: 250,
                  color: Colors.teal,
                ),
                GaugeRange(
                  startValue: 250,
                  endValue: 300,
                  color: Colors.transparent,
                ),
                GaugeRange(
                  startValue: 300,
                  endValue: 350,
                  color: Colors.grey,
                ),
                GaugeRange(
                  startValue: 350,
                  endValue: 400,
                  color: Colors.black,
                ),
              ],
              pointers: <GaugePointer>[
                NeedlePointer(
                  value: speedValue,
                  enableAnimation: true,

                  // onValueChanged: (value) => setState(() => speedValue=value),
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Column(
                    children: [
                      Text(
                        " ${speedValue.toStringAsFixed(0)}  km/h",
                        style: TextStyle(
                            // color: Theme.of(context).hintColor,
                            ),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Text(
                        "Speed",
                      )
                    ],
                  ),
                  positionFactor: 1.4,
                  angle: 90,
                )
              ],
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: Slider(
            value: speedValue,

            // inactiveColor: Theme.of(context).h,

            activeColor: Theme.of(context).primaryColor,
            min: 0,
            max: 400,
            divisions: 8,

            label: speedValue.toStringAsFixed(0),
            onChanged: (value) {
              setState(() => speedValue = value);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 18.0.w, right: 18.w, bottom: 24.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //mainAxisSize: MainAxisSize.min,
            children: [
              _speed('0'),
              _speed('50'),
              _speed('100'),
              _speed('150'),
              _speed('200'),
              _speed('250'),
              _speed('300'),
              _speed('350'),
              _speed('400'),
            ],
          ),
        ),
      ],
    );
  }

  _speed(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 12.sp, color: kWhite),
    );
  }

  get addNewCar {

    return Padding(
      padding: EdgeInsets.only(top: 24.0.h),
      child: CustomButton(
            loading: Provider.of<CarsProvider>(context).isLoading,
            title: !checkEdit ? 'Add new Car' : 'Edit Car',
            onTap: () async { await _performAddUpdateCar();},




      ),
    );
  }

  get carRelease {
    return InkWell(
        onTap: () => carSelectRelease,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.0.sp),
          child: Container(
            // height: 90.h,
            padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 16.w),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
                color: Theme.of(context).hintColor,
                borderRadius: BorderRadius.circular(15.r)),
            child:
                // context: context,
                MyListTile(
              title: 'Release',
              suffixIcon: 'year',
              trailing: selectedRelease ,
              colorTextTitle: kWhite,
              context: context,
            ),
            // suffixIcon: 'year',
            // trailing: 'see',
            // suffixIcon: 'year',
          ),
        ));
  }

  Future<dynamic> get carSelectRelease async {
    return showSheet(context,
        height: MediaQuery.of(context).size.height /2,
        YearScrollView(
      focus: (String focus) {
        setState(() {
          selectedRelease = focus;
        });
      },
    ));
  }

  Widget get carImages {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16.0.h),
          child: Column(
            children: [
              MyListTile(context: context, title: 'Upload Car Images'),
              SizedBox(height: 24.h),
              SingleChildScrollView(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: pickedImages.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                  ),
                  itemBuilder: (context, index) {

                    if (isImagesLoading) {
                      return const Center(
                        child: CustomLoadingWidget()
                      );
                    }
                    return index != pickedImages.length
                        ?Stack(
                            fit: StackFit.expand,
                              clipBehavior: Clip.none,
                            children: [

                              Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    border:index==pickedImages.length? Border.all(
                                        color: Theme.of(context).primaryColor, width: 1):null,
                                  ),
                              child:  Image.memory(pickedImages[index], fit: BoxFit.cover,
                              ),
                              ),
                              PositionedDirectional(
                                   top: -8.h,
                                  end: -8.h,
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          pickedImages.removeAt(index);
                                        });
                                        if (pickedImages.isEmpty) {
                                          setState(() {});
                                          // checkAddImages;
                                        }
                                      },
                                      child: const CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      )))
                            ],
                          ) :
                         InkWell(
                            onTap: () async {
                            final List<Uint8List>  imagesBytes = await pickImagesBytes();
                              setState(() {
                                pickedImages.addAll(imagesBytes);
                              });
                            },
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                border:index==pickedImages.length? Border.all(
                                    color: Theme.of(context).primaryColor, width: 1):null,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: kWhite,
                                size: 30,
                              ),
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget get carTransmissionType {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0.h),
          child: MyListTile(context: context, title: 'Transmission Type'),
        ),
        listViewContainer(list: transmissionType),
      ],
    );
  }

  bool isImagesLoading = false;

 Future< void> downloadImageAsBytes(String url, {bool isCoverImage = false}) async {

   final  response= await downloadImageAsBytesConverter(url);

      setState(() {
        if (isCoverImage) {
          pickCoverImage = response!;
        } else {
          pickedImages.add(response!);
        }
      });

  }

  Widget listViewContainer(
      {required List list,
      double height = 90,
      Color? color,
      int dividedSpace = 2,
      bool isClimate = false}) {
    return SizedBox(
      height: height.h,
      child: ListView.separated(
        // shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,

        itemCount: list.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width / dividedSpace -
                24.w, // نصف عرض الشاشة
            child: CustomSmallContainer(
              color: color,
              text: list[index],
              index: index,
              onTap: (newIndex) {
                setState(() {
                  if (isClimate == true) {
                    selectedClimate = newIndex;
                  } else {
                    selectedIndexTransmission = newIndex;
                  }
                  // isClimate==true?selectedClimate : selectedIndex = newIndex;
                });
              },
              selectedIndex: isClimate == true
                  ? selectedClimate
                  : selectedIndexTransmission,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => SizedBox(
          width: isClimate == true ? 4.w : 12.w,
        ),
      ),
    );
  }

  // int selectedIndex = 0;

  // InkWell _container(
  //     {required String text,
  //     required int index,
  //     double? width,
  //     double? height = 90,
  //     Color? color}) {
  //   selectedContainer = selectedIndex == index;
  //
  //   return InkWell(
  //     onTap: () {
  //       setState(() {
  //         selectedIndex = index;
  //       });
  //     },
  //     child: Container(
  //       height: height?.h,
  //       width: width?.w ?? double.infinity,
  //       alignment: Alignment.center,
  //       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(15.r),
  //           color: color ?? Theme.of(context).hintColor,
  //           border: selectedContainer
  //               ? Border.all(
  //                   color: color == Theme.of(context).primaryColor
  //                       ? Theme.of(context).scaffoldBackgroundColor
  //                       : Theme.of(context).primaryColor,
  //                   width: 1)
  //               : null),
  //       child: Text(
  //         text,
  //         style: TextStyle(color: kWhite, fontSize: 14.sp),
  //       ),
  //     ),
  //   );
  // }

  Widget get carSeatsClimate {
    return Row(
      children: [
        Column(
          children: [
            SizedBox(
                width: 150.w,
                child: CustomContainer(
                  controller: seatsController,
                  title: 'seats',
                  preTileIcon: 'seat',
                  hint: '0',
                )),
            SizedBox(
              height: 12.h,
            ),
            SizedBox(
                // flex: 2,
                width: 150.w,
                child: CustomContainer(
                  controller: priceController,
                  title: ' Price',
                  suffixIcon: Icons.monetization_on,
                  preTileIcon: 'year',
                  hint: '20.0',
                )),
          ],
        ),
        SizedBox(
          width: 12.w,
        ),
        Expanded(
          child: SizedBox(
            height: 300.h,
            child: CustomContainer(
              // height: 300.h,
              title: 'Climate',
              isClimate: true,
              widget: Padding(
                padding: EdgeInsets.only(top: 16.0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    listViewContainer(
                        list: heatedSeats,
                        color: Theme.of(context).primaryColor,
                        height: 60,
                        dividedSpace: 4,
                        isClimate: true),
                    SizedBox(
                      height: 60.h,
                    ),
                    // Spacer(),
                    Row(
                      children: [
                        Icon(
                          heatedSeatsCondition
                              ? Icons.heat_pump
                              : Icons.severe_cold,
                          color: heatedSeatsCondition
                              ? Colors.red
                              : Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Expanded(
                            child: Text(
                          heatedSeatsCondition ? "Hotting" : "Cooling",
                          style: TextStyle(fontSize: 14.sp, color: kWhite),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget get carLocation {
    return Column(
      children: [
        SizedBox(
          height: 24.h,
        ),
        MyListTile(
          context: context,
          title: 'Car Location',
        ),
        SizedBox(
          height: 12.h,
        ),

        InkWell(
          onTap: () {
            showCountryPicker(
                context: context,
                countryListTheme: CountryListThemeData(
                  flagSize: 25,
                  backgroundColor: Theme.of(context).hintColor,
                  textStyle: const TextStyle(fontSize: 16, color: kWhite),

                  bottomSheetHeight: MediaQuery.of(context).size.height / 2,
                  // Optional. Country list modal height
                  //Optional. Sets the border radius for the bottomsheet.
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),

                  //Optional. Styles the search field.
                  inputDecoration: InputDecoration(
                      labelText: 'Search',
                      hintText: 'Start typing to search',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).primaryColor,
                      ),
                      focusColor: Theme.of(context).primaryColor,
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      focusedBorder: buildOutLinedInputBorder(
                          color: Theme.of(context).primaryColor),
                      border: buildOutLinedInputBorder(
                          color: kGrayColor.withOpacity(0.2))),
                ),
                onSelect: (Country country) => setState(() {
                      selectedCountry = country.name;
                      // print('Select country: ${country.displayName}');
                    }));
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 16.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 28.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: Theme.of(context).hintColor,
                border: Border.all(color: Theme.of(context).primaryColor)),
            child: MyListTile(
              colorTextTitle: kWhite,
              context: context,
              title: selectedCountry,
              preIcon: 'arrow',
              suffixIcon: Icons.add_location,
              fountSize: 12.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget get carBatteryRange {
    return Row(
      children: [
        // SizedBox(
        //   height: 30.h,
        // ),
        ///Battery
        Expanded(
          child: CustomContainer(
            controller: batteryController,
            title: 'Battery',
            suffixIcon: Icons.percent,
            preTileIcon: 'battery',
            hint: '0',
          ),
        ),
        SizedBox(
          width: 12.w,
        ),

        ///Range
        Expanded(
          child: CustomContainer(
            controller: rangeController,
            title: 'Range',
            suffixIcon: 'Km',
            preTileIcon: 'range',
            hint: '3',
          ),
        ),
      ],
    );
  }

  Widget get carType {
    return Column(
      children: [
        //tile
        MyListTile(
          context: context,
          title: 'Brand Type',
        ),
        SizedBox(
          height: 18.h,
        ),
        //Brand Type
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => setState(() => selectedBrandType = index),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Theme.of(context).hintColor,
                    border: Border.all(
                        width: 0.5.w,
                        color: selectedBrandType == index
                            ? Theme.of(context).primaryColor
                            : Colors.black),
                  ),
                  child: Column(
                    children: [
                      appSvgImage(
                          path: carsTypes[index].icon.toString(),
                          height: 50.h,
                          width: 50.h,
                          color: Theme.of(context).primaryColor),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(carsTypes[index].title.toString(),
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 8.sp,
                            letterSpacing: -1,
                          ))
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: 8.w,
              );
            },
            itemCount: carsTypes.length,
          ),
        ),
        SizedBox(
          height: 16.h,
        )
      ],
    );
  }

  Widget get carFuel {
    return Column(
      children: [
        //tile
        MyListTile(
          context: context,
          title: 'Car Fuel',
        ),
        SizedBox(
          height: 18.h,
        ),
        //Brand
        SizedBox(
          height: 75.h,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            // padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => setState(() => selectedFuelType = index),
                child: Container(
                  // width: 80.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Theme.of(context).hintColor,
                    border: Border.all(
                        width: 0.5.w,
                        color: selectedFuelType == index
                            ? Theme.of(context).primaryColor
                            : Colors.white),
                  ),
                  child: Text(fuelType[index].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 8.sp,
                        letterSpacing: -1,
                      )),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: 8.w,
              );
            },
            itemCount: fuelType.length,
          ),
        ),
        SizedBox(
          height: 16.h,
        )
      ],
    );
  }

  Widget get carQuantity {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.0.h),
      child: Row(
        children: [
          Text(
            "Quantity",
            style: TextStyle(fontSize: 16.sp),
          ),
          const Spacer(),
          IconQuantityButton(
            context: context,
        
            iconData: Icons.add,
            converter: 1, maxQuantity: 50,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: Text(
              count.toString(),
            ),
          ),
          IconQuantityButton(
            context: context,
            iconData: Icons.remove,

            converter: 0,
            maxQuantity: 50,
           
          ),
        ],
      ),
    );
  }

  Widget get carColor {
    return Column(
      children: [
        MyListTile(
          context: context,
          title: 'Car Color',
        ),
        SizedBox(
          height: 18.h,
        ),
        SizedBox(
          height: 60.h,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: colors.length,
            itemBuilder: (context, index) {
              bool isSelected = selectedColor == index ||
                  (checkEdit &&
                      widget.car!.color.toString() == colors[index].toString());

              return InkWell(
                onTap: () => setState(() {
                  selectedColor = index;
                }),
                child: Container(
                  width: 50.h,
                  height: 50.h,
                  padding:
                      EdgeInsets.symmetric(horizontal:selectedColor ==index ? 12.h :16.h, vertical: selectedColor ==index ?12: 24.h),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors[index] ,
                    border: isSelected
                        ? Border.all(color: Colors.black, width: 2)
                        : null,
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: 14.w,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget get carBrandName {
    return Column(
      children: [
        //tile
        MyListTile(
          context: context,
          title: 'Brand Name',
          trailing: 'add brand',
          trailingAction: () => NavigationRoutes().jump(
            context,
            Routes.addBrandScreen,
          ),
        ),
        SizedBox(
          height: 18.h,
        ),
        //Brand
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              // print(index);
              BrandNamesProvider brandName=Provider.of<BrandNamesProvider>(context);

              return InkWell(
                onTap: (index == 10 && brandName.selectedCarType >= 10)
                    ? null
                    : () {
                        brandName.setSelectedIndex(index: index); //0
                          brandName.toggleSelectedBrandManager(index, isSelected: index == brandName.selectedCarType);

                          setState(() {});

                      },
                child: Container(
                  alignment: Alignment.center,
                  width: 100.w,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Theme.of(context).hintColor,
                    border: Border.all(
                        width: 0.5.w,
                        color: index == brandName.selectedCarType ||
                                (index == 10 &&
                                    brandName.selectedCarType >= 10)
                            ? Theme.of(context).primaryColor
                            : Colors.black),
                  ),
                  child: brandName.selectedCarType < 10 && index < 10
                      ?
                  Text(brandName.brands[index].brandName,
                          maxLines: 2,
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 8.sp,
                            letterSpacing: -0.3,
                          )) ///brand less 30
                      :
                  brandName.selectedCarType < 10
                          ? InkWell(
                              onTap: () {
                                NavigationRoutes()
                                    .jump(context, Routes.addBrandScreen);
                              },
                              child: const Icon(
                                Icons.add,
                                color: kWhite,
                                size: 30,
                              )) //add new brand
                          : Text(
                              index < 10
                                  ? brandName.brands[index].brandName
                                  :brandName
                                      .brands[brandName.selectedCarType]
                                      .brandName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: kWhite,
                                fontSize: 8.sp,
                                letterSpacing: -0.3,
                              ),
                            ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: 4.w,
              );
            },
            itemCount: 11,
          ),
        ),
        SizedBox(
          height: 16.h,
        )
      ],
    );
  }

  Widget get carModelImage {
    return Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [

              InkWell(
                  onTap: () async {
                Uint8List? image = await pickImageBytes();
                if (image != null) {
                  setState(() {
                    pickCoverImage = image;
                  });
                }
            },
            child: Container(
              height: 200.w,
              width: 200.w,
              margin: EdgeInsets.only(bottom: 20.h),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150.r),
                color: Theme.of(context).hintColor,
              ),
              child: pickCoverImage != null
                      ? Image.memory(
                          pickCoverImage!,
                          fit: BoxFit.cover,
                        )
                      :checkEdit ? CircularProgressIndicator(color: Theme.of(context).primaryColor,): appSvgImage(path: 'car'),
            ),
          ),
          PositionedDirectional(
            end: 20,
            bottom: 25,
            child: InkWell(
              onTap: () async {
                Uint8List? image = await pickImageBytes();
                if (image != null) {
                  setState(() {
                    pickCoverImage = image;
                  });
                }
              },
              child: Icon(
                Icons.camera_enhance_rounded,
                size: 50.h,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        ]);
  }

  get addCarCoverImage {
    showSheet(
        context,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.h),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4.h,
                    width: 40.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15.r,
                      ),
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // CustomInfoCar(
                    //   carInfo: 'Camera',
                    //   path: Icons.camera_enhance_rounded,
                    //   onTap: () async {
                    //     // var image = await pickImage(image: ImageSource.camera);
                    //     // if (image != null) {
                    //     //   setState(() {
                    //     //     pickCoverImage = image;
                    //     //   });
                    //     // }
                    //
                    //
                    //   },
                    // ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomInfoCar(
                        carInfo: 'Gallery',
                        path: Icons.camera,
                        onTap: () async {
                          // var image = await pickImage();
                          // if (image != null) {
                          //   setState(() {
                          //     pickCoverImage = image;
                          //   });
                          // }
                          Uint8List? image = await pickImageBytes();
                          if (image != null) {
                            pickCoverImage = image;
                          }
                        })
                  ],
                ),
              ],
            ),
          ),
        ),
        height: 200);
  }

  Widget get addCarrAppBar {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r), gradient: kGradient),
          child: Stack(
            // alignment: Alignment.topLeft,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if(  widget.car !=null ) InkWell(
                            onTap:() => NavigationRoutes().pop(context) ,
                            child: Icon(Icons.arrow_back_ios,color: kWhite, size: 25.r,)),
                        if(  widget.car !=null ) SizedBox(width: 8.w,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.car == null ? "Add New Car" : "Edit Car",
                              style: const TextStyle(color: kWhite),
                            ),
                            Text(
                              checkEdit ? 'Update Your Offer !' : "Select your Offer !",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.sp,
                                  color: kWhite),
                            ),
                          ],
                        ),

                      ],
                    ),

                  ],
                ),
              ),
              PositionedDirectional(
                  end: -5,
                  top: 0,
                  // bottom: 0,
                  child: Transform.translate(
                    offset: const Offset(-5, 0),
                    child: Transform.rotate(
                        angle: 50,
                        child: Image.asset(
                          "assets/images/car.png",
                          width: 80.w,
                          height: 70.h,
                          color: kWhite,
                        )),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  bool get _checkData {
    if (pickCoverImage == null) {
      showSnackBar(context,
          error: true,
          message: 'No Cover Car Image is Selected! Please Choice One!');

      return false;
    } else if (Provider.of<BrandNamesProvider>(context,listen: false).selectedCarType == -1) {
      showSnackBar(context,
          error: true,
          message: 'No Brand Name Car is Selected! Please Choice One!');

      return false;
    } else if (selectedBrandType == -1) {
      showSnackBar(context,
          error: true, message: 'No Car type is Selected! Please Choice One!');

      return false;
    } else if (selectedFuelType == -1) {
      showSnackBar(context,
          error: true, message: 'No Fuel Type is Selected! Please Choice One!');

      return false;
    } else if (selectedColor == -1) {
      showSnackBar(context,
          error: true, message: 'No Color Car is Selected! Please Choice One!');

      return false;
    } else if (count == 0) {
      showSnackBar(context,
          error: true, message: 'No Amount is determined! Please Choice One!');

      return false;
    } else if (speedValue == 0.0) {
      showSnackBar(context,
          error: true, message: 'No Speed is Selected! Please Choice One!');

      return false;
    } else if (batteryController.text.isEmpty) {
      showSnackBar(context,
          error: true,
          message: 'No Battery mount is determined! Please Choice One!');

      return false;
    } else if (rangeController.text.isEmpty) {
      showSnackBar(context,
          error: true,
          message: 'No Range mount is determined! Please Choice One!');

      return false;
    }  else if (selectedCountry == ('Locate')) {
      showSnackBar(context,
          error: true, message: 'No Country is Selected! Please Choice One!');

      return false;
    } else if (selectedRelease == ('')) {
      showSnackBar(context,
          error: true, message: 'No Year is determined! Please Choice One!');

      return false;
    } else if (selectedClimate == -1) {
      showSnackBar(context,
          error: true, message: 'No Speed is Selected! Please Choice One!');

      return false;
    } else if (seatsController.text.isEmpty) {
      showSnackBar(context,
          error: true,
          message: 'No seats quant is determined! Please Choice One!');

      return false;
    } else if (priceController.text.isEmpty) {
      showSnackBar(context,
          error: true,
          message: 'No price quant is determined! Please Choice One!');
      return false;
    } else if (selectedIndexTransmission == -1) {
      showSnackBar(context,
          error: true,
          message: 'No Transmission Type is determined! Please Choice One!');

      return false;
    }else if (pickedImages.isEmpty) {
      showSnackBar(context,
          error: true,
          message: 'Upload Images ! Please Choice One!');

      return false;
    }

    return true;
  }

//   List<String> carImagesSaver=[];

  Future<void> _performAddUpdateCar() async {
    if (_checkData) {
      await _addUpdateOffer();
    }
  }

  Future<void> _addUpdateOffer() async {
     addCarPr=Provider.of<CarsProvider>(context,listen: false);

     if( !checkEdit ){

    await addCarPr.addCar(

          color: colors[selectedColor].toString(),
          images: pickedImages,
          coverImage: pickCoverImage!,
          transmission: transmissionType[selectedIndexTransmission],
          year: int.tryParse(selectedRelease) ?? 0,
          battery: int.tryParse(batteryController.text) ?? 0,
          brand: Provider.of<BrandNamesProvider>(context,listen: false)
              .brandName,
          carType: carsTypes[selectedBrandType].title.toString(),
          speed: speedValue,
          fuelType: fuelType[selectedFuelType],
          climate: heatedSeats.contains('Yes'),
          country: selectedCountry,
          range: double.tryParse(rangeController.text) ?? 0.0,
          seats: int.tryParse(seatsController.text) ?? 0,
          quantityInStock: count,
          price: double.tryParse(priceController.text) ?? 0.0);

     _checkCarStatus();



      }else {
       await addCarPr.updateCar(
          carCoverImage:pickCoverImage!,
          carId: widget.car!.id ??0,
            color: colors[selectedColor].toString(),
            images:  pickedImages,
            transmission: transmissionType[selectedIndexTransmission],
            year: int.tryParse(selectedRelease) ?? 0,
            battery: int.tryParse(batteryController.text) ?? 0,
            brand: Provider.of<BrandNamesProvider>(context, listen: false).brandName ,
            carType: carsTypes[selectedBrandType].title.toString(),
            speed: speedValue,
            fuelType: fuelType[selectedFuelType],
            climate: heatedSeats.contains('Yes'),
            country: selectedCountry,
            range: double.tryParse(rangeController.text) ?? 0.0,
            seats: int.tryParse(seatsController.text) ?? 0,
            quantityInStock: count,
            price: double.tryParse(priceController.text) ?? 0.0);
        _checkCarStatus();
      }
  }


  resetData(){
    selectedColor =-1 ;
    pickedImages = [];
    // images: checkEdit ? updatedImagesUint8List : pickedImages,
    selectedIndexTransmission =-1;
    selectedRelease='';
    batteryController.text= '';
    Provider.of<BrandNamesProvider>(context,listen: false).resetSelectedBrandManager();
    selectedBrandType = -1;
     speedValue=0;
    selectedFuelType =-1;
    selectedCountry='Locate';
   rangeController.text='';
    seatsController.text='';
     count=0;
    priceController.text ='';
    pickCoverImage=null;
    pickedImages=[];
    setState(() {

    });

  }

  bool get checkEdit => widget.car != null;
}
