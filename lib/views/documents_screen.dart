import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Models
import '../models/Category/category.dart';

class DocumentsScreen extends StatelessWidget {
  static const routeName = '/documents';

  DocumentsScreen({super.key});

  final category = Get.arguments as Category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
      ),
      body: null,
    );
  }
}
