import 'package:flutter/material.dart';
import 'package:flutter_shopping_list/data/categories.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_shopping_list/models/grocery_item.dart';
import 'package:flutter_shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _errorMessage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-prep-47c99-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list.json');

    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          _errorMessage = 'Failed to fetching data. Try again later';
        });
      }
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);

      final List<GroceryItem> loadedItemList = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere((categoryItem) =>
                categoryItem.value.title == item.value['category'])
            .value;
        loadedItemList.add(GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category));
      }
      setState(() {
        _groceryItems = loadedItemList;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong. Try again later';
      });
    }
    final response = await http.get(url);
    if (response.statusCode >= 400) {
      setState(() {
        _errorMessage = 'Failed to fetching data. Try again later';
      });
    }
    if (response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final Map<String, dynamic> listData = json.decode(response.body);

    final List<GroceryItem> loadedItemList = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere((categoryItem) =>
              categoryItem.value.title == item.value['category'])
          .value;
      loadedItemList.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }
    setState(() {
      _groceryItems = loadedItemList;
    });
  }

  void _addItem(BuildContext context) async {
    final newItem =
        await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(
      builder: (context) => const NewItem(),
    ));

    // if (newItem == null) {
    //   return;
    // }
    // setState(() {
    //   _groceryItems.add(newItem);
    // });
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
      _isLoading = false;
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    final url = Uri.https(
        'flutter-prep-47c99-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list/${item.id}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      //optionnal: show error message
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No items added yet'),
    );
    if (_isLoading == true) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: ((context, index) => Dismissible(
              onDismissed: (direction) {
                _removeItem(_groceryItems[index]);
              },
              key: ValueKey(_groceryItems[index].id),
              child: ListTile(
                title: Text(
                  _groceryItems[index].name,
                ),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: _groceryItems[index].category.color,
                ),
                trailing: Text(_groceryItems[index].quantity.toString()),
              ),
            )),
      );
    }
    if (_errorMessage != null) {
      content = Center(
        child: Text(_errorMessage!),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Grocery"),
        actions: [
          IconButton(
              onPressed: () {
                _addItem(context);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: content,
    );
  }
}
