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
  var enteredName = '';
  int enteredQuantity = 0;
  Category selectedCategory = categories[Categories.vegetables] as Category;
  @override
  void onInit() {
    super.onInit();
    loadingItem();
  }

  void saveForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final url = Uri.https('shopping-list-78996-default-rtdb.firebaseio.com',
          'Shopping-List.json');
      final resposne = await http.post(url,
          headers: {
            'content-type': 'application/json',
          },
          body: json.encode({
            'name': enteredName,
            'quantity': enteredQuantity,
            'category': selectedCategory.title,
          }));
      loadingItem();
    }
  }

  void loadingItem() async {
    final url = Uri.https('shopping-list-78996-default-rtdb.firebaseio.com',
        'Shopping-List.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    List<GroceryItem> loadItems = [];
    for (final item in listData.entries) {
      final category = categories.entries.firstWhere(
          (catItem) => catItem.value.title == item.value['category']);
      groceryList.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category.value));
    }

    groceryList.addAll(loadItems);
  }

  void removeItem(GroceryItem item) {
    groceryList.remove(item).obs;
  }

  void addNewItem(BuildContext context) async {
    await Get.to(() => const NewItem());
  }
}
