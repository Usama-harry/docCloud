import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

//Models
import '../models/Document/document.dart';
import '../models/Category/category.dart';
//Controllers
import '../controllers/data.dart';
//Widgets
import 'my_text_field.dart';
//Utils
import '../Utils/utils.dart';

class AddEditNewDocument extends StatefulWidget {
  static const routeName = '/addNewCategory';

  final Category category;
  const AddEditNewDocument({
    super.key,
    required this.category,
  });

  @override
  State<AddEditNewDocument> createState() => _AddEditNewDocumentState();
}

class _AddEditNewDocumentState extends State<AddEditNewDocument> {
  PlatformFile? pickedFile;
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;

  final dataController = Get.find<DataController>();

  final document = Get.arguments as Document?; //Edit mode if not NULL
  var isEditMode = false;
  var isFirstTime = true;

  @override
  Widget build(BuildContext context) {
    //Edit mode
    if (document != null && isFirstTime) {
      _titleController.text = document!.title;
      isEditMode = true;
      isFirstTime = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Document' : 'Add Document'),
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
                'Enter details',
                style: titleTextStyle,
              ),
              const SizedBox(height: 10),
              Text(
                isEditMode
                    ? 'Please provide the new details'
                    : 'Please provide details of the document',
                style: descriptionTextStyle,
              ),
              const SizedBox(height: 30),
              MyTextField(
                label: 'Document name',
                controller: _titleController,
                isRequired: true,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'jpeg', 'doc', 'pdf', 'png'],
                      );

                      if (result == null) return; //No file picked

                      setState(() {
                        pickedFile = result.files.first;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey,
                      ),
                    ),
                    child: const Text(
                      'Upload file',
                    ),
                  ),
                  Text(
                    pickedFile != null ? pickedFile!.name : 'No file selected',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  )
                ],
              )
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
      if (pickedFile != null) {
        switchLoadingState();
        //File is picked
        if (!isEditMode) {
          // Add mode
          dataController
              .addDocument(
            _titleController.text,
            widget.category,
            pickedFile!,
          )
              .then((added) {
            switchLoadingState();
            Get.back(result: true);
            Get.snackbar(
              'Document added',
              'Document was added successfully',
              backgroundColor: MyColors.backGroundColor,
            );
          }).catchError((error) {
            switchLoadingState();
            showAlertDialog(context, error.toString());
          });
        } else // Edit mode
        {}
      } else {
        Get.snackbar(
          'Pick file',
          'Please select a file to upload',
          backgroundColor: MyColors.backGroundColor,
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
