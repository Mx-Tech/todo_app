import 'package:boringDos/home/pages/detail.dart';
import 'package:boringDos/home/services/home_page_service.dart';
import 'package:boringDos/models/todo_item.dart';
import 'package:boringDos/services/storage.dart';
import 'package:boringDos/utils/constants.dart';
import 'package:flutter/material.dart';

class TodoItemWidget extends StatefulWidget {
  final HomePageService service;
  final int index;

  const TodoItemWidget(
    this.service, {
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  State<TodoItemWidget> createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends State<TodoItemWidget> {
  late final ValueNotifier<bool> stateChange;

  @override
  void initState() {
    super.initState();
    stateChange = ValueNotifier(widget.service.todoList[widget.index].checked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        /// Now we want to make the navigation to the detail page much
        /// easier, by providing a gesture detector to detect taps. Here we use
        /// [onLongPress] to navigate to the detail page.
        Navigator.of(context).pushNamed(HomeDetailPage.routeName, arguments: {
          "todoList": widget.service.todoList,
          "index": widget.index
        }).then((item) {
          /// This is the return point after popping the detail page!
          if (item != null && item is TodoItem) {
            // TODO: call provider later and rebuild list if list items change
            widget.service.todoList
                .replaceRange(widget.index, widget.index + 1, [item]);

            /// This store items function will save our item on popping
            /// the detail route. But we want to achieve saving the item
            /// on change.
            StorageService().storeTodoItems(widget.service.todoList);
          }
        });
      },
      child: Dismissible(
        key: ValueKey<int>(widget.index.hashCode ^
            widget.service.todoList[widget.index].hashCode),
        onDismissed: (_) {
          // TODO: call provider later and rebuild list if list items change
          widget.service.todoList.removeAt(widget.index);
          StorageService().storeTodoItems(widget.service.todoList);
        },
        background: Container(
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ]
                .map((child) => Padding(
                      padding: EdgeInsets.all(Paddings.doubled),
                      child: child,
                    ))
                .toList(),
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: stateChange,
          builder: (BuildContext context, bool value, Widget? child) {
            return CheckboxListTile(
              title: Text(
                widget.service.todoList[widget.index].title,
                style: widget.service.todoList[widget.index].checked
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
              value: stateChange.value,
              onChanged: (bool? value) {
                widget.service.todoList[widget.index].checked = value ?? false;
                stateChange.value = value ?? false;
                StorageService().storeTodoItems(widget.service.todoList);
              },
            );
          },
        ),
      ),
    );
  }
}
