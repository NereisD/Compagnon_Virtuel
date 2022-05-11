// ignore_for_file: prefer_final_fields

import 'package:compagnon/db/notes_database.dart';
import 'package:compagnon/models/todo.dart';
import 'package:flutter/cupertino.dart';


class TodosProvider extends ChangeNotifier {
  /*
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
  ];*/

  List<Todo> _todos = [];

  //Future<List<Todo>> future_todos = NotesDatabase.instance.readAllNotes();

  //Pour refresh la list des notes
  Future refreshNotes() async {
    _todos = await NotesDatabase.instance.readAllNotes();
  }

  /* permet de reload l'UI apres le temps d'accès à la BD
  */
  Future reloadUI() async {
    await Future.delayed(const Duration(milliseconds: 200));
    notifyListeners();
  }

  //Pour filtrer les todos non secrets
  List<Todo> get todos =>
      _todos.where((todo) => todo.isSecret == false).toList();

  //Pour filtrer les todos secrets
  List<Todo> get todosSecret =>
      _todos.where((todo) => todo.isSecret == true).toList();

  void addTodo(Todo todo) {
    _todos.add(todo);
    NotesDatabase.instance.create(todo); //Creer une todo dans la DB
    notifyListeners(); //update UI
    reloadUI();
  }

  void removeTodo(Todo todo) {
    _todos.remove(todo);
    NotesDatabase.instance.delete(todo.id); //Supprime une todo dans la DB
    notifyListeners(); //update UI
    reloadUI();
  }

  bool toggleTodoStatus(Todo todo) {
    todo.isSecret = !todo.isSecret;
    NotesDatabase.instance.update(todo); //Update une todo dans la DB
    notifyListeners(); //update UI
    reloadUI();
    return todo.isSecret;
  }

  void updateTodo(Todo todo, String title, String description) {
    todo.title = title;
    todo.description = description;
    NotesDatabase.instance.update(todo); //Update une todo dans la DB
    notifyListeners(); //update UI
    reloadUI();
  }
}
