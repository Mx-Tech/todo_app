import 'package:app/home/detail.dart';
import 'package:app/home/index.dart';
import 'package:app/services/storage.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      initialRoute: "/",
      routes: {
        HomeDetailPage.routeName: (context) => const HomeDetailPage(),
      },
    );
  }
}
