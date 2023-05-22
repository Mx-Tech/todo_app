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

    /// Here we load the items from the storage
    todoList = StorageService().getTodoItems();
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
              Navigator.of(context).pushNamed(HomeDetailPage.routeName,
                  arguments: {
                    "todoList": todoList,
                    "index": index
                  }).then((item) {
                /// This is the return point after popping the detail page!
                if (item != null && item is TodoItem) {
                  setState(() {
                    todoList.replaceRange(index, index + 1, [item]);

                    /// This store items function will save our item on popping
                    /// the detail route. But we want to achieve saving the item
                    /// on change.
                    StorageService().storeTodoItems(todoList);
                  });
                }
              });
            },
            child: Dismissible(
              key: ValueKey<int>(index.hashCode ^ todoList[index].hashCode),
              onDismissed: (_) {
                setState(() {
                  todoList.removeAt(index);
                  StorageService().storeTodoItems(todoList);
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
                      TextFormField(
                        focusNode: todoTitleControllerNode,
                        controller: todoTitleController,
                        decoration:
                            const InputDecoration(hintText: "Enter your ToDo!"),
                        validator: (value){
                          /// As we want to prevent our app from displaying emtpy
                          /// items we need some validation!
                          if (value == null || value.isEmpty){
                            return "Please add some information!";
                          }
                          /// If the validator functions returns [null] everything is fine.
                          return null;
                        },
                      ),
                      const Divider(),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(todoTitleController.text);
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
                StorageService().storeTodoItems(todoList);
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
