import 'package:json_annotation/json_annotation.dart';

/// Currently the file is not available, as we need to generate it via
/// flutter pub run build_runner build
part 'todo_item.g.dart';

@JsonSerializable()
class TodoItem {
  final String title;
  bool checked;
  String comment;

  TodoItem(this.title, this.checked, {this.comment = ""});

  /// Connect the generated [_$TodoItemFromJson] function to the `fromJson`
  /// factory.
  factory TodoItem.fromJson(Map<String, dynamic> json) => _$TodoItemFromJson(json);

  /// Connect the generated [_$TodoItemToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TodoItemToJson(this);
}