import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyColors {
  static final accentColor = ThemeData.dark().colorScheme.secondary;
  static final backGroundColor = ThemeData.dark().scaffoldBackgroundColor;
}

//Functions

void showNewSnackBar(String title, String message, {Icon? icon}) {
  Get.closeAllSnackbars();
  Get.snackbar(
    title,
    message,
    icon: icon,
  );
}

void showAlertDialog(BuildContext context, String message, {isError = true}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      iconPadding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.all(0),
      title: Container(
        width: double.infinity,
        height: 40,
        color: isError ? Colors.red : Colors.green,
        child: Icon(
          isError ? Icons.close : Icons.check,
        ),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      actions: [
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.grey,
              ),
            ),
            child: const Text('Okay'),
          ),
        )
      ],
    ),
  );
}
