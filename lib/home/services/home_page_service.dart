import 'package:boringDos/home/pages/detail.dart';
import 'package:boringDos/models/todo_item.dart';
import 'package:boringDos/services/storage.dart';
import 'package:flutter/cupertino.dart';

class HomePageService {
  late final List<TodoItem> todoList;
  late final TextEditingController todoTitleController;

  HomePageService() {
    todoList = StorageService().getTodoItems();
    todoTitleController = TextEditingController();
  }

  TodoItem itemAt(int index) {
    return todoList[index];
  }

  void setItem(TodoItem item, {required int index}) {
    todoList[index] = item;
    StorageService().storeTodoItems(todoList);
  }

  TodoItem removeAt(int index) {
    TodoItem item = todoList.removeAt(index);
    StorageService().storeTodoItems(todoList);
    return item;
  }

  Future<bool> update(int index, {required bool? value}) {
    todoList[index].checked = value ?? false;
    return StorageService().storeTodoItems(todoList);
  }

  Future<TodoItem?> navigateToDetailPage(BuildContext context, {required int index}) {
    /// Now we want to make the navigation to the detail page much
    /// easier, by providing a gesture detector to detect taps. Here we use
    /// [onLongPress] to navigate to the detail page.
    return Navigator.of(context).pushNamed(HomeDetailPage.routeName,
        arguments: {"todoList": todoList, "index": index}).then((item) {
      /// This is the return point after popping the detail page!
      if (item != null && item is TodoItem) {
        // TODO: call provider later and rebuild list if list items change
        todoList.replaceRange(index, index + 1, [item]);

        /// This store items function will save our item on popping
        /// the detail route. But we want to achieve saving the item
        /// on change.
        StorageService().storeTodoItems(todoList);
        return item;
      }
    });
  }
}
