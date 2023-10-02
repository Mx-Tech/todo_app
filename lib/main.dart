import 'package:boringDos/home/pages/detail.dart';
import 'package:boringDos/home/pages/home_page.dart';
import 'package:boringDos/home/services/home_page_service.dart';
import 'package:boringDos/services/storage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Runs the app, when the shared preferences instance was loaded correctly!
  await StorageService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Another Boring Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(HomePageService()),
      initialRoute: "/",
      routes: {
        HomeDetailPage.routeName: (context) => const HomeDetailPage(),
      },
    );
  }
}
