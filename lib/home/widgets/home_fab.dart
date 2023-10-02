import 'package:boringDos/home/services/home_page_service.dart';
import 'package:flutter/material.dart';

/// [HomePageFloatingActionButton]
/// This widget was build to open up a bottom sheet which
/// allows one to set the title of a todo item
/// as well as finishing the creation
class HomePageFloatingActionButton extends StatelessWidget {
  final HomePageService service;
  final Function(String? label) update;

  const HomePageFloatingActionButton(this.service,
      {required this.update, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
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
                    _textFormField(),
                    const Divider(),
                    _iconButton(context),
                  ],
                ),
              ),
            );
          },
        ).then((value) => update(value));
      },
      child: const Icon(Icons.add),
    );
  }

  TextFormField _textFormField() {
    return TextFormField(
      controller: service.todoTitleController,
      decoration: const InputDecoration(hintText: "Enter your ToDo!"),
      validator: (value) {
        /// As we want to prevent our app from displaying emtpy
        /// items we need some validation!
        if (value == null || value.isEmpty) {
          return "Please add some information!";
        }

        /// If the validator functions returns [null] everything is fine.
        return null;
      },
    );
  }

  Align _iconButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () {
          Navigator.of(context).pop(service.todoTitleController.text);
        },
        icon: const Icon(Icons.check),
      ),
    );
  }
}
