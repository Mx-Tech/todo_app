import 'package:boringDos/home/pages/detail.dart';
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

  void navigateToDetailPage(BuildContext context, {required int index}){
    /// Now we want to make the navigation to the detail page much
    /// easier, by providing a gesture detector to detect taps. Here we use
    /// [onLongPress] to navigate to the detail page.
    Navigator.of(context).pushNamed(HomeDetailPage.routeName, arguments: {
      "todoList": todoList,
      "index": index
    }).then((item) {
      /// This is the return point after popping the detail page!
      if (item != null && item is TodoItem) {
        // TODO: call provider later and rebuild list if list items change
        todoList
            .replaceRange(index, index + 1, [item]);

        /// This store items function will save our item on popping
        /// the detail route. But we want to achieve saving the item
        /// on change.
        StorageService().storeTodoItems(todoList);
      }
    });
  }
}