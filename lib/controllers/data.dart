import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

//models
import '../models/Category/category.dart';
import '../models/Document/document.dart';

import '../controllers/auth.dart';

class DataController extends GetxController {
  final authProvider = Get.find<AuthController>();
  List<Category> _categories = [];

  List<Category> get categories {
    return List.from(_categories);
  }

  Future<bool> addCategory(String title) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authProvider.user!.uid)
          .collection('categories')
          .add({
        "title": title,
        "documents": [],
      });

      return true;
    } catch (error) {
      throw 'An error occured';
    }
  }

  Future<bool> loadCategories() async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(authProvider.user!.uid)
        .collection('categories')
        .get()
        .then((data) {
      _categories.clear();
      for (var category in data.docs) {
        _categories
            .add(Category.frsomJson({"id": category.id, ...category.data()}));
      }
      update();
      dataListener();
      return true;
    }).catchError((error) {
      return false;
    });
  }

  Future<bool> changeCategoryName(String newName, Category category) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(authProvider.user!.uid)
        .collection('categories')
        .doc(category.id)
        .update({
      'title': newName,
    }).then((_) {
      return true;
    }).catchError((error) {
      throw 'An error occured';
    });
  }

  Future<bool> deleteCategory(Category category) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(authProvider.user!.uid)
        .collection('categories')
        .doc(category.id)
        .delete()
        .then((_) {
      return true;
    }).catchError((error) {
      throw 'An error occured';
    });
  }

  Future<bool> addDocument(
    String documentName,
    Category category,
    PlatformFile pickedFile,
  ) async {
    try {
      UploadTask? uploadTask;
      final file = File(pickedFile.path!);
      final path = '${authProvider.user!.uid}/documents/$documentName';

      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();

      final uuid = const Uuid().v4();
      final document = Document(
        id: uuid,
        catId: category.id,
        title: documentName,
        url: url,
        date: DateTime.now(),
      );

      category.documents.add(document);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authProvider.user!.uid)
          .collection('categories')
          .doc(category.id)
          .update({
        'documents': category.documents.map((e) => e.toJson()).toList()
      });

      return true;
    } catch (error) {
      throw 'An error occured';
    }
  }

  Future<bool> deleteDocument(Document document) async {
    final index = _categories.indexWhere(
      (element) => element.id == document.catId,
    ); //category index

    Document? docRef;
    try {
      //Deleting in app data
      for (var doc in _categories[index].documents) {
        if (document.id == doc.id) {
          docRef = doc;
          _categories[index].documents.remove(doc);
          break;
        }
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authProvider.user!.uid)
          .collection('categories')
          .doc(document.catId)
          .update({
        'documents':
            _categories[index].documents.map((e) => e.toJson()).toList(),
      });

      final ref = FirebaseStorage.instance
          .ref()
          .child('${authProvider.user!.uid}/documents/${document.title}');
      await ref.delete();
      update();
      return true;
    } catch (error) {
      _categories[index].documents.insert(index, docRef!);
      throw 'An error occured';
    }
  }

  void dataListener() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(authProvider.user!.uid)
        .collection('categories')
        .snapshots()
        .listen((data) {
      _categories.clear();
      for (var category in data.docs) {
        _categories
            .add(Category.frsomJson({"id": category.id, ...category.data()}));
      }
      update();
    });
  }
}
