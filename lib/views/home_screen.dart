import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Controllers
import '../controllers/data.dart';
//Utils
import '../Utils/utils.dart';
//Widgets
import '../widgets/category_grid_item.dart';
import '../widgets/my_drawer.dart';
import '../widgets/add_new_category.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  HomeScreen({super.key});

  final dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doc Cloud',
          style: appBarTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                const AddNewCategory(),
                fullscreenDialog: true,
              );
            },
            icon: const Icon(
              Icons.add,
              size: 27,
            ),
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: GetBuilder<DataController>(
        builder: (controller) => GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) => CategoryGridItem(
            category: controller.categories[index],
          ),
        ),
      ),
    );
  }
}
