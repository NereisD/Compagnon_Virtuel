import 'package:compagnon/values/constants.dart';
import 'package:compagnon/models/todo.dart';
import 'package:compagnon/providers/todos.dart';
import 'package:compagnon/pages/journal/components/todo_form_widget.dart';
import 'package:compagnon/values/languages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTodoDialogWidget extends StatefulWidget {
  @override
  _AddTodoDialogWidgetState createState() => _AddTodoDialogWidgetState();
}

class _AddTodoDialogWidgetState extends State<AddTodoDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';

  @override
  Widget build(BuildContext context) => AlertDialog(
        content: Form(
          key: _formKey, //pour valider les fields (titre et description)
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                addNoteField[lang],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              TodoFormWidget(
                /*Ajoute l'heure:minutes par défault à l'affichage.
                * Attention cette variable ne change pas le state,
                * donc this.title sera vide.
                */
                title: DateFormat.Hm().format(DateTime.now()),
                /*
                title: DateTime.now().minute.toInt() < 10
                    ? DateTime.now().hour.toString() +
                        ':0' +
                        DateTime.now().minute.toString()
                    : DateTime.now().hour.toString() +
                        ':' +
                        DateTime.now().minute.toString(),*/
                onChangedTitle: (title) => setState(() => this.title = title),
                onChangedDescription: (description) =>
                    setState(() => this.description = description),
                onSavedTodo: addTodo,
              ),
            ],
          ),
        ),
      );

  /* Fonction pour ajouter une note au journal
  */
  void addTodo() {
    final isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    } else {
      final todo = Todo(
        number: DateTime.now().toString(),
        //Si le titre est vide on écrit l'heure:minutes
        title: title.isEmpty ? DateFormat.Hm().format(DateTime.now()) : title,
        description: description,
        createdTime: DateTime.now(),
      );

      final provider = Provider.of<TodosProvider>(context, listen: false);
      provider.addTodo(todo);

      Navigator.of(context).pop();
    }
  }
}
