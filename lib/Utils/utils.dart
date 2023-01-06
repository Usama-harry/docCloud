import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyColors {
  static final accentColor = ThemeData.dark().colorScheme.secondary;
  static final backGroundColor = ThemeData.dark().scaffoldBackgroundColor;
}

//Styles
const appBarTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
);

const titleTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 25,
);

const descriptionTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.grey,
);

//Functions
@override
extension StringExtension on String {
  String capitalFirstLetter() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

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

void showConfirmDialog(
  BuildContext context,
  String message,
  Function() onCancel,
  Function() onDone,
) {
  showDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text(
        'Confirm',
        textAlign: TextAlign.center,
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onDone,
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(
              Colors.red,
            ),
          ),
          child: const Text('Okay'),
        ),
      ],
    ),
  );
}
