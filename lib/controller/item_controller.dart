import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/categories.dart';
import '../model/category.dart';
import '../model/grocery_item.dart';
import '../screens/add_new_item.dart';
import 'package:http/http.dart' as http;

class ItemController extends GetxController {
  List<GroceryItem> groceryList = <GroceryItem>[].obs;

  final formKey = GlobalKey<FormState>();
  bool isAdding = false;
  var enteredName = '';
  int enteredQuantity = 0;
  Category selectedCategory = categories[Categories.vegetables] as Category;

  @override
  void onInit() {
    super.onInit();
    loadingItem(); // Load data when the screen initializes
  }

  void saveForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final url = Uri.https('shopping-list-78996-default-rtdb.firebaseio.com',
          'Shopping-List.json');
      final response = await http.post(url,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({
            'name': enteredName,
            'quantity': enteredQuantity,
            'category': selectedCategory.title,
          }));

      // Add the new item to the local list directly instead of fetching all items again
      groceryList.add(GroceryItem(
          id: json.decode(response.body)['name'],
          name: enteredName,
          quantity: enteredQuantity,
          category: selectedCategory));
      // isAdding = true;
      Get.back();
    }
  }

  void loadingItem() async {
    final url = Uri.https('shopping-list-78996-default-rtdb.firebaseio.com',
        'Shopping-List.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);

    // Clear the existing list before adding new items
    groceryList.clear();

    listData.forEach((key, value) {
      final category = categories.entries
          .firstWhere((catItem) => catItem.value.title == value['category']);
      groceryList.add(GroceryItem(
          id: key,
          name: value['name'],
          quantity: value['quantity'],
          category: category.value));
    });
  }

  void removeItem(GroceryItem item) async {
    final url = Uri.https('shopping-list-78996-default-rtdb.firebaseio.com',
        'Shopping-List/${item.id}.json');
    final response = await http.delete(url);

    // Remove the item from the local list directly
    groceryList.removeWhere((element) => element.id == item.id);
  }

  void addNewItem(BuildContext context) async {
    await Get.to(() => const NewItem());
  }
}
