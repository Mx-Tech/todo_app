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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo It!"),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(todoList[index].title),
            value: todoList[index].checked,
            onChanged: (bool? value) {
              setState(() {
                todoList[index].checked = value ?? false;
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
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
                          icon: Icon(Icons.check, color: Theme.of(context).primaryColor,),
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

class TodoItem {
  final String title;
  bool checked;

  TodoItem(this.title, this.checked);
}
