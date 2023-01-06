import 'package:documents/controllers/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Screens
import '../views/documents_screen.dart';
//models
import '../models/Category/category.dart';
//Widgets
import '../widgets/add_edit_new_category.dart';
//Utils
import '../Utils/utils.dart';

class CategoryGridItem extends StatefulWidget {
  final Category category;
  const CategoryGridItem({
    super.key,
    required this.category,
  });

  @override
  State<CategoryGridItem> createState() => _CategoryGridItemState();
}

class _CategoryGridItemState extends State<CategoryGridItem> {
  var isLoading = false;

  final dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(
        DocumentsScreen.routeName,
        arguments: widget.category,
      ),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          widget.category.title.capitalFirstLetter(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.to(
                                    const AddEditNewCategory(),
                                    fullscreenDialog: true,
                                    arguments: widget.category,
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: 17,
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showConfirmDialog(
                                    context,
                                    'Are you sure to delete ${widget.category.title}?',
                                    () => Get.back(),
                                    () {
                                      Get.back();
                                      switchLoadingState();
                                      dataController
                                          .deleteCategory(widget.category)
                                          .then((deleted) {
                                        Get.snackbar(
                                          'Successfully deleted',
                                          'Your category was successfully deleted',
                                          backgroundColor:
                                              MyColors.backGroundColor,
                                        );
                                      }).catchError((error) {
                                        switchLoadingState();
                                        Get.back();
                                        showAlertDialog(
                                          context,
                                          error.toString(),
                                          isError: true,
                                        );
                                      });
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 17,
                                ),
                              ),
                            ],
                          )),
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
}
