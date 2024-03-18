import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/item_controller.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  // @override
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ItemController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: () {
              controller.addNewItem(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Obx(
        () => controller.groceryList.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.white,
              ))
            : ListView.builder(
                itemCount: controller.groceryList.length,
                itemBuilder: (ctx, index) {
                  // final groceryItem = controller.groceryList[index];
                  return Dismissible(
                    key: ValueKey(controller.groceryList[index].id),
                    onDismissed: (direction) {
                      controller.removeItem(controller.groceryList[index]);
                    },
                    child: ListTile(
                      title: Text(controller.groceryList[index].name),
                      leading: Container(
                        width: 24,
                        height: 24,
                        color: controller.groceryList[index].category.color,
                      ),
                      trailing: Text(
                        controller.groceryList[index].quantity.toString(),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
