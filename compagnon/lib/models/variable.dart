import 'package:flutter/cupertino.dart';

final String tableVariables = 'variables';

class VariableField {
  static final List<String> values = [
    id,
    name,
    value,
    createdTime,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String value = 'value';
  static const String createdTime = 'createdTime';
}

class Variable {
  int id;
  DateTime createdTime;
  String name; //Nom de la variable
  String value; //valeur (exemple : 'homme')

  Variable({
    this.id,
    @required this.createdTime,
    @required this.name,
    this.value = '',
  });

  Variable copy({
    int id,
    DateTime createdTime,
    String name,
    String value,
  }) =>
      Variable(
        id: id ?? this.id,
        createdTime: createdTime ?? this.createdTime,
        name: name ?? this.name,
        value: value ?? this.value,
      );

  //Transforme un Json en map
  static Variable fromJson(Map<String, Object> json) => Variable(
      id: json[VariableField.id] as int,
      name: json[VariableField.name] as String,
      value: json[VariableField.value] as String,
      createdTime: DateTime.parse(
        json[VariableField.createdTime] as String,
      ));

  String getName() {
    return name;
  }

  //Transforme une map to Json
  Map<String, Object> toJson() => {
        VariableField.id: id,
        VariableField.name: name,
        VariableField.value: value,
        VariableField.createdTime: createdTime.toIso8601String(),
      };

  void displayContent() {
    print("--- Content variable : ---");
    print("id : $id");
    print("createdTime : $createdTime");
    print("name : $name");
    print("value : $value");
  }
}
