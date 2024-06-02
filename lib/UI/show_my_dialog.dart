import 'package:flutter/material.dart';
import 'package:namer_app/UI/custom_dialog.dart';

void showMyDialog(BuildContext context, String title, String message, List<ButtonData> buttons) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        title: title,
        message: message,
        buttons: buttons,
      );
    },
  );
}
