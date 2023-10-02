import 'package:boringDos/models/todo_item.dart';
import 'package:boringDos/services/storage.dart';
import 'package:flutter/cupertino.dart';

class HomePageService{
  late final List<TodoItem> todoList;
  late final TextEditingController todoTitleController;

  HomePageService(){
    todoList = StorageService().getTodoItems();
    todoTitleController = TextEditingController();
  }
}