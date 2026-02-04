import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/screens/Widgets/custom_container.dart';
import 'package:carmarketapp/screens/Widgets/custom_info_car.dart';
import 'package:carmarketapp/screens/Widgets/custom_loading_widget.dart';
import 'package:carmarketapp/screens/Widgets/custom_not_found.dart';
import 'package:carmarketapp/screens/Widgets/show_car_detailes/picture_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../core/helpers/api_helpers/api_response.dart';
import '../../core/strings/failure.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/show_bottom_sheet.dart';
import '../../models/api/cars/car_api_model.dart';
import '../../models/car_info_model.dart';
import '../../providers/Dealer/cars_provider/cars_provider.dart';
import '../Widgets/custom_app_bar.dart';
import '../Widgets/custom_error_widget.dart';
import '../Widgets/custom_small_text.dart';
import '../Widgets/my_list_tile.dart';
import '../Widgets/show_car_detailes/comments.dart';

class ShowCarDetails extends StatefulWidget {
  const ShowCarDetails({super.key});

  @override
  State<ShowCarDetails> createState() => _ShowCarDetailsState();
}

class _ShowCarDetailsState extends State<ShowCarDetails>
    with ImageHelper, MyShowBottomSheet {
  int selectedPicture = 0;
  PageController pageController = PageController();

  late List<CarInfoModel> _carSpec;

  List<String>? images = [];
  bool isImagesLoaded = false;

  bool isOfferScreen = false;
  int? carId;
  double? review;
  int? totalReview;
  int? totalBuyer;

  bool _isFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isFetched) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;

      if (args != null) {
        isOfferScreen = args['isOfferScreen'] ?? false;
        carId = args['carId'];
        review = args['review'];
        totalReview = args['totalReview'];
        totalBuyer = args['totalBuyer'];

        if (carId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context
                .read<CarsProvider>()
                .fetchSingleCar(carId.toString());
          });
          _isFetched = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarsProvider>();
    final response = provider.singleCar;

    switch (response.status) {

      case ApiStatus.LOADING:
        return Scaffold(
          body: Column(
            children: [
              SafeArea(child: CustomAppBar(text: 'Details')),
              const Center(child: CustomLoadingWidget(width: 400,)),
            ],
          ),
        );

      case ApiStatus.ERROR:
        return Scaffold(
          body: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => NavigationRoutes().pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(16),
                        color: kLightBlackColor,
                      ),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: const Icon(Icons.arrow_back_ios, color: kWhite)),
                  ),
                ],
              ),
              CustomErrorWidget(
                isInternetConnection:
                response.message == OFFLINE_FAILURE_MESSAGE,
                text: response.message ?? 'Something went wrong',
                onTap: () {
                  if (carId != null) {
                    context
                        .read<CarsProvider>()
                        .fetchSingleCar(carId.toString());
                  }
                },
              ),
            ],
          ),
        );

      case ApiStatus.COMPLETED:
        final carData = response.data;

        if (carData == null) {
          return Scaffold(
            body: Column(
              children: [
                CustomAppBar(text: 'Details'),
                SizedBox(height: 24.h),
                const CustomNotFound(
                  width: 450,
                  text: 'No Data Available!',
                ),
              ],
            ),
          );
        }

        /// 👇 نفس الكود تبعك بدون أي تغيير
        if (!isImagesLoaded) {
          if (carData.coverImage != null &&
              carData.coverImage!.isNotEmpty) {
            images!.insert(0, carData.coverImage!);
          }
          if (carData.images != null) {
            images!.addAll(carData.images!);
          }
          isImagesLoaded = true;
        }

        _carSpec = [
          CarInfoModel(
            featureTitle: 'Battery',
            icon: 'battery',
            unitOfMeasurement: '%',
            status: carData.battery?.toString() ?? "Unknown",
          ),
          CarInfoModel(
            featureTitle: 'Range',
            icon: 'range',
            unitOfMeasurement: 'Km',
            status: carData.range?.toString() ?? "Unknown",
          ),
          CarInfoModel(
            featureTitle: 'Climate',
            icon: 'climate',
            unitOfMeasurement: '',
            status: carData.climate == true ? 'is ON' : 'is OFF',
          ),
          CarInfoModel(
            featureTitle: 'Speed',
            icon: 'speed',
            unitOfMeasurement: 'km/h',
            status: carData.speed?.toString() ?? "Unknown",
          ),
        ];

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                PictureSlider(
                  images: images,
                  carModel: carData,
                  isOffer: isOfferScreen,
                  totalBuyer: totalBuyer,
                  totalReview: totalReview,
                  review: review,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 12.h, horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyListTile(
                        context: context,
                        title: 'Car Specification',
                        colorTextTitle: kWhite,
                      ),
                      SizedBox(height: 12.sp),
                      _carSpecContainer(carSpec: _carSpec),
                      SizedBox(height: 12.sp),
                      _carInfo(
                        carType: carData.carType ?? "",
                        location: carData.country ?? "",
                        stock: '${carData.quantityInStock}',
                        context: context,
                      ),
                      isOfferScreen
                          ? const SizedBox.shrink()
                          : CommentWidget(carModel: carData),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }


  Column _carInfo({
    required String carType,
    required String location,
    required String stock,
    required BuildContext context,
  }) {
    return Column(
      children: [
        MyListTile(context: context, title: 'Car Information'),
        SizedBox(height: 12.h),
        Container(
          padding:
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: Theme.of(context).hintColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomInfoCar(carInfo: carType, path: 'car'),
              ),
              Expanded(
                child: CustomInfoCar(
                    carInfo: '$stock Left Cars', path: 'stock'),
              ),
              Expanded(
                child: CustomInfoCar(carInfo: location, path: 'Location'),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _carSpecContainer({required List<CarInfoModel> carSpec}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 200 / 120,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return CustomContainer(
          preTileIcon: carSpec[index].icon,
          title: carSpec[index].featureTitle.toString(),
          widget: Padding(
            padding: EdgeInsetsDirectional.only(start: 4.w),
            child: CustomSmallText(
              title: carSpec[index].status.toString(),
              subTitle: carSpec[index].unitOfMeasurement,
            ),
          ),
        );
      },
    );
  }
}
