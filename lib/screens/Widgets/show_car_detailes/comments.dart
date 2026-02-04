import 'package:carmarketapp/core/utils/show_bottom_sheet.dart';
import 'package:carmarketapp/models/api/cars/car_api_model.dart';
import 'package:carmarketapp/screens/Widgets/custom_container.dart';
import 'package:carmarketapp/screens/Widgets/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/api/reviews/review_model.dart';
import '../rate_section/custom_rate_row.dart';
import 'comments_bottom_sheet.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({super.key, required this.carModel, this.isOfferDetails=true});
  final CarApiModel carModel;
  final bool? isOfferDetails;
  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> with MyShowBottomSheet{
  @override
  Widget build(BuildContext context) {
    final List<ReviewModel>? carReview=widget.carModel.reviews;
    int displayedComments=carReview!.length > 2 ?2 :carReview.length;
    return carReview.isNotEmpty ?

    Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            MyListTile(
              context: context,
              title: 'Comments',
              trailing: 'See More',
              suffixIcon: 'arrow',
              trailingAction: () => showComments(context, carReviewList: widget.carModel.reviews!),
            ),
            SizedBox(
              height: 12.h,
            ),
            ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () =>showComments(context,carReviewList:widget.carModel.reviews!) ,
                    child: CustomContainer(
                      height: null,
                      title: carReview[index].buyer?.username ?? '',
                      preTileIcon:'comment',
                      trailing:  CustomRateRow(
                          evalutedStars: carReview[index].star!.toInt(),
                          isComment: true,
                                                  ),
                      iconWidth: 30,
                      iconHeight: 30,
                      widget: Text(
                        carReview[index].desc.toString(),
                        style: TextStyle(
                            fontSize: 10.sp, fontWeight: FontWeight.w300),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  height: 12.h,
                ),
                itemCount: displayedComments)
          ],
        ),
      ),
    ):SizedBox.shrink();
  }

  void showComments(BuildContext context, {required List<ReviewModel> carReviewList}) {
    showSheet(context,  CommentsBottomSheet(reviewModel: carReviewList ,),
        color: Theme.of(context).primaryColor, height: 700);
  }
}
