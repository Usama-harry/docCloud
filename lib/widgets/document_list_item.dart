import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

//Controllers
import '../controllers/data.dart';
//models
import '../models/Document/document.dart';
//Utils
import '../Utils/utils.dart';

class DocumentListItem extends StatefulWidget {
  final Document document;

  const DocumentListItem({super.key, required this.document});

  @override
  State<DocumentListItem> createState() => _DocumentListItemState();
}

class _DocumentListItemState extends State<DocumentListItem> {
  var isLoading = false;

  final dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ListTile(
              title: Text(
                widget.document.title,
              ),
              subtitle: Text(
                DateFormat.yMMM().format(widget.document.date),
              ),
              trailing: IconButton(
                onPressed: () {
                  showConfirmDialog(
                    context,
                    'Are you sure to delete?',
                    () {
                      //On cancel
                      Get.back();
                    },
                    () {
                      //On done
                      Get.back();
                      switchIsLoading();
                      dataController
                          .deleteDocument(widget.document)
                          .then((deleted) {
                        switchIsLoading();
                        Get.back();
                        Get.snackbar(
                            'Deleted', 'Document is deleted successfully');
                      }).catchError((error) {
                        switchIsLoading();
                        showAlertDialog(context, error.toString());
                      });
                    },
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  size: 18,
                  color: Colors.red,
                ),
              ),
            ),
    );
  }

  void switchIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}
