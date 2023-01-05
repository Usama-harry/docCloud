import 'package:flutter/material.dart';

//models
import '../models/Category/category.dart';
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
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          category.title.capitalize(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
