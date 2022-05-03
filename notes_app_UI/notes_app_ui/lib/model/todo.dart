import 'package:flutter/cupertino.dart';

class TodoField {
  static const createdTime = 'createdTime';
}

class Todo {
  DateTime createdTime;
  String title;
  String id;
  String description;
  bool isSecret;

  Todo({
    @required this.createdTime,
    @required this.title,
    this.description = '',
    this.id,
    this.isSecret = false,
  });
}
