import 'package:flutter/cupertino.dart';

final String tableNotes = 'notes';

class TodoField {
  static final List<String> values = [
    id,
    isSecret,
    number,
    title,
    description,
    createdTime
  ];

  static const String id = '_id';
  static const String isSecret = 'isSecret';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String createdTime = 'createdTime'; //const ou final ?
}

class Todo {
  int id;
  DateTime createdTime;
  String title;
  String number;
  String description;
  bool isSecret;

  Todo({
    @required this.createdTime,
    @required this.title,
    this.description = '',
    this.id,
    this.number,
    this.isSecret = false,
  });

  Todo copy({
    int id,
    DateTime createdTime,
    String title,
    String number,
    String description,
    bool isSecret,
  }) =>
      Todo(
        id: id ?? this.id,
        createdTime: createdTime ?? this.createdTime,
        title: title ?? this.title,
        number: number ?? this.number,
        description: description ?? this.description,
        isSecret: isSecret ?? this.isSecret,
      );

  //Transforme un Json en map
  static Todo fromJson(Map<String, Object> json) => Todo(
      id: json[TodoField.id] as int,
      isSecret: json[TodoField.isSecret] == 1, //True si 1 false si 0
      number: json[TodoField.number] as String,
      title: json[TodoField.title] as String,
      description: json[TodoField.description] as String,
      createdTime: DateTime.parse(
        json[TodoField.createdTime] as String,
      ));

  //Transforme une map to Json
  Map<String, Object> toJson() => {
        TodoField.id: id,
        TodoField.title: title,
        TodoField.description: description,
        TodoField.isSecret: isSecret ? 1 : 0,
        TodoField.number: number,
        TodoField.createdTime: createdTime.toIso8601String(),
      };
}
