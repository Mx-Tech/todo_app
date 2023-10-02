import 'dart:convert';

import 'package:boringDos/models/todo_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;

  factory StorageService() => _instance ??= StorageService._internal();

  /// We instantiate the shared preferences here. As we should not use an await
  /// statement inside a constructor, whe use the future returned by [SharedPreferences.getInstance}
  /// and assign the returned value to the variable [_sharedPreferences].
  /// To make correct use of the service, we should instantiate it while starting the app.
  /// To avoid waiting for the future for multiple times, we use a facotry constructor
  /// in our [StorageService] so the instance of [SharedPreferences] is kept alive
  /// as long as the app is running.
  /// By using the underscore, we can make the factory constructor privat,
  StorageService._internal();

  late final SharedPreferences _sharedPreferences;

  Future<void> initialize() {
    return SharedPreferences.getInstance()
        .then((value) => _sharedPreferences = value);
  }

  /// [todoItemKey] is a static variable to avoid typos while using the key!
  static String todoItemKey = "todoItemKey";

  /// Convenience function to store the item list
  Future<bool> storeTodoItems(List<TodoItem> items) {
    return _sharedPreferences.setString(todoItemKey, jsonEncode(items));
  }

  /// Convenience function to retrieve the item list.
  List<TodoItem> getTodoItems() {
    String? itemList = _sharedPreferences.getString(todoItemKey);
    if (itemList == null) {
      /// If [itemList] is null, then there are no entries!
      return [];
    }

    /// At this point, flutter can not evaluate which data might return from the json.
    /// So we are going to take care of the types!
    var jsonItems = jsonDecode(itemList);
    if (jsonItems is List) {
      List<TodoItem> items =
          jsonItems.map((e) => TodoItem.fromJson(e)).toList();
      return items;
    }
    return [];
  }
}
