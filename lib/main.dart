import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: InventoryScreen(),
    );
  }
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Item> items = [];

  void _addItem(String name) {
    setState(() {
      items.add(Item(name: name, count: 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Tracker'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 横に2列表示
          crossAxisSpacing: 10, // カード間のスペース(横)
          mainAxisSpacing: 10, // カード間のスペース(縦)
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return InventoryCard(
            item: items[index],
            onAdd: () {
              setState(() {
                items[index].count++;
              });
            },
            onRemove: () {
              setState(() {
                if (items[index].count > 0) {
                  items[index].count--;
                }
              });
            },
          );
        },
      ),
      // ListView.builder(
      //   itemCount: items.length,
      //   itemBuilder: (context, index) {
      //     return InventoryCard(
      //       item: items[index],
      //       onAdd: () {
      //         setState(() {
      //           items[index].count++;
      //         });
      //       },
      //       onRemove: () {
      //         setState(() {
      //           if (items[index].count > 0) {
      //             items[index].count--;
      //           }
      //         });
      //       },
      //     );
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('新しい項目を追加'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: '項目名を入力'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _addItem(controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('追加'),
            ),
          ],
        );
      },
    );
  }
}

class Item {
  String name;
  int count;

  Item({required this.name, required this.count});
}

class InventoryCard extends StatelessWidget {
  final Item item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const InventoryCard(
      {super.key,
      required this.item,
      required this.onAdd,
      required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontSize: 18),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: onRemove,
                    ),
                    Text('${item.count}', style: const TextStyle(fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: onAdd,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
