import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

//Screens
import '../views/documents_screen.dart';
//models
import '../models/Category/category.dart';
//Widgets
import '../widgets/add_edit_new_category.dart';
//utils
import '../Utils/utils.dart';

class CategoryGridItem extends StatelessWidget {
  final Category category;
  const CategoryGridItem({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(
        DocumentsScreen.routeName,
        arguments: category,
      ),
      child: Card(
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
                    category.title.capitalize(),
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
                              arguments: category,
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: MyColors.backGroundColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete,
                            color: MyColors.backGroundColor,
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
}
