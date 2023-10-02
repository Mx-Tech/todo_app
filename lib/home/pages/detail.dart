import 'package:boringDos/models/todo_item.dart';
import 'package:boringDos/services/storage.dart';
import 'package:flutter/material.dart';

class HomeDetailPage extends StatefulWidget {
  const HomeDetailPage({Key? key}) : super(key: key);

  static const routeName = '/homeDetailPage';

  @override
  State<HomeDetailPage> createState() => _HomeDetailPageState();
}

class _HomeDetailPageState extends State<HomeDetailPage> {
  late final TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    List<TodoItem> todoList = (ModalRoute.of(context)!.settings.arguments as Map)["todoList"] as List<TodoItem>;
    int index = (ModalRoute.of(context)!.settings.arguments as Map)["index"] as int;
    TodoItem item = todoList[index];
    commentController.text = item.comment;
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop(item);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(item.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                value: item.checked,
                title: const Text("Status"),
                onChanged: (value) {
                  setState(
                    () {
                      item.checked = value ?? false;
                      StorageService().storeTodoItems(todoList);
                    },
                  );
                },
              ),
              const Text("Comment:"),
              TextField(
                controller: commentController,
                onChanged: (value) {
                  item.comment = value;
                  StorageService().storeTodoItems(todoList);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
