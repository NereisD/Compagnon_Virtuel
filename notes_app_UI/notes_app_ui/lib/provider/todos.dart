// ignore_for_file: prefer_final_fields

import 'package:flutter/cupertino.dart';
import 'package:notes_app_ui/model/todo.dart';

class TodosProvider extends ChangeNotifier {
  List<Todo> _todos = [
    Todo(
        createdTime: DateTime.now().subtract(Duration(days: 2, minutes: 1)),
        title: 'Work on flutter',
        description: '''- finish this project
- eat some bananas
- do the sqflite
- wrap messages by date'''),
    Todo(
      createdTime: DateTime.now().subtract(Duration(days: 2, minutes: 2)),
      title: 'Biking 🚴‍♂️',
    ),
    Todo(
        createdTime: DateTime.now().subtract(Duration(days: 2, minutes: 3)),
        title: 'Liste de course',
        description: '''- bananes
- salade'''),
  ];

  //Pour filtrer les todos non secrets
  List<Todo> get todos =>
      _todos.where((todo) => todo.isSecret == false).toList();

  //Pour filtrer les todos secrets
  List<Todo> get todosSecret =>
      _todos.where((todo) => todo.isSecret == true).toList();

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners(); //update UI
  }

  void removeTodo(Todo todo) {
    _todos.remove(todo);
    notifyListeners(); //update UI
  }

  bool toggleTodoStatus(Todo todo) {
    todo.isSecret = !todo.isSecret;
    notifyListeners(); //update UI

    return todo.isSecret;
  }

  void updateTodo(Todo todo, String title, String description) {
    todo.title = title;
    todo.description = description;
    notifyListeners(); //update UI
  }
}
