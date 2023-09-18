import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryNotifier with ChangeNotifier {
  List<Category> categoryList = [];

  // adding category
  addCategory(Category category) {
    categoryList.add(category);
    notifyListeners();
  }

  // loading category from the database into provider
  CategoryNotifier.all(List<Category> categories) {
    categoryList = categories;
    notifyListeners();
  }

  // delete category
  deleteCategory(Category category) {
    categoryList.remove(category);
    notifyListeners();
  }
}
