import 'package:carmarketapp/core/helpers/routers/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helpers/api_helpers/api_response.dart';
import '../../core/utils/snckbar.dart';
import '../../providers/Dealer/cars_provider/cars_provider.dart';
import 'loading_widget.dart';

class DeleteDialogWidget extends StatefulWidget {
  final int id;

  const DeleteDialogWidget({super.key, required this.id});

  @override
  State<DeleteDialogWidget> createState() => _DeleteDialogWidgetState();
}

class _DeleteDialogWidgetState extends State<DeleteDialogWidget>
    with ShowSnackBar {
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).hintColor,
      title: const Text('Are You Sure?',style: TextStyle(color: Colors.white),),
      content: isDeleting
          ? const SizedBox(height: 40, width: 40, child: LoadingWidget())
          : const SizedBox(),
      actions: [
        if (!isDeleting)
          TextButton(
              onPressed: () {
                _deletePost(context, postId: widget.id);
              },
              child:  Text('Yes',style: TextStyle(color: Theme.of(context).primaryColor),)),
        if (!isDeleting)
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:  Text('No',style: TextStyle(color: Theme.of(context).primaryColor)),)
      ],
    );
  }

  Future<LoadingWidget> _deletePost(BuildContext context,
      {required int postId}) async {
    setState(() {
      isDeleting = true;
    });
    final postProvider = Provider.of<CarsProvider>(context, listen: false);
    await postProvider.deleteSingleCar(carId: widget.id.toString());

    if (postProvider.deleteCar.status == ApiStatus.COMPLETED) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
          showSnackBar(context, message: 'Offer Deleted Successfully!'));
      if (context.mounted) {
        NavigationRoutes().pop(context);
      }
      setState(() {
        isDeleting = false;
      });
    }
    if (postProvider.deleteCar.status == ApiStatus.ERROR) {
      print('llllllllllllllllllll');
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => showSnackBar(
          context,
          message: postProvider.deleteCar.message.toString(),
          error: true));
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
    return const LoadingWidget();
  }
}
