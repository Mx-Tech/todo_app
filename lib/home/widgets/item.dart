import 'package:boringDos/home/services/home_page_service.dart';
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
      onLongPress: () => widget.service
          .navigateToDetailPage(context, index: widget.index)
          .then((value) {
        stateChange.value = value?.checked ?? false;
      }),
      child: Dismissible(
        key: ValueKey<int>(_itemHashCode),
        onDismissed: (_) => widget.service.removeAt(widget.index),
        background: _background(),
        child: _item(),
      ),
    );
  }

  int get _itemHashCode =>
      widget.index.hashCode ^ widget.service.todoList[widget.index].hashCode;

  Container _background() {
    return Container(
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
    );
  }

  ValueListenableBuilder<bool> _item() {
    return ValueListenableBuilder(
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
            stateChange.value = value ?? false;
            widget.service.update(widget.index, value: value);
          },
        );
      },
    );
  }
}
