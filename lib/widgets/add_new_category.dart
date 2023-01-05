import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Controllers
import '../controllers/data.dart';
//Widgets
import 'my_text_field.dart';
//Utils
import '../Utils/utils.dart';

class AddNewCategory extends StatefulWidget {
  static const routeName = '/addNewCategory';
  const AddNewCategory({super.key});

  @override
  State<AddNewCategory> createState() => _AddNewCategoryState();
}

class _AddNewCategoryState extends State<AddNewCategory> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;

  final dataController = Get.find<DataController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
        centerTitle: true,
        actions: [
          isLoading
              ? const Padding(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator.adaptive(),
                )
              : TextButton(
                  onPressed: validate,
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter name',
                style: titleTextStyle,
              ),
              const SizedBox(height: 10),
              const Text(
                'Please provide the name of new category',
                style: descriptionTextStyle,
              ),
              const SizedBox(height: 30),
              MyTextField(
                label: 'Category name',
                controller: _titleController,
                isRequired: true,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void switchLoadingState() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void validate() {
    if (_formKey.currentState!.validate()) {
      switchLoadingState();
      dataController.addCategory(_titleController.text).then((added) {
        switchLoadingState();
        Get.back();
        Get.snackbar(
          'Successfully added',
          'Your new category was successfully added',
          backgroundColor: MyColors.backGroundColor,
        );
      }).catchError((error) {
        switchLoadingState();
        showAlertDialog(context, error.toString(), isError: true);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
