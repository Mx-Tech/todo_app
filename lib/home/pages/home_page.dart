import 'package:boringDos/home/services/home_page_service.dart';
import 'package:boringDos/home/widgets/home_fab.dart';
import 'package:boringDos/home/widgets/item.dart';
import 'package:boringDos/models/todo_item.dart';
import 'package:boringDos/services/storage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final HomePageService service;

  const HomePage(this.service, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// The [Dismissible] widget is used to delete an item through swiping.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("ToDo It!"),
      ),
      body: ListView.builder(
        itemCount: widget.service.todoList.length,
        itemBuilder: (context, index) {
          return TodoItemWidget(widget.service, index: index);
        },
      ),
      floatingActionButton: HomePageFloatingActionButton(
        widget.service,
        update: (String? label) {
          if (label == null) {
            return;
          }
          setState(() {
            widget.service.todoList.add(TodoItem(label, false));
            StorageService().storeTodoItems(widget.service.todoList);
            widget.service.todoTitleController.clear();
          });
        },
      ),
    );
  }
}
