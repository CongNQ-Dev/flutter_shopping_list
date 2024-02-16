import 'package:flutter/material.dart';
import 'package:flutter_shopping_list/data/dummy_items.dart';
import 'package:flutter_shopping_list/data/dummy_items.dart';
import 'package:flutter_shopping_list/models/grocery_item.dart';
import 'package:flutter_shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  void _addItem(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NewItem(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Grocery"),
          actions: [
            IconButton(
                onPressed: () {
                  _addItem(context);
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: ((context, index) => ListTile(
                title: Text(
                  groceryItems[index].name,
                ),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: groceryItems[index].category.color,
                ),
                trailing: Text(groceryItems[index].quantity.toString()),
              )),
        ));
  }
}