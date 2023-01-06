import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Models
import '../models/Category/category.dart';
//Controllers
import '../controllers/data.dart';
//Widgets
import 'my_text_field.dart';
//Utils
import '../Utils/utils.dart';

class AddEditNewCategory extends StatefulWidget {
  static const routeName = '/addNewCategory';
  const AddEditNewCategory({super.key});

  @override
  State<AddEditNewCategory> createState() => _AddEditNewCategoryState();
}

class _AddEditNewCategoryState extends State<AddEditNewCategory> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;

  final dataController = Get.find<DataController>();

  final category = Get.arguments as Category?; //Edit mode if not NULL
  var isEditMode = false;

  @override
  Widget build(BuildContext context) {
    //Edit mode
    if (category != null) {
      _titleController.text = category!.title;
      isEditMode = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Category' : 'Add Category'),
        centerTitle: true,
        actions: [
          isLoading
              ? const Padding(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator.adaptive(),
                )
              : TextButton(
                  onPressed: () => validate(isEditMode),
                  child: Text(
                    isEditMode ? 'Save' : 'Add',
                    style: const TextStyle(
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
              Text(
                isEditMode
                    ? 'Please provide the new name for ${category!.title.toLowerCase()} category'
                    : 'Please provide the name of new category',
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

  void validate(bool isEditMode) {
    if (_formKey.currentState!.validate()) {
      if (!isEditMode) {
        // Add mode
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
      } else // Edit mode
      {
        switchLoadingState();
        dataController
            .changeCategoryName(_titleController.text, category!)
            .then((added) {
          switchLoadingState();
          Get.back();
          Get.snackbar(
            'Successfully changed',
            '${category!.title} is successfully changed to ${_titleController.text}',
            backgroundColor: MyColors.backGroundColor,
          );
        }).catchError((error) {
          switchLoadingState();
          showAlertDialog(context, error.toString(), isError: true);
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
