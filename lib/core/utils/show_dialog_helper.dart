import 'package:flutter/material.dart';

import '../../screens/Widgets/custom_button.dart';
import '../helpers/routers/router.dart';
import 'constants.dart';

mixin MyShowDialog{
  void showWarningDialog(BuildContext context, {required String text}){
    showDialog(context: context, builder: (context) {
      return AlertDialog(   backgroundColor: Theme.of(context).hintColor,
        title: const Text(
        '⚠️ Warning',
        textAlign: TextAlign.center,
        style: TextStyle(color: kWhite, fontSize: 18),
      ),
        content:  Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: kWhite,
          ),
        ),
        actions: [
        CustomButton(
        title: 'OK',
        onTap: () => NavigationRoutes().pop(context),
      ),])
      ;
    },);
  }
}