import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

//models
import '../models/Category/category.dart';

import '../controllers/auth.dart';

class DataController extends GetxController {
  final authProvider = Get.find<AuthController>();
  final List<Category> _categories = [];

  List<Category> get categories {
    return [..._categories];
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
