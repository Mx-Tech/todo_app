import 'package:boringDos/home/services/home_detail_service.dart';
import 'package:boringDos/utils/constants.dart';
import 'package:flutter/material.dart';

class HomeDetailPage extends StatefulWidget {
  const HomeDetailPage({Key? key}) : super(key: key);

  static const routeName = '/homeDetailPage';

  @override
  State<HomeDetailPage> createState() => _HomeDetailPageState();
}

class _HomeDetailPageState extends State<HomeDetailPage> {
  late final HomeDetailService service;

  @override
  void initState() {
    super.initState();
    service = HomeDetailService();
  }

  @override
  Widget build(BuildContext context) {
    service.init(context);

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(service.item);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(service.item.title),
        ),
        body: Padding(
          padding: Paddings.all(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _checkBox(),
              ..._comment(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkBox() {
    return CheckboxListTile(
      value: service.item.checked,
      title: const Text("Status"),
      onChanged: (value) {
        setState(() {
          service.item = service.item.copyWith(checked: value ?? false);
        });
      },
    );
  }

  List<Widget> _comment() {
    return [
      const Text("Comment:"),
      TextField(
        controller: service.commentController,
        onChanged: (value) =>
            service.item = service.item.copyWith(comment: value),
      ),
    ];
  }
}
