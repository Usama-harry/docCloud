import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

//Utils
import '../Utils/utils.dart';

class MyTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isObsecure;
  final bool isNumbersField;
  final bool isRequired;

  const MyTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.isObsecure = false,
    this.isNumbersField = false,
    this.isRequired = false,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  RxBool? obsecureText;
  var isFirstTime = true;

  @override
  Widget build(BuildContext context) {
    if (isFirstTime) {
      obsecureText = widget.isObsecure.obs;
      isFirstTime = false;
    }
    return Obx(
      () => TextFormField(
        controller: widget.controller,
        validator: widget.validator ??
            (value) {
              if (widget.isRequired) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
              }

              return null;
            },
        cursorColor: MyColors.accentColor,
        obscureText: obsecureText!.value,
        inputFormatters: widget.isNumbersField
            ? [FilteringTextInputFormatter.digitsOnly]
            : [],
        decoration: InputDecoration(
          hintText: widget.label,
          suffixIcon: widget.isObsecure
              ? IconButton(
                  onPressed: () => obsecureText!.value = !obsecureText!.value,
                  icon: Icon(
                    obsecureText!.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                )
              : null,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: MyColors.accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
