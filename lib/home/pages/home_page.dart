import 'package:boringDos/home/pages/detail.dart';
import 'package:boringDos/home/services/home_page_service.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return SafeArea(
                maintainBottomViewPadding: true,
                child: Padding(
                  padding: MediaQuery.of(context)
                      .viewInsets
                      .copyWith(left: 8, right: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: widget.service.todoTitleController,
                        decoration:
                            const InputDecoration(hintText: "Enter your ToDo!"),
                        validator: (value) {
                          /// As we want to prevent our app from displaying emtpy
                          /// items we need some validation!
                          if (value == null || value.isEmpty) {
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
                                .pop(widget.service.todoTitleController.text);
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
                widget.service.todoList.add(TodoItem(value, false));
                StorageService().storeTodoItems(widget.service.todoList);
                widget.service.todoTitleController.clear();
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}