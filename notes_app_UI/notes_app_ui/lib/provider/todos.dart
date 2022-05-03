import 'package:flutter/cupertino.dart';
import 'package:notes_app_ui/model/todo.dart';

class TodosProvider extends ChangeNotifier {
  List<Todo> _todos = [
    Todo(
        createdTime: DateTime.now(),
        title: 'Work on flutter',
        description: '''- finish this project
      - eat some bananas
      - do the sqflite
      - wrap messages by date'''),
    Todo(
      createdTime: DateTime.now(),
      title: 'Walk the dog',
    ),
    Todo(
        createdTime: DateTime.now(),
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
