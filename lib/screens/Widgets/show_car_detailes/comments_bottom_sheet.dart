import 'package:carmarketapp/core/utils/constants.dart';
import 'package:carmarketapp/core/utils/image_helper.dart';
import 'package:carmarketapp/models/api/reviews/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../custom_image.dart';
import '../rate_section/rate_section.dart';

class CommentsBottomSheet extends StatelessWidget with ImageHelper {
  final List<ReviewModel> reviewModel;
  const CommentsBottomSheet({super.key, required this.reviewModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.only(bottom: 16.0.h),
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.only( top: 40.0.h,bottom: 16.h,left: 24.w,right: 24.w),
              child: Center(child: Text('People said', style: Theme.of(context).textTheme.bodyMedium)),
            ),
            ///Comments

            ListView.separated(
              itemCount: reviewModel.length,

              shrinkWrap: true,
              separatorBuilder: (context, index) =>  Divider(thickness: 0.5, height: 30,indent: 55,color: Colors.white.withOpacity(0.5),),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appSvgImage(path: 'comment',color: Colors.black)
                          // const CircleAvatar(
                          //   radius: 20,
                          //   backgroundImage: NetworkImage(
                          //     'https://upload.wikimedia.org/wikipedia/commons/1/1a/Lamborghini_Veneno,_Car_Zero_(profile).jpg',
                          //   ),

                          ,const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(reviewModel[index].buyer?.username.toString() ??'', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(
                                  reviewModel[index].desc ??'',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300,fontSize: 10.sp),
                                ),
                                SizedBox(height: 12.h,),

                                RateSection( rate:  reviewModel[index].star?.toInt() ??4, color: kBlackColor,
                               )
                              ],
                            ),
                          )
                         ] ),

                        ],


                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
