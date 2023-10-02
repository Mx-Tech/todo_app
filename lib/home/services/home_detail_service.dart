import 'package:boringDos/models/todo_item.dart';
import 'package:boringDos/services/storage.dart';
import 'package:flutter/material.dart';

class HomeDetailService {
  late final TextEditingController _commentController;
  late final List<TodoItem> _todoList;
  late final int _index;
  bool _isInitialized = false;

  HomeDetailService() {
    _commentController = TextEditingController();
  }

  void init(BuildContext context) {
    if (_isInitialized){
      return;
    }
    _todoList = (ModalRoute.of(context)!.settings.arguments as Map)["todoList"]
    as List<TodoItem>;
    _index =
    (ModalRoute.of(context)!.settings.arguments as Map)["index"] as int;
    TodoItem item = _todoList[_index];
    _commentController.text = item.comment;
    _isInitialized = true;
  }

  void _checkInitialization(){
    assert(_isInitialized, "Service was not initialized! Call the init function before referencing any variable in here!");
  }

  TextEditingController get commentController {
    _checkInitialization();
    return _commentController;
  }

  List<TodoItem> get todoList {
    _checkInitialization();
    return _todoList;
  }

  TodoItem get item{
    _checkInitialization();
    return _todoList[_index];
  }

  set item(TodoItem item){
    _todoList[_index] = item;
    StorageService().storeTodoItems(todoList);
  }

}
