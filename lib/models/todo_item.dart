class TodoItem {
  String title;
  bool checked;
  String comment;

  TodoItem(this.title, this.checked, {this.comment = ""});

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    String title = json["title"];
    bool checked = json["checked"];
    String comment = json["comment"];
    return TodoItem(title, checked, comment: comment);
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "checked": checked,
      "comment": comment,
    };
  }
}
