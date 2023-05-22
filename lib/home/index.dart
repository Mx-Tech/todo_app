import 'package:app/home/detail.dart';
import 'package:app/models/todo_item.dart';
import 'package:app/services/storage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<TodoItem> todoList;
  late TextEditingController todoTitleController;

  @override
  void initState() {
    super.initState();
    todoList = [];
    todoTitleController = TextEditingController();
  }

  /// The [Dismissible] widget is used to delete an item through swiping.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo It!"),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              /// Now we want to make the navigation to the detail page much
              /// easier, by providing a gesture detector to detect taps, so we
              /// can navigate to the detail page with a long tap.
              Navigator.of(context)
                  .pushNamed(HomeDetailPage.routeName,
                      arguments: todoList[index])
                  .then((item) {
                /// This is the return point after popping the detail page!
                if (item != null && item is TodoItem) {
                  setState(() {
                    todoList.replaceRange(index, index + 1, [item]);
                  });
                }
              });
            },
            child: Dismissible(
              key: ValueKey<int>(index),
              onDismissed: (_) {
                setState(() {
                  todoList.removeAt(index);
                });
              },
              child: CheckboxListTile(
                title: Text(
                  todoList[index].title,
                  style: todoList[index].checked
                      ? const TextStyle(decoration: TextDecoration.lineThrough)
                      : null,
                ),
                value: todoList[index].checked,
                onChanged: (bool? value) {
                  setState(() {
                    todoList[index].checked = value ?? false;
                    // now we can store our data!
                    StorageService().storeTodoItems(todoList);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              /// Those two lines simply request the focus for the instantiated
              /// focus node. This is necessary to automatically pre-select the TextField
              /// where the focus node [todoTitleControllerNode] is used.
              FocusNode todoTitleControllerNode = FocusNode();
              todoTitleControllerNode.requestFocus();
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        focusNode: todoTitleControllerNode,
                        controller: todoTitleController,
                        decoration:
                            const InputDecoration(hintText: "Enter your ToDo!"),
                      ),
                      const Divider(),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop(todoTitleController.text);
                          },
                          icon: const Icon(Icons.check),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).then((value) {
            if (value != null) {
              setState(() {
                todoList.add(TodoItem(value, false));
                todoTitleController.clear();
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
