import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Controller
import '../controllers/data.dart';
//Models
import '../models/Category/category.dart';
//Widgets
import '../widgets/add_edit_new_document.dart';
import '../widgets/document_list_item.dart';

class DocumentsScreen extends StatefulWidget {
  static const routeName = '/documents';

  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final category = Get.arguments as Category;

  final dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                AddEditNewDocument(
                  category: category,
                ),
                fullscreenDialog: true,
              )!
                  .then((added) {
                if (added != null) {
                  setState(() {});
                }
              });
            },
            icon: const Icon(
              Icons.add,
              size: 27,
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: category.documents.length,
        itemBuilder: (context, index) => DocumentListItem(
          document: category.documents[index],
        ),
      ),
    );
  }
}
