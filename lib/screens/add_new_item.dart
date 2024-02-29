import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/item_controller.dart';
import '../data/categories.dart';
import '../model/category.dart';

class NewItem extends StatelessWidget {
  const NewItem({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ItemController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(label: Text('Name')),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length == 1 ||
                        value.trim().length >= 50) {
                      return 'Must not be null and characters 50';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    controller.enteredName = value!;
                  },
                ),
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must not be null and characters 50';
                        }
                        return null;
                      },
                      initialValue: '0',
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      onSaved: (value) {
                        controller.enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                        value: controller.selectedCategory,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      color: category.value.color,
                                      width: 16,
                                      height: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(category.value.title)
                                  ],
                                ))
                        ],
                        onChanged: (value) {
                          controller.selectedCategory = value as Category;
                        }),
                  )
                ]),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        controller.formKey.currentState!.reset();
                      },
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          controller.saveForm();
                        },
                        child: const Text('Save'))
                  ],
                )
              ],
            )),
      ),
    );
  }
}
